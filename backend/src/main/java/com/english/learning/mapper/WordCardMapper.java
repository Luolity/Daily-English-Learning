package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.WordCard;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface WordCardMapper extends BaseMapper<WordCard> {

    @Select("SELECT * FROM tbl_word_cards WHERE word = #{word}")
    WordCard findByWord(@Param("word") String word);

    @Select("SELECT w.* FROM tbl_word_cards w JOIN tbl_user_favorites uf ON w.id = uf.word_id WHERE uf.user_id = #{userId}")
    List<WordCard> findFavoritesByUserId(@Param("userId") Long userId);
}
