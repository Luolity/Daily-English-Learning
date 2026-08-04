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
@TableName("tbl_wrong_words")
public class WrongWord {
    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long wordId;

    private Integer wrongCount;

    private LocalDateTime lastWrongAt;
}
