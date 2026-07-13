package com.english.learning.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("tbl_challenge_records")
public class ChallengeRecord {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long userId;
    
    private Integer score;
    
    private Integer totalQuestions;
    
    private Double accuracy;
    
    private Integer timeSpent;
    
    private LocalDateTime createdAt;
    
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private String nickname;
    
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private String avatar;
}