package com.english.learning.service;

import com.english.learning.dto.WordCardDto;

import java.util.List;

public interface WrongWordService {
    void recordWrongWords(Long userId, List<Long> wordIds);

    List<WordCardDto> getWrongWords(Long userId);

    boolean removeWrongWord(Long userId, Long wordId);
}
