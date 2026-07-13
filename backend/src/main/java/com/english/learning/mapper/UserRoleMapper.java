package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.Role;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UserRoleMapper extends BaseMapper<Object> {

    @Insert("INSERT INTO tbl_user_roles(user_id, role_id) VALUES(#{userId}, #{roleId})")
    void insertUserRole(@Param("userId") Long userId, @Param("roleId") Integer roleId);
    
    @Select("SELECT r.* FROM tbl_roles r " +
            "JOIN tbl_user_roles ur ON r.id = ur.role_id " +
            "WHERE ur.user_id = #{userId}")
    List<Role> findRolesByUserId(@Param("userId") Long userId);
    
    @Delete("DELETE FROM tbl_user_roles WHERE user_id = #{userId}")
    void deleteByUserId(@Param("userId") Long userId);

    @org.apache.ibatis.annotations.Update(
            "UPDATE tbl_user_roles SET role_id = #{newRoleId} " +
            "WHERE role_id = #{oldRoleId} " +
            "AND NOT EXISTS (" +
            "  SELECT 1 FROM (SELECT user_id FROM tbl_user_roles WHERE role_id = #{newRoleId}) existing " +
            "  WHERE existing.user_id = tbl_user_roles.user_id" +
            ")")
    void remapRoleId(@Param("oldRoleId") Integer oldRoleId, @Param("newRoleId") Integer newRoleId);

    @Delete("DELETE FROM tbl_user_roles WHERE role_id = #{roleId}")
    void deleteByRoleId(@Param("roleId") Integer roleId);
} 