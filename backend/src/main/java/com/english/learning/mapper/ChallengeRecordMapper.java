package com.english.learning.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.english.learning.model.ChallengeRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ChallengeRecordMapper extends BaseMapper<ChallengeRecord> {
    
    @Select("SELECT cr.*, u.nickname as nickname, u.avatar as avatar FROM tbl_challenge_records cr " +
            "JOIN tbl_users u ON cr.user_id = u.id " +
            "ORDER BY cr.score DESC, cr.accuracy DESC, cr.time_spent ASC LIMIT #{limit}")
    List<ChallengeRecord> getLeaderboard(int limit);
}