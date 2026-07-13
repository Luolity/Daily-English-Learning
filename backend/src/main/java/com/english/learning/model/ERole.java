package com.english.learning.model;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.baomidou.mybatisplus.annotation.IEnum;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * 用户角色枚举
 */
public enum ERole implements IEnum<String> {
    ROLE_USER("ROLE_USER"),
    ROLE_MODERATOR("ROLE_MODERATOR"),
    ROLE_ADMIN("ROLE_ADMIN");
    
    @EnumValue
    private final String value;
    
    ERole(String value) {
        this.value = value;
    }
    
    @Override
    @JsonValue
    public String getValue() {
        return this.value;
    }
} 