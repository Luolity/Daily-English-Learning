package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.ERole;
import com.english.learning.model.Role;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface RoleMapper extends BaseMapper<Role> {

    @Select("SELECT * FROM tbl_roles WHERE name = #{name}")
    Role findByName(@Param("name") ERole name);
    
    @Select("SELECT * FROM tbl_roles WHERE name = #{name} ORDER BY id LIMIT 1")
    Role findFirstByName(@Param("name") String name);

    @Select("SELECT * FROM tbl_roles WHERE name = #{name} ORDER BY id")
    List<Role> findAllByName(@Param("name") String name);
} 