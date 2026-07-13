package com.english.learning.service;

import com.english.learning.dto.UserInfoDto;
import com.english.learning.model.User;

import java.util.Optional;

public interface UserService {
    Optional<UserInfoDto> getUserById(Long id);
    
    Optional<UserInfoDto> getUserByUsername(String username);
    
    UserInfoDto updateUserProfile(Long id, UserInfoDto userInfoDto);
    
    void updateUserLearningStats(Long userId, int wordsLearned, int timeSpent, int correctCount, int totalCount);
    
    boolean existsByUsername(String username);
    
    boolean existsByEmail(String email);
    
    User save(User user);
} 