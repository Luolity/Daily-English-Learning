package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.Category;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface CategoryMapper extends BaseMapper<Category> {

    @Select("SELECT * FROM tbl_categories WHERE name = #{name}")
    Category findByName(@Param("name") String name);

    @Select("SELECT COUNT(*) > 0 FROM tbl_categories WHERE name = #{name}")
    boolean existsByName(@Param("name") String name);
} 