package com.english.learning.service.impl;

import com.english.learning.dto.LearningProgressDto;
import com.english.learning.mapper.LearningProgressMapper;
import com.english.learning.mapper.UserMapper;
import com.english.learning.model.LearningProgress;
import com.english.learning.model.User;
import com.english.learning.service.LearningProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class LearningProgressServiceImpl implements LearningProgressService {

    @Autowired
    private LearningProgressMapper learningProgressMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    @Transactional
    public LearningProgressDto createOrUpdateProgress(Long userId, LearningProgressDto progressDto) {
        // 获取当前日期
        String today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
        
        // 查找用户今天的学习记录
        LearningProgress existingProgress = learningProgressMapper.findByUserIdAndDate(userId, today);
        
        // 查找用户
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found with id: " + userId);
        }
        
        LearningProgress progress;
        
        if (existingProgress != null) {
            // 更新现有记录
            progress = existingProgress;
            progress.setWordsLearned(progress.getWordsLearned() + progressDto.getWordsLearned());
            progress.setTimeSpent(progress.getTimeSpent() + progressDto.getTimeSpent());
            progress.setCorrectCount(progress.getCorrectCount() + progressDto.getCorrectCount());
            progress.setTotalCount(progress.getTotalCount() + progressDto.getTotalCount());
        } else {
            // 创建新记录
            progress = LearningProgress.builder()
                    .userId(userId)
                    .date(today)
                    .wordsLearned(progressDto.getWordsLearned())
                    .timeSpent(progressDto.getTimeSpent())
                    .correctCount(progressDto.getCorrectCount())
                    .totalCount(progressDto.getTotalCount())
                    .build();
        }
        
        // 保存学习进度
        if (existingProgress != null) {
            learningProgressMapper.updateById(progress);
        } else {
            learningProgressMapper.insert(progress);
        }
        
        // 更新用户统计信息
        user.setTotalWords(user.getTotalWords() + progressDto.getWordsLearned());
        user.setTotalTime(user.getTotalTime() + progressDto.getTimeSpent());
        
        // 更新正确率
        if (progressDto.getTotalCount() > 0) {
            double totalCorrect = user.getCorrectRate() * user.getTotalWords() + progressDto.getCorrectCount();
            double totalQuestions = user.getTotalWords() + progressDto.getTotalCount();
            user.setCorrectRate(totalCorrect / totalQuestions);
        }
        
        // 更新学习连续天数
        updateUserLearningStreak(userId);
        
        // 保存用户信息
        userMapper.updateById(user);
        
        return convertToDto(progress);
    }

    @Override
    public List<LearningProgressDto> getUserProgressHistory(Long userId) {
        return learningProgressMapper.findByUserIdOrderByDateDesc(userId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<LearningProgressDto> getUserProgressByDate(Long userId, String date) {
        LearningProgress progress = learningProgressMapper.findByUserIdAndDate(userId, date);
        return Optional.ofNullable(progress).map(this::convertToDto);
    }

    @Override
    public Integer getUserTotalWordsLearned(Long userId) {
        Integer totalWords = learningProgressMapper.getTotalWordsLearnedByUserId(userId);
        return totalWords != null ? totalWords : 0;
    }

    @Override
    public Integer getUserTotalTimeSpent(Long userId) {
        Integer totalTime = learningProgressMapper.getTotalTimeSpentByUserId(userId);
        return totalTime != null ? totalTime : 0;
    }

    @Override
    public Double getUserCorrectRate(Long userId) {
        Integer correctCount = learningProgressMapper.getTotalCorrectCountByUserId(userId);
        Integer totalCount = learningProgressMapper.getTotalCountByUserId(userId);
        
        if (totalCount != null && totalCount > 0 && correctCount != null) {
            return (double) correctCount / totalCount;
        }
        return 0.0;
    }

    @Override
    public Integer getUserLearningStreak(Long userId) {
        User user = userMapper.selectById(userId);
        return user != null ? user.getLearningStreak() : 0;
    }

    @Override
    @Transactional
    public void updateUserLearningStreak(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return;
        }
        
        String today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
        
        // 检查是否今天已经学习
        boolean hasStudiedToday = learningProgressMapper.findByUserIdAndDate(userId, today) != null;
        if (!hasStudiedToday) {
            return; // 今天没有学习记录，不更新连续天数
        }
        
        String lastStudyDate = user.getLastStudyDate();
        if (lastStudyDate == null || lastStudyDate.isEmpty()) {
            // 第一次学习
            user.setLearningStreak(1);
            user.setLastStudyDate(today);
        } else if (lastStudyDate.equals(today)) {
            // 今天已经学习过，不改变连续天数
            return;
        } else {
            // 检查是否连续学习
            LocalDate lastDate = LocalDate.parse(lastStudyDate, DateTimeFormatter.ISO_LOCAL_DATE);
            LocalDate todayDate = LocalDate.parse(today, DateTimeFormatter.ISO_LOCAL_DATE);
            
            long daysBetween = ChronoUnit.DAYS.between(lastDate, todayDate);
            
            if (daysBetween == 1) {
                // 连续学习
                user.setLearningStreak(user.getLearningStreak() + 1);
            } else {
                // 中断了，重新开始计数
                user.setLearningStreak(1);
            }
            user.setLastStudyDate(today);
        }
        
        userMapper.updateById(user);
    }

    // 转换实体到DTO
    private LearningProgressDto convertToDto(LearningProgress progress) {
        return LearningProgressDto.builder()
                .id(progress.getId())
                .date(progress.getDate())
                .wordsLearned(progress.getWordsLearned())
                .timeSpent(progress.getTimeSpent())
                .correctCount(progress.getCorrectCount())
                .totalCount(progress.getTotalCount())
                .build();
    }
} 