package com.english.learning.dto;

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
public class WordCardDto {
    private Long id;
    
    @NotBlank
    private String word;
    
    @NotBlank
    private String translation;
    
    private String phonetic;
    
    private String partOfSpeech;
    
    private String definition;
    
    private String example;
    
    private String difficulty;
    
    private Set<String> categories = new HashSet<>();
    
    private boolean favorite;
} 