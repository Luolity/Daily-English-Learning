package com.english.learning.service;

import com.english.learning.dto.WordCardDto;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import java.util.List;
import java.util.Optional;

public interface WordCardService {
    WordCardDto createWordCard(WordCardDto wordCardDto);
    
    WordCardDto updateWordCard(Long id, WordCardDto wordCardDto);
    
    void deleteWordCard(Long id);
    
    Optional<WordCardDto> getWordCardById(Long id);
    
    Optional<WordCardDto> getWordCardByWord(String word);
    
    IPage<WordCardDto> getAllWordCards(int page, int size);
    
    IPage<WordCardDto> getWordCardsByCategory(String category, int page, int size);
    
    IPage<WordCardDto> getWordCardsByDifficulty(String difficulty, int page, int size);
    
    IPage<WordCardDto> getWordCardsByCategoryAndDifficulty(String category, String difficulty, int page, int size);

    IPage<WordCardDto> searchWordCards(String keyword, String category, String difficulty, int page, int size);

    long countAllWordCards();

    long countWordCards(String keyword, String category, String difficulty);
    
    List<WordCardDto> getFavoriteWordCards(Long userId);
    
    boolean addWordCardToFavorites(Long userId, Long wordCardId);
    
    boolean removeWordCardFromFavorites(Long userId, Long wordCardId);
    
    boolean isWordCardFavorited(Long userId, Long wordId);
    
    WordCardDto setFavoriteStatus(WordCardDto dto, Long userId);
    
    List<WordCardDto> setFavoriteStatusBatch(List<WordCardDto> dtos, Long userId);
} 