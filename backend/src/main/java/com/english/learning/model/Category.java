package com.english.learning.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("tbl_categories")
public class Category {
    @TableId(type = IdType.AUTO)
    private Long id;

    @NotBlank
    private String name;

    private String description;

    @TableField(exist = false)
    private Set<WordCard> words = new HashSet<>();
} 