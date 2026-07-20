package com.english.learning.controller;

import com.english.learning.dto.ChallengeRecordDto;
import com.english.learning.security.services.UserDetailsImpl;
import com.english.learning.service.ChallengeRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/challenge")
public class ChallengeRecordController {

    @Autowired
    private ChallengeRecordService challengeRecordService;

    @PostMapping("/submit")
    // @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> submitChallengeRecord(
            @RequestBody ChallengeRecordDto recordDto,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        Long userId = userDetails.getId();
        ChallengeRecordDto savedRecord = challengeRecordService.submitRecord(userId, recordDto);
        return ResponseEntity.ok(savedRecord);
    }

    @GetMapping("/leaderboard")
    public ResponseEntity<?> getLeaderboard(
            @RequestParam(defaultValue = "10") int limit) {
        List<ChallengeRecordDto> leaderboard = challengeRecordService.getLeaderboard(limit);
        return ResponseEntity.ok(leaderboard);
    }

    @GetMapping("/history")
    // @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserChallengeHistory(
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        List<ChallengeRecordDto> history = challengeRecordService.getUserRecords(userDetails.getId());
        return ResponseEntity.ok(history);
    }
}
