package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.LearningProgress;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface LearningProgressMapper extends BaseMapper<LearningProgress> {
    
    @Select("SELECT * FROM tbl_learning_progress WHERE user_id = #{userId} ORDER BY date DESC")
    List<LearningProgress> findByUserIdOrderByDateDesc(@Param("userId") Long userId);
    
    @Select("SELECT * FROM tbl_learning_progress WHERE user_id = #{userId} AND date = #{date}")
    LearningProgress findByUserIdAndDate(@Param("userId") Long userId, @Param("date") String date);
    
    @Select("SELECT SUM(words_learned) FROM tbl_learning_progress WHERE user_id = #{userId}")
    Integer getTotalWordsLearnedByUserId(@Param("userId") Long userId);
    
    @Select("SELECT SUM(time_spent) FROM tbl_learning_progress WHERE user_id = #{userId}")
    Integer getTotalTimeSpentByUserId(@Param("userId") Long userId);
    
    @Select("SELECT SUM(correct_count) FROM tbl_learning_progress WHERE user_id = #{userId}")
    Integer getTotalCorrectCountByUserId(@Param("userId") Long userId);
    
    @Select("SELECT SUM(total_count) FROM tbl_learning_progress WHERE user_id = #{userId}")
    Integer getTotalCountByUserId(@Param("userId") Long userId);
    
    @Select("SELECT * FROM tbl_learning_progress WHERE user_id = #{userId}")
    LearningProgress findByUserId(@Param("userId") Long userId);
} 