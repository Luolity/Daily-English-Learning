package com.english.learning.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChallengeRecordDto {
    private Long id;
    private Long userId;
    private String nickname;
    private String avatar;
    private Integer score;
    private Integer totalQuestions;
    private Double accuracy;
    private Integer timeSpent;
    private LocalDateTime createdAt;
    private List<Long> wrongWordIds;
}
