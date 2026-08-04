package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.WrongWord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface WrongWordMapper extends BaseMapper<WrongWord> {

    @Select("SELECT w.* FROM tbl_word_cards w " +
            "JOIN tbl_wrong_words ww ON ww.word_id = w.id " +
            "WHERE ww.user_id = #{userId} " +
            "ORDER BY ww.last_wrong_at DESC")
    List<com.english.learning.model.WordCard> findWordsByUserId(@Param("userId") Long userId);
}
