package com.english.learning.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LearningProgressDto {
    private Long id;
    private String date;
    private int wordsLearned;
    private int timeSpent;
    private int correctCount;
    private int totalCount;
} 