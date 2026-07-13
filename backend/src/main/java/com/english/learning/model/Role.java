package com.english.learning.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 角色实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("tbl_roles")
public class Role {
    @TableId(type = IdType.AUTO)
    private Integer id;

    @TableField("name")
    private ERole name;

    public Role(ERole name) {
        this.name = name;
    }
} 