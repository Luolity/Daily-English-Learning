package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper extends BaseMapper<User> {

    @Select("SELECT * FROM tbl_users WHERE username = #{username}")
    User findByUsername(@Param("username") String username);

    @Select("SELECT COUNT(*) > 0 FROM tbl_users WHERE username = #{username}")
    boolean existsByUsername(@Param("username") String username);

    @Select("SELECT COUNT(*) > 0 FROM tbl_users WHERE email = #{email}")
    boolean existsByEmail(@Param("email") String email);
} 