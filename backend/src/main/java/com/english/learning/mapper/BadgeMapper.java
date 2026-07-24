package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.Badge;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface BadgeMapper extends BaseMapper<Badge> {
    
    @Select("SELECT * FROM tbl_badges WHERE user_id = #{userId}")
    List<Badge> findByUserId(@Param("userId") Long userId);
    
    @Select("SELECT * FROM tbl_badges WHERE user_id = #{userId} AND category = #{category}")
    List<Badge> findByUserIdAndCategory(@Param("userId") Long userId, @Param("category") String category);
    
    @Select("SELECT * FROM tbl_badges WHERE user_id = #{userId} AND badge_id = #{badgeId}")
    Badge findByUserIdAndBadgeId(@Param("userId") Long userId, @Param("badgeId") String badgeId);
    
    @Select("SELECT COUNT(*) > 0 FROM tbl_badges WHERE user_id = #{userId} AND badge_id = #{badgeId}")
    boolean existsByUserIdAndBadgeId(@Param("userId") Long userId, @Param("badgeId") String badgeId);
} 