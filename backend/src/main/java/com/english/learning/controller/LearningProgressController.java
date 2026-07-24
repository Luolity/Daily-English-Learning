package com.english.learning.controller;

import com.english.learning.dto.LearningProgressDto;
import com.english.learning.dto.MessageResponse;
import com.english.learning.security.services.UserDetailsImpl;
import com.english.learning.service.BadgeService;
import com.english.learning.service.LearningProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/progress")
public class LearningProgressController {

    @Autowired
    private LearningProgressService learningProgressService;

    @Autowired
    private BadgeService badgeService;

    @GetMapping
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserProgressHistory(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        List<LearningProgressDto> progressHistory = learningProgressService.getUserProgressHistory(userDetails.getId());
        return ResponseEntity.ok(progressHistory);
    }

    @GetMapping("/date/{date}")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserProgressByDate(
            @PathVariable String date,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return learningProgressService.getUserProgressByDate(userDetails.getId(), date)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/stats")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserStats(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        Long userId = userDetails.getId();
        
        Integer totalWordsLearned = learningProgressService.getUserTotalWordsLearned(userId);
        Integer totalTimeSpent = learningProgressService.getUserTotalTimeSpent(userId);
        Double correctRate = learningProgressService.getUserCorrectRate(userId);
        Integer learningStreak = learningProgressService.getUserLearningStreak(userId);
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalWordsLearned", totalWordsLearned);
        stats.put("totalTimeSpent", totalTimeSpent);
        stats.put("correctRate", correctRate);
        stats.put("learningStreak", learningStreak);
        
        return ResponseEntity.ok(stats);
    }

    @PostMapping
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> updateProgress(
            @Valid @RequestBody LearningProgressDto progressDto,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        Long userId = userDetails.getId();
        
        // 更新学习进度
        LearningProgressDto updatedProgress = learningProgressService.createOrUpdateProgress(userId, progressDto);
        
        // 检查并发放徽章
        badgeService.checkAndAwardBadges(userId);
        
        return ResponseEntity.ok(updatedProgress);
    }

    @GetMapping("/streak")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserLearningStreak(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        Integer learningStreak = learningProgressService.getUserLearningStreak(userDetails.getId());
        return ResponseEntity.ok(new MessageResponse(learningStreak.toString()));
    }

    @PutMapping("/streak")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> updateUserLearningStreak(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        learningProgressService.updateUserLearningStreak(userDetails.getId());
        return ResponseEntity.ok(new MessageResponse("Learning streak updated successfully"));
    }
} 