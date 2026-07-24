package com.english.learning.controller;

import com.english.learning.dto.BadgeDto;
import com.english.learning.dto.MessageResponse;
import com.english.learning.security.services.UserDetailsImpl;
import com.english.learning.service.BadgeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/badges")
public class BadgeController {

    @Autowired
    private BadgeService badgeService;

    @GetMapping
    // @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserBadges(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        List<BadgeDto> badges = badgeService.getUserBadges(userDetails.getId());
        return ResponseEntity.ok(badges);
    }

    @GetMapping("/category/{category}")
    // @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserBadgesByCategory(
            @PathVariable String category,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        List<BadgeDto> badges = badgeService.getUserBadgesByCategory(userDetails.getId(), category);
        return ResponseEntity.ok(badges);
    }

    @GetMapping("/{badgeId}")
    // @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserBadgeById(
            @PathVariable String badgeId,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return badgeService.getUserBadgeById(userDetails.getId(), badgeId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> awardBadgeToUser(
            @RequestParam Long userId,
            @Valid @RequestBody BadgeDto badgeDto) {
        BadgeDto awardedBadge = badgeService.awardBadgeToUser(userId, badgeDto);
        return ResponseEntity.ok(awardedBadge);
    }

    @GetMapping("/check")
    // @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> checkAndAwardBadges(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        badgeService.checkAndAwardBadges(userDetails.getId());
        return ResponseEntity.ok(new MessageResponse("Badges checked and awarded successfully"));
    }

    @GetMapping("/completion")
    // @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getBadgeCompletion(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        int completionPercentage = badgeService.calculateBadgeCompletion(userDetails.getId());
        return ResponseEntity.ok(new MessageResponse(String.valueOf(completionPercentage)));
    }
} 