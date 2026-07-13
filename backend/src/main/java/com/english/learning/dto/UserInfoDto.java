package com.english.learning.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserInfoDto {
    private Long id;
    private String username;
    private String email;
    private String nickname;
    private String avatar;
    private List<String> roles;
    private int learningStreak;
    private String lastStudyDate;
    private int totalWords;
    private int totalTime;
    private double correctRate;
    private Set<LearningProgressDto> dailyStats;
    private Set<BadgeDto> badges;
} 