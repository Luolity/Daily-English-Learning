package com.english.learning.controller;

import com.english.learning.dto.MessageResponse;
import com.english.learning.dto.WordCardDto;
import com.english.learning.security.services.UserDetailsImpl;
import com.english.learning.service.WrongWordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/wrong-words")
public class WrongWordController {

    @Autowired
    private WrongWordService wrongWordService;

    @GetMapping
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<List<WordCardDto>> getWrongWords(
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(wrongWordService.getWrongWords(userDetails.getId()));
    }

    @DeleteMapping("/{wordId}")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> removeWrongWord(
            @PathVariable Long wordId,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        if (!wrongWordService.removeWrongWord(userDetails.getId(), wordId)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(new MessageResponse("错题已移除"));
    }
}
