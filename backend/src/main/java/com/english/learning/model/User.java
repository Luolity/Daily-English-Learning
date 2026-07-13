package com.english.learning.model;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import java.util.HashSet;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("tbl_users")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;

    @NotBlank
    @Size(max = 20)
    private String username;

    @NotBlank
    @Size(max = 50)
    @Email
    private String email;

    @NotBlank
    @Size(max = 120)
    private String password;

    @NotBlank
    @Size(max = 50)
    private String nickname;

    private String avatar;

    @TableField(exist = false)
    private Set<Role> roles = new HashSet<>();

    @TableField("learning_streak")
    private Integer learningStreak;

    @TableField("last_study_date")
    private String lastStudyDate;

    @TableField("total_words")
    private Integer totalWords;

    @TableField("total_time")
    private Integer totalTime;

    @TableField("correct_rate")
    private Double correctRate;

    @TableField(exist = false)
    private Set<LearningProgress> dailyStats = new HashSet<>();

    @TableField(exist = false)
    private Set<Badge> badges = new HashSet<>();

    @TableField(exist = false)
    private Set<WordCard> favorites = new HashSet<>();

    public User(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.nickname = username;
        this.learningStreak = 0;
        this.totalWords = 0;
        this.totalTime = 0;
        this.correctRate = 0.0;
    }
} 