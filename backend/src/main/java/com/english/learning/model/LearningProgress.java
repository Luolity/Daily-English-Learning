package com.english.learning.model;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("tbl_learning_progress")
public class LearningProgress {
    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("user_id")
    private Long userId;

    @TableField(exist = false)
    private User user;

    private String date;

    @TableField("words_learned")
    private Integer wordsLearned;

    @TableField("time_spent")
    private Integer timeSpent;

    @TableField("correct_count")
    private Integer correctCount;

    @TableField("total_count")
    private Integer totalCount;
    
    private Integer streak;
    
    @TableField("total_words")
    private Integer totalWords;
    
    @TableField("correct_rate")
    private Double correctRate;
    
    @TableField("total_time")
    private Integer totalTime;
} 