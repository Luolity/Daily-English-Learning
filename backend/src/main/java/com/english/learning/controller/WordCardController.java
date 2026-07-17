package com.english.learning.controller;

import com.english.learning.dto.MessageResponse;
import com.english.learning.dto.WordCardDto;
import com.english.learning.security.services.UserDetailsImpl;
import com.english.learning.service.WordCardService;
import com.english.learning.service.impl.WordCardServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/wordcards")
public class WordCardController {

    @Autowired
    private WordCardService wordCardService;

    @GetMapping("/count")
    public ResponseEntity<?> getWordCardCount(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String difficulty,
            @RequestParam(required = false) String keyword) {
        String categoryFilter = (category != null && !category.isBlank()) ? category.trim() : null;
        String difficultyFilter = (difficulty != null && !difficulty.isBlank()) ? difficulty.trim() : null;
        String keywordFilter = (keyword != null && !keyword.isBlank()) ? keyword.trim() : null;

        long total = wordCardService.countWordCards(keywordFilter, categoryFilter, difficultyFilter);
        Map<String, Object> response = new HashMap<>();
        response.put("totalItems", total);
        response.put("pageSize", null);
        return ResponseEntity.ok(response);
    }

    @GetMapping
    public ResponseEntity<?> getAllWordCards(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String difficulty,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "word,asc") String[] sort,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {

        try {
            int safePage = Math.max(page, 1);
            int safeSize = Math.min(Math.max(size, 1), 500);

            String categoryFilter = (category != null && !category.isBlank()) ? category.trim() : null;
            String difficultyFilter = (difficulty != null && !difficulty.isBlank()) ? difficulty.trim() : null;
            String keywordFilter = (keyword != null && !keyword.isBlank()) ? keyword.trim() : null;

            IPage<WordCardDto> wordCardsPage;

            if (keywordFilter != null) {
                wordCardsPage = wordCardService.searchWordCards(keywordFilter, categoryFilter, difficultyFilter, safePage, safeSize);
            } else if (categoryFilter != null && difficultyFilter != null) {
                wordCardsPage = wordCardService.getWordCardsByCategoryAndDifficulty(categoryFilter, difficultyFilter, safePage, safeSize);
            } else if (categoryFilter != null) {
                wordCardsPage = wordCardService.getWordCardsByCategory(categoryFilter, safePage, safeSize);
            } else if (difficultyFilter != null) {
                wordCardsPage = wordCardService.getWordCardsByDifficulty(difficultyFilter, safePage, safeSize);
            } else {
                wordCardsPage = wordCardService.getAllWordCards(safePage, safeSize);
            }

            // 设置收藏状态
            List<WordCardDto> wordCards = wordCardsPage.getRecords();
            if (userDetails != null && wordCardService instanceof WordCardServiceImpl) {
                wordCards = ((WordCardServiceImpl) wordCardService).setFavoriteStatusBatch(wordCards, userDetails.getId());
            }

            long totalItems = wordCardsPage.getTotal();
            int totalPages = safeSize > 0
                    ? (int) ((totalItems + safeSize - 1) / safeSize)
                    : 0;

            Map<String, Object> response = new HashMap<>();
            response.put("content", wordCards);
            response.put("currentPage", wordCardsPage.getCurrent());
            response.put("pageSize", safeSize);
            response.put("totalItems", totalItems);
            response.put("totalPages", totalPages);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("message", "获取单词列表失败");
            errorResponse.put("error", e.getMessage());
            errorResponse.put("content", new ArrayList<>());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getWordCardById(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return wordCardService.getWordCardById(id)
                .map(wordCardDto -> {
                    // 设置收藏状态
                    if (userDetails != null && wordCardService instanceof WordCardServiceImpl) {
                        wordCardDto = ((WordCardServiceImpl) wordCardService).setFavoriteStatus(wordCardDto, userDetails.getId());
                    }
                    return ResponseEntity.ok(wordCardDto);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/word/{word}")
    public ResponseEntity<?> getWordCardByWord(
            @PathVariable String word,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return wordCardService.getWordCardByWord(word)
                .map(wordCardDto -> {
                    // 设置收藏状态
                    if (userDetails != null && wordCardService instanceof WordCardServiceImpl) {
                        wordCardDto = ((WordCardServiceImpl) wordCardService).setFavoriteStatus(wordCardDto, userDetails.getId());
                    }
                    return ResponseEntity.ok(wordCardDto);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createWordCard(@Valid @RequestBody WordCardDto wordCardDto) {
        WordCardDto createdWordCard = wordCardService.createWordCard(wordCardDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdWordCard);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateWordCard(@PathVariable Long id, @Valid @RequestBody WordCardDto wordCardDto) {
        WordCardDto updatedWordCard = wordCardService.updateWordCard(id, wordCardDto);
        if (updatedWordCard == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updatedWordCard);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteWordCard(@PathVariable Long id) {
        wordCardService.deleteWordCard(id);
        return ResponseEntity.ok(new MessageResponse("Word card deleted successfully"));
    }

    @GetMapping("/favorites")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> getFavoriteWordCards(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        try {
            List<WordCardDto> favorites = wordCardService.getFavoriteWordCards(userDetails.getId());

            // 确保返回的数据格式符合前端的预期
            Map<String, Object> response = new HashMap<>();
            response.put("content", favorites);
            response.put("currentPage", 0);
            response.put("totalItems", favorites.size());
            response.put("totalPages", 1);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("message", "获取收藏单词失败");
            errorResponse.put("error", e.getMessage());
            errorResponse.put("content", new ArrayList<>());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @PostMapping("/favorites/{wordCardId}")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> addToFavorites(
            @PathVariable Long wordCardId,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        boolean added = wordCardService.addWordCardToFavorites(userDetails.getId(), wordCardId);
        if (added) {
            return ResponseEntity.ok(new MessageResponse("Word card added to favorites"));
        } else {
            return ResponseEntity.badRequest().body(new MessageResponse("Failed to add word card to favorites"));
        }
    }

    @DeleteMapping("/favorites/{wordCardId}")
    @PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')")
    public ResponseEntity<?> removeFromFavorites(
            @PathVariable Long wordCardId,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        boolean removed = wordCardService.removeWordCardFromFavorites(userDetails.getId(), wordCardId);
        if (removed) {
            return ResponseEntity.ok(new MessageResponse("Word card removed from favorites"));
        } else {
            return ResponseEntity.badRequest().body(new MessageResponse("Failed to remove word card from favorites"));
        }
    }
}
