package com.english.learning.service.impl;

import com.english.learning.mapper.WrongWordMapper;
import com.english.learning.model.WrongWord;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class WrongWordServiceImplTest {

    @Mock
    private WrongWordMapper wrongWordMapper;

    @InjectMocks
    private WrongWordServiceImpl wrongWordService;

    @Test
    void shouldCreateOneRecordForEachDistinctWrongWord() {
        when(wrongWordMapper.selectOne(any())).thenReturn(null);

        wrongWordService.recordWrongWords(1L, Arrays.asList(2L, 2L, 3L));

        ArgumentCaptor<WrongWord> captor = ArgumentCaptor.forClass(WrongWord.class);
        verify(wrongWordMapper, times(2)).insert(captor.capture());
        verify(wrongWordMapper, never()).updateById(any());
        assertEquals(Arrays.asList(2L, 3L), captor.getAllValues().stream()
                .map(WrongWord::getWordId)
                .collect(java.util.stream.Collectors.toList()));
    }

    @Test
    void shouldIncreaseCountWhenWrongWordAlreadyExists() {
        WrongWord existingWrongWord = WrongWord.builder()
                .id(10L)
                .userId(1L)
                .wordId(2L)
                .wrongCount(3)
                .lastWrongAt(LocalDateTime.now().minusDays(1))
                .build();
        when(wrongWordMapper.selectOne(any())).thenReturn(existingWrongWord);

        wrongWordService.recordWrongWords(1L, Arrays.asList(2L));

        assertEquals(4, existingWrongWord.getWrongCount());
        assertTrue(existingWrongWord.getLastWrongAt().isAfter(LocalDateTime.now().minusMinutes(1)));
        verify(wrongWordMapper).updateById(existingWrongWord);
        verify(wrongWordMapper, never()).insert(any());
    }
}
