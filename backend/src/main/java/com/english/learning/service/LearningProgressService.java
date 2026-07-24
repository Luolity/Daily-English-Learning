package com.english.learning.service;

import com.english.learning.dto.LearningProgressDto;

import java.util.List;
import java.util.Optional;

public interface LearningProgressService {
    LearningProgressDto createOrUpdateProgress(Long userId, LearningProgressDto progressDto);
    
    List<LearningProgressDto> getUserProgressHistory(Long userId);
    
    Optional<LearningProgressDto> getUserProgressByDate(Long userId, String date);
    
    Integer getUserTotalWordsLearned(Long userId);
    
    Integer getUserTotalTimeSpent(Long userId);
    
    Double getUserCorrectRate(Long userId);
    
    Integer getUserLearningStreak(Long userId);
    
    void updateUserLearningStreak(Long userId);
} 