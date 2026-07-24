package com.english.learning.service;

import com.english.learning.dto.BadgeDto;

import java.util.List;
import java.util.Optional;

public interface BadgeService {
    List<BadgeDto> getUserBadges(Long userId);
    
    List<BadgeDto> getUserBadgesByCategory(Long userId, String category);
    
    Optional<BadgeDto> getUserBadgeById(Long userId, String badgeId);
    
    BadgeDto awardBadgeToUser(Long userId, BadgeDto badgeDto);
    
    void checkAndAwardBadges(Long userId);
    
    int calculateBadgeCompletion(Long userId);
} 