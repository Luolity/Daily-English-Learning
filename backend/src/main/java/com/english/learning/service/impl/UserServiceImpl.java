package com.english.learning.service.impl;

import com.english.learning.dto.BadgeDto;
import com.english.learning.dto.LearningProgressDto;
import com.english.learning.dto.UserInfoDto;
import com.english.learning.mapper.UserMapper;
import com.english.learning.mapper.UserRoleMapper;
import com.english.learning.model.Badge;
import com.english.learning.model.LearningProgress;
import com.english.learning.model.Role;
import com.english.learning.model.User;
import com.english.learning.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private UserRoleMapper userRoleMapper;

    @Autowired
    private PasswordEncoder encoder;

    @Override
    public Optional<UserInfoDto> getUserById(Long id) {
        User user = userMapper.selectById(id);
        return Optional.ofNullable(user).map(this::convertToDto);
    }

    @Override
    public Optional<UserInfoDto> getUserByUsername(String username) {
        User user = userMapper.findByUsername(username);
        return Optional.ofNullable(user).map(this::convertToDto);
    }

    @Override
    @Transactional
    public UserInfoDto updateUserProfile(Long id, UserInfoDto userInfoDto) {
        User user = userMapper.selectById(id);
        if (user == null) {
            throw new IllegalArgumentException("User not found with id: " + id);
        }
        
        // 更新基本信息
        if (userInfoDto.getNickname() != null) {
            user.setNickname(userInfoDto.getNickname());
        }
        
        if (userInfoDto.getAvatar() != null) {
            user.setAvatar(userInfoDto.getAvatar());
        }
        
        // 保存用户
        userMapper.updateById(user);
        
        return convertToDto(user);
    }

    @Override
    @Transactional
    public void updateUserLearningStats(Long userId, int wordsLearned, int timeSpent, int correctCount, int totalCount) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found with id: " + userId);
        }
        
        // 更新学习统计
        user.setTotalWords(user.getTotalWords() + wordsLearned);
        user.setTotalTime(user.getTotalTime() + timeSpent);
        
        // 更新正确率
        if (totalCount > 0) {
            double totalCorrect = user.getCorrectRate() * user.getTotalWords() + correctCount;
            double totalQuestions = user.getTotalWords() + totalCount;
            user.setCorrectRate(totalCorrect / totalQuestions);
        }
        
        // 更新最后学习日期
        String today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
        String lastStudyDate = user.getLastStudyDate();
        
        if (lastStudyDate == null || !lastStudyDate.equals(today)) {
            if (lastStudyDate != null) {
                LocalDate lastDate = LocalDate.parse(lastStudyDate, DateTimeFormatter.ISO_LOCAL_DATE);
                LocalDate todayDate = LocalDate.parse(today, DateTimeFormatter.ISO_LOCAL_DATE);
                
                if (lastDate.plusDays(1).equals(todayDate)) {
                    // 连续学习
                    user.setLearningStreak(user.getLearningStreak() + 1);
                } else {
                    // 学习中断
                    user.setLearningStreak(1);
                }
            } else {
                // 第一次学习
                user.setLearningStreak(1);
            }
            
            user.setLastStudyDate(today);
        }
        
        userMapper.updateById(user);
    }

    @Override
    public boolean existsByUsername(String username) {
        return userMapper.existsByUsername(username);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userMapper.existsByEmail(email);
    }

    @Override
    @Transactional
    public User save(User user) {
        // 保存用户基本信息
        userMapper.insert(user);
        
        // 保存用户角色关系
        if (user.getRoles() != null && !user.getRoles().isEmpty()) {
            for (Role role : user.getRoles()) {
                userRoleMapper.insertUserRole(user.getId(), role.getId());
            }
        }
        
        return user;
    }

    // 转换实体到DTO
    private UserInfoDto convertToDto(User user) {
        // 获取用户角色
        List<Role> roles = userRoleMapper.findRolesByUserId(user.getId());
        List<String> roleNames = roles.stream()
                .map(role -> role.getName().name())
                .collect(Collectors.toList());
        
        Set<LearningProgressDto> progressDtos = new HashSet<>();
        
        Set<BadgeDto> badgeDtos = new HashSet<>();
        
        return UserInfoDto.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .avatar(user.getAvatar())
                .roles(roleNames)
                .learningStreak(user.getLearningStreak())
                .lastStudyDate(user.getLastStudyDate())
                .totalWords(user.getTotalWords())
                .totalTime(user.getTotalTime())
                .correctRate(user.getCorrectRate())
                .dailyStats(progressDtos)
                .badges(badgeDtos)
                .build();
    }
    
    // 转换学习进度实体到DTO
    private LearningProgressDto convertProgressToDto(LearningProgress progress) {
        return LearningProgressDto.builder()
                .id(progress.getId())
                .date(progress.getDate())
                .wordsLearned(progress.getWordsLearned())
                .timeSpent(progress.getTimeSpent())
                .correctCount(progress.getCorrectCount())
                .totalCount(progress.getTotalCount())
                .build();
    }
    
    // 转换徽章实体到DTO
    private BadgeDto convertBadgeToDto(Badge badge) {
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