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
@TableName("tbl_badges")
public class Badge {
    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("badge_id")
    private String badgeId;

    private String name;

    private String description;

    private String icon;

    private String level; // bronze, silver, gold, platinum

    private String category; // streak, vocabulary, challenge, etc.

    @TableField("date_earned")
    private String dateEarned;

    @TableField("user_id")
    private Long userId;

    @TableField(exist = false)
    private User user;
} 