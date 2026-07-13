package com.english.learning.model;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import java.util.HashSet;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("tbl_word_cards")
public class WordCard {
    @TableId(type = IdType.AUTO)
    private Long id;

    @NotBlank
    private String word;

    @NotBlank
    private String translation;

    private String phonetic;

    @TableField("part_of_speech")
    private String partOfSpeech;

    private String definition;

    private String example;

    private String difficulty; // easy, medium, hard

    @TableField(exist = false)
    private Set<Category> categories = new HashSet<>();

    @TableField(exist = false)
    private Set<User> favoritedBy = new HashSet<>();
} 