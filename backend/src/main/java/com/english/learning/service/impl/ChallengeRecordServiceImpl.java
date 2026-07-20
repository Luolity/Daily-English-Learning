package com.english.learning.service.impl;

import com.english.learning.dto.ChallengeRecordDto;
import com.english.learning.mapper.ChallengeRecordMapper;
import com.english.learning.mapper.UserMapper;
import com.english.learning.model.ChallengeRecord;
import com.english.learning.model.User;
import com.english.learning.service.ChallengeRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ChallengeRecordServiceImpl implements ChallengeRecordService {

    @Autowired
    private ChallengeRecordMapper challengeRecordMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    @Transactional
    public ChallengeRecordDto submitRecord(Long userId, ChallengeRecordDto recordDto) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("User not found with id: " + userId);
        }

        ChallengeRecord record = ChallengeRecord.builder()
                .userId(userId)
                .score(recordDto.getScore())
                .totalQuestions(recordDto.getTotalQuestions())
                .accuracy(recordDto.getAccuracy())
                .timeSpent(recordDto.getTimeSpent())
                .createdAt(LocalDateTime.now())
                .build();

        challengeRecordMapper.insert(record);

        return convertToDto(record, user.getNickname(), user.getAvatar());
    }

    @Override
    public List<ChallengeRecordDto> getLeaderboard(int limit) {
        List<ChallengeRecord> records = challengeRecordMapper.getLeaderboard(limit);
        return records.stream().map(record -> {
            // Mybatis plus @Select returns standard mapping, nickname and avatar might not be mapped directly to entity if not fields.
            // Wait, does ChallengeRecord entity have nickname and avatar?
            return convertToDtoWithEntity(record);
        }).collect(Collectors.toList());
    }

    @Override
    public List<ChallengeRecordDto> getUserRecords(Long userId) {
        User user = userMapper.selectById(userId);
        List<ChallengeRecord> records = challengeRecordMapper.selectList(
            new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<ChallengeRecord>()
                .eq("user_id", userId)
                .orderByDesc("score")
        );
        String nickname = user != null ? user.getNickname() : null;
        String avatar = user != null ? user.getAvatar() : null;
        
        return records.stream()
                .map(record -> convertToDto(record, nickname, avatar))
                .collect(Collectors.toList());
    }

    private ChallengeRecordDto convertToDto(ChallengeRecord record, String nickname, String avatar) {
        return ChallengeRecordDto.builder()
                .id(record.getId())
                .userId(record.getUserId())
                .nickname(nickname)
                .avatar(avatar)
                .score(record.getScore())
                .totalQuestions(record.getTotalQuestions())
                .accuracy(record.getAccuracy())
                .timeSpent(record.getTimeSpent())
                .createdAt(record.getCreatedAt())
                .build();
    }
    
    private ChallengeRecordDto convertToDtoWithEntity(ChallengeRecord record) {
        // If ChallengeRecord doesn't have nickname and avatar properties, the custom @Select mapping won't inject them into the entity unless they are defined with @TableField(exist = false)
        return ChallengeRecordDto.builder()
                .id(record.getId())
                .userId(record.getUserId())
                // Assuming we will add nickname and avatar fields with @TableField(exist = false) to ChallengeRecord
                .nickname(record.getNickname())
                .avatar(record.getAvatar())
                .score(record.getScore())
                .totalQuestions(record.getTotalQuestions())
                .accuracy(record.getAccuracy())
                .timeSpent(record.getTimeSpent())
                .createdAt(record.getCreatedAt())
                .build();
    }
}
