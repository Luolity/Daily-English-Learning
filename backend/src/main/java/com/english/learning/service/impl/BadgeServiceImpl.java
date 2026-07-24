package com.english.learning.service.impl;

import com.english.learning.dto.BadgeDto;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.english.learning.mapper.BadgeMapper;
import com.english.learning.mapper.ChallengeRecordMapper;
import com.english.learning.mapper.LearningProgressMapper;
import com.english.learning.mapper.UserMapper;
import com.english.learning.model.Badge;
import com.english.learning.model.ChallengeRecord;
import com.english.learning.model.User;
import com.english.learning.service.BadgeService;
import com.english.learning.service.LearningProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BadgeServiceImpl implements BadgeService {

    @Autowired
    private BadgeMapper badgeMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private LearningProgressMapper learningProgressMapper;

    @Autowired
    private LearningProgressService learningProgressService;

    @Autowired
    private ChallengeRecordMapper challengeRecordMapper;

    @Override
    @Transactional(readOnly = true)
    public List<BadgeDto> getUserBadges(Long userId) {
        return badgeMapper.findByUserId(userId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<BadgeDto> getUserBadgesByCategory(Long userId, String category) {
        return badgeMapper.findByUserIdAndCategory(userId, category).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<BadgeDto> getUserBadgeById(Long userId, String badgeId) {
        Badge badge = badgeMapper.findByUserIdAndBadgeId(userId, badgeId);
        return Optional.ofNullable(badge).map(this::convertToDto);
    }

    @Override
    @Transactional
    public BadgeDto awardBadgeToUser(Long userId, BadgeDto badgeDto) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("User not found with id: " + userId);
        }
        
        // 检查徽章是否已存在
        if (badgeMapper.existsByUserIdAndBadgeId(userId, badgeDto.getBadgeId())) {
            throw new RuntimeException("Badge already awarded to user");
        }
        
        // 创建徽章
        Badge badge = Badge.builder()
                .badgeId(badgeDto.getBadgeId())
                .name(badgeDto.getName())
                .description(badgeDto.getDescription())
                .icon(badgeDto.getIcon())
                .level(badgeDto.getLevel())
                .category(badgeDto.getCategory())
                .dateEarned(LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .userId(userId)
                .build();
        
        // 保存徽章
        badgeMapper.insert(badge);
        
        return convertToDto(badge);
    }

    @Override
    @Transactional
    public void checkAndAwardBadges(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("User not found with id: " + userId);
        }

        int streak = learningProgressService.getUserLearningStreak(userId);
        int totalWords = learningProgressService.getUserTotalWordsLearned(userId);
        double correctRate = learningProgressService.getUserCorrectRate(userId);
        int totalTime = learningProgressService.getUserTotalTimeSpent(userId);
        boolean hasStudied = totalWords > 0 || totalTime > 0
                || !learningProgressMapper.findByUserIdOrderByDateDesc(userId).isEmpty();

        checkStreakBadges(user, streak);
        checkVocabularyBadges(user, totalWords);
        checkAccuracyBadges(user, correctRate);
        checkChallengeBadges(user);
        checkSpecialBadges(user, hasStudied, totalTime);
    }
    
    private void checkStreakBadges(User user, int streak) {
        
        if (streak >= 3 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "streak_3")) {
            awardBadge(user, "streak_3", "初学乍练", "连续学习3天", "streak-3", "bronze", "streak");
        }
        
        if (streak >= 7 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "streak_7")) {
            awardBadge(user, "streak_7", "坚持不懈", "连续学习7天", "streak-7", "silver", "streak");
        }
        
        if (streak >= 30 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "streak_30")) {
            awardBadge(user, "streak_30", "习惯养成", "连续学习30天", "streak-30", "gold", "streak");
        }
        
        if (streak >= 100 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "streak_100")) {
            awardBadge(user, "streak_100", "英语大师", "连续学习100天", "streak-100", "platinum", "streak");
        }
    }
    
    private void checkVocabularyBadges(User user, int totalWords) {
        
        if (totalWords >= 50 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "vocabulary_50")) {
            awardBadge(user, "vocabulary_50", "词汇新手", "学习50个单词", "vocab-50", "bronze", "vocabulary");
        }
        
        if (totalWords >= 200 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "vocabulary_200")) {
            awardBadge(user, "vocabulary_200", "词汇收藏家", "学习200个单词", "vocab-200", "silver", "vocabulary");
        }
        
        if (totalWords >= 500 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "vocabulary_500")) {
            awardBadge(user, "vocabulary_500", "词汇大师", "学习500个单词", "vocab-500", "gold", "vocabulary");
        }
    }
    
    private void checkAccuracyBadges(User user, double correctRate) {
        
        if (correctRate >= 0.8 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "accuracy_80")) {
            awardBadge(user, "accuracy_80", "精准学习者", "正确率达到80%", "accuracy-80", "silver", "challenge");
        }
        
        if (correctRate >= 0.95 && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "accuracy_95")) {
            awardBadge(user, "accuracy_95", "学霸", "正确率达到95%", "accuracy-95", "gold", "challenge");
        }
    }
    
    private void checkChallengeBadges(User user) {
        Long userId = user.getId();
        long challengeCount = challengeRecordMapper.selectCount(
                new LambdaQueryWrapper<ChallengeRecord>().eq(ChallengeRecord::getUserId, userId));

        if (challengeCount >= 10 && !badgeMapper.existsByUserIdAndBadgeId(userId, "challenge_master")) {
            awardBadge(user, "challenge_master", "挑战大师", "完成10次挑战", "challenge-master", "silver", "challenge");
        }

        List<ChallengeRecord> records = challengeRecordMapper.selectList(
                new LambdaQueryWrapper<ChallengeRecord>().eq(ChallengeRecord::getUserId, userId));
        boolean hasPerfect = records.stream().anyMatch(r ->
                r.getTotalQuestions() != null && r.getTotalQuestions() >= 10
                        && r.getScore() != null && r.getScore().equals(r.getTotalQuestions()));
        if (hasPerfect && !badgeMapper.existsByUserIdAndBadgeId(userId, "challenge_perfect")) {
            awardBadge(user, "challenge_perfect", "完美挑战", "在挑战中获得100%正确率", "challenge-perfect", "gold", "challenge");
        }
    }

    private void checkSpecialBadges(User user, boolean hasStudied, int totalTime) {
        if (hasStudied && totalTime >= 0
                && !badgeMapper.existsByUserIdAndBadgeId(user.getId(), "special_first_day")) {
            awardBadge(user, "special_first_day", "初来乍到", "完成第一天的学习", "special-first", "bronze", "special");
        }
    }

    @Transactional
    private void awardBadge(User user, String badgeId, String name, String description, String icon, String level, String category) {
        Badge badge = Badge.builder()
                .badgeId(badgeId)
                .name(name)
                .description(description)
                .icon(icon)
                .level(level)
                .category(category)
                .dateEarned(LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .userId(user.getId())
                .build();
        
        badgeMapper.insert(badge);
    }

    @Override
    @Transactional(readOnly = true)
    public int calculateBadgeCompletion(Long userId) {
        // 获取所有可能的徽章总数（这里只是一个示例，实际上需要根据系统中定义的徽章来计算）
        int totalPossibleBadges = 12;
        
        // 获取用户已获得的徽章数量
        int userBadgesCount = badgeMapper.findByUserId(userId).size();
        
        // 计算完成度百分比
        return (int) Math.round((double) userBadgesCount / totalPossibleBadges * 100);
    }

    // 转换实体到DTO
    private BadgeDto convertToDto(Badge badge) {
        return BadgeDto.builder()
                .id(badge.getId())
                .badgeId(badge.getBadgeId())
                .name(badge.getName())
                .description(badge.getDescription())
                .icon(badge.getIcon())
                .level(badge.getLevel())
                .category(badge.getCategory())
                .dateEarned(badge.getDateEarned())
                .build();
    }
} 