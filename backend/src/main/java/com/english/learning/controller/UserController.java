package com.english.learning.controller;

import com.english.learning.dto.MessageResponse;
import com.english.learning.dto.UserInfoDto;
import com.english.learning.security.services.UserDetailsImpl;
import com.english.learning.service.FileStorageService;
import com.english.learning.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private FileStorageService fileStorageService;

    @GetMapping("/profile")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getUserProfile(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        return userService.getUserById(userDetails.getId())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/profile")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> updateUserProfile(
            @Valid @RequestBody UserInfoDto userInfoDto,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        UserInfoDto updatedUser = userService.updateUserProfile(userDetails.getId(), userInfoDto);
        return ResponseEntity.ok(updatedUser);
    }

    @PostMapping("/avatar")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> uploadAvatar(
            @RequestParam("file") MultipartFile file,
            @AuthenticationPrincipal UserDetailsImpl userDetails) throws IOException {
        if (file == null || file.isEmpty()) {
            return ResponseEntity.badRequest().body(new MessageResponse("请选择图片文件"));
        }

        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return ResponseEntity.badRequest().body(new MessageResponse("仅支持图片格式"));
        }

        String avatarPath = fileStorageService.storeAvatar(file, userDetails.getId());
        UserInfoDto dto = new UserInfoDto();
        dto.setAvatar(avatarPath);
        UserInfoDto updated = userService.updateUserProfile(userDetails.getId(), dto);

        Map<String, Object> body = new HashMap<>();
        body.put("avatar", updated.getAvatar());
        body.put("message", "头像上传成功");
        return ResponseEntity.ok(body);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> getUserById(@PathVariable Long id) {
        return userService.getUserById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/username/{username}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> getUserByUsername(@PathVariable String username) {
        return userService.getUserByUsername(username)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/stats")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> updateUserLearningStats(
            @RequestParam int wordsLearned,
            @RequestParam int timeSpent,
            @RequestParam int correctCount,
            @RequestParam int totalCount,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        userService.updateUserLearningStats(
                userDetails.getId(), wordsLearned, timeSpent, correctCount, totalCount);
        return ResponseEntity.ok(new MessageResponse("User learning stats updated successfully"));
    }
} 