package com.english.learning.service;

import com.english.learning.dto.ChallengeRecordDto;
import java.util.List;

public interface ChallengeRecordService {
    ChallengeRecordDto submitRecord(Long userId, ChallengeRecordDto recordDto);
    List<ChallengeRecordDto> getLeaderboard(int limit);
    List<ChallengeRecordDto> getUserRecords(Long userId);
}
