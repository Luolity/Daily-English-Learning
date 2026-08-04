package com.english.learning.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.english.learning.dto.WordCardDto;
import com.english.learning.mapper.WrongWordMapper;
import com.english.learning.model.WordCard;
import com.english.learning.model.WrongWord;
import com.english.learning.service.WrongWordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class WrongWordServiceImpl implements WrongWordService {

    @Autowired
    private WrongWordMapper wrongWordMapper;

    @Autowired
    private WordCardServiceImpl wordCardService;

    @Override
    @Transactional
    public void recordWrongWords(Long userId, List<Long> wordIds) {
        if (wordIds == null || wordIds.isEmpty()) {
            return;
        }

        wordIds.stream()
                .filter(Objects::nonNull)
                .distinct()
                .forEach(wordId -> recordWrongWord(userId, wordId));
    }

    private void recordWrongWord(Long userId, Long wordId) {
        WrongWord wrongWord = wrongWordMapper.selectOne(new LambdaQueryWrapper<WrongWord>()
                .eq(WrongWord::getUserId, userId)
                .eq(WrongWord::getWordId, wordId));
        LocalDateTime now = LocalDateTime.now();

        if (wrongWord == null) {
            wrongWordMapper.insert(WrongWord.builder()
                    .userId(userId)
                    .wordId(wordId)
                    .wrongCount(1)
                    .lastWrongAt(now)
                    .build());
            return;
        }

        wrongWord.setWrongCount(wrongWord.getWrongCount() + 1);
        wrongWord.setLastWrongAt(now);
        wrongWordMapper.updateById(wrongWord);
    }

    @Override
    @Transactional(readOnly = true)
    public List<WordCardDto> getWrongWords(Long userId) {
        List<WordCard> wrongWords = wrongWordMapper.findWordsByUserId(userId);
        if (wrongWords == null || wrongWords.isEmpty()) {
            return Collections.emptyList();
        }
        return wrongWords.stream()
                .map(word -> wordCardService.getWordCardById(word.getId()).orElse(null))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public boolean removeWrongWord(Long userId, Long wordId) {
        return wrongWordMapper.delete(new LambdaQueryWrapper<WrongWord>()
                .eq(WrongWord::getUserId, userId)
                .eq(WrongWord::getWordId, wordId)) > 0;
    }
}
