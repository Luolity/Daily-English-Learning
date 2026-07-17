package com.english.learning.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.english.learning.dto.WordCardDto;
import com.english.learning.mapper.CategoryMapper;
import com.english.learning.mapper.UserMapper;
import com.english.learning.mapper.WordCardMapper;
import com.english.learning.model.Category;
import com.english.learning.model.User;
import com.english.learning.model.WordCard;
import com.english.learning.service.WordCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class WordCardServiceImpl implements WordCardService {

    @Autowired
    private WordCardMapper wordCardMapper;

    @Autowired
    private CategoryMapper categoryMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    @Transactional
    public WordCardDto createWordCard(WordCardDto wordCardDto) {
        WordCard wordCard = convertToEntity(wordCardDto);
        wordCardMapper.insert(wordCard);

        // 保存单词与分类的关联关系
        saveWordCardCategories(wordCard.getId(), wordCardDto.getCategories());

        return convertToDto(wordCard);
    }

    @Override
    @Transactional
    public WordCardDto updateWordCard(Long id, WordCardDto wordCardDto) {
        WordCard wordCard = wordCardMapper.selectById(id);
        if (wordCard != null) {
            wordCard.setWord(wordCardDto.getWord());
            wordCard.setTranslation(wordCardDto.getTranslation());
            wordCard.setPhonetic(wordCardDto.getPhonetic());
            wordCard.setPartOfSpeech(wordCardDto.getPartOfSpeech());
            wordCard.setDefinition(wordCardDto.getDefinition());
            wordCard.setExample(wordCardDto.getExample());
            wordCard.setDifficulty(wordCardDto.getDifficulty());

            // 更新分类关系
            // 先删除旧的关联关系
            deleteWordCardCategories(id);
            // 添加新的关联关系
            saveWordCardCategories(id, wordCardDto.getCategories());

            wordCardMapper.updateById(wordCard);
            return convertToDto(wordCard);
        }
        return null;
    }

    @Override
    @Transactional
    public void deleteWordCard(Long id) {
        // 删除单词与分类的关联关系
        deleteWordCardCategories(id);
        // 删除单词与用户收藏的关联关系
        deleteWordCardFavorites(id);
        // 删除单词
        wordCardMapper.deleteById(id);
    }

    @Override
    public Optional<WordCardDto> getWordCardById(Long id) {
        WordCard wordCard = wordCardMapper.selectById(id);
        return Optional.ofNullable(wordCard).map(this::convertToDto);
    }

    @Override
    public Optional<WordCardDto> getWordCardByWord(String word) {
        WordCard wordCard = wordCardMapper.findByWord(word);
        return Optional.ofNullable(wordCard).map(this::convertToDto);
    }

    @Override
    public IPage<WordCardDto> getAllWordCards(int page, int size) {
        LambdaQueryWrapper<WordCard> wrapper = buildOrderedWrapper();
        return queryPage(page, size, wrapper);
    }

    @Override
    public IPage<WordCardDto> getWordCardsByCategory(String category, int page, int size) {
        List<Long> wordIds = findWordIdsByCategoryName(category);
        if (wordIds.isEmpty()) {
            return emptyPage(page, size);
        }
        LambdaQueryWrapper<WordCard> wrapper = buildOrderedWrapper();
        wrapper.in(WordCard::getId, wordIds);
        return queryPage(page, size, wrapper);
    }

    @Override
    public IPage<WordCardDto> getWordCardsByDifficulty(String difficulty, int page, int size) {
        LambdaQueryWrapper<WordCard> wrapper = buildOrderedWrapper();
        wrapper.eq(WordCard::getDifficulty, difficulty);
        return queryPage(page, size, wrapper);
    }

    @Override
    public IPage<WordCardDto> getWordCardsByCategoryAndDifficulty(String category, String difficulty, int page, int size) {
        List<Long> wordIds = findWordIdsByCategoryName(category);
        if (wordIds.isEmpty()) {
            return emptyPage(page, size);
        }
        LambdaQueryWrapper<WordCard> wrapper = buildOrderedWrapper();
        wrapper.in(WordCard::getId, wordIds).eq(WordCard::getDifficulty, difficulty);
        return queryPage(page, size, wrapper);
    }

    @Override
    public long countAllWordCards() {
        return wordCardMapper.selectCount(null);
    }

    @Override
    public long countWordCards(String keyword, String category, String difficulty) {
        LambdaQueryWrapper<WordCard> wrapper = new LambdaQueryWrapper<>();
        applyKeywordFilter(wrapper, keyword);

        if (category != null && !category.isBlank()) {
            List<Long> wordIds = findWordIdsByCategoryName(category);
            if (wordIds.isEmpty()) {
                return 0;
            }
            wrapper.in(WordCard::getId, wordIds);
        }
        if (difficulty != null && !difficulty.isBlank()) {
            wrapper.eq(WordCard::getDifficulty, difficulty);
        }
        return wordCardMapper.selectCount(wrapper);
    }

    @Override
    public IPage<WordCardDto> searchWordCards(String keyword, String category, String difficulty, int page, int size) {
        LambdaQueryWrapper<WordCard> wrapper = buildOrderedWrapper();
        applyKeywordFilter(wrapper, keyword);

        if (category != null && !category.isBlank()) {
            List<Long> wordIds = findWordIdsByCategoryName(category);
            if (wordIds.isEmpty()) {
                return emptyPage(page, size);
            }
            wrapper.in(WordCard::getId, wordIds);
        }
        if (difficulty != null && !difficulty.isBlank()) {
            wrapper.eq(WordCard::getDifficulty, difficulty);
        }
        return queryPage(page, size, wrapper);
    }

    private LambdaQueryWrapper<WordCard> buildOrderedWrapper() {
        LambdaQueryWrapper<WordCard> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByAsc(WordCard::getWord);
        return wrapper;
    }

    private void applyKeywordFilter(LambdaQueryWrapper<WordCard> wrapper, String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return;
        }
        String pattern = "%" + keyword.trim() + "%";
        wrapper.and(w -> w.like(WordCard::getWord, pattern).or().like(WordCard::getTranslation, pattern));
    }

    private List<Long> findWordIdsByCategoryName(String categoryName) {
        return jdbcTemplate.queryForList(
                "SELECT DISTINCT wc.word_id FROM tbl_word_categories wc " +
                        "JOIN tbl_categories c ON wc.category_id = c.id " +
                        "WHERE c.name = ? ORDER BY wc.word_id",
                Long.class,
                categoryName
        );
    }

    private IPage<WordCardDto> queryPage(int page, int size, LambdaQueryWrapper<WordCard> wrapper) {
        Page<WordCard> pageParam = new Page<>(page, size);
        IPage<WordCard> wordCardsPage = wordCardMapper.selectPage(pageParam, wrapper);
        return convertPageToDto(wordCardsPage);
    }

    private IPage<WordCardDto> emptyPage(int page, int size) {
        Page<WordCardDto> empty = new Page<>(page, size, 0);
        empty.setRecords(Collections.emptyList());
        return empty;
    }

    // 辅助方法：将IPage<WordCard>转换为IPage<WordCardDto>
    private IPage<WordCardDto> convertPageToDto(IPage<WordCard> page) {
        List<WordCardDto> dtoList = page.getRecords().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());

        Page<WordCardDto> dtoPage = new Page<>(page.getCurrent(), page.getSize(), page.getTotal());
        dtoPage.setRecords(dtoList);
        return dtoPage;
    }

    @Override
    @Transactional(readOnly = true)
    public List<WordCardDto> getFavoriteWordCards(Long userId) {
        List<WordCard> favorites = wordCardMapper.findFavoritesByUserId(userId);
        return favorites.stream()
                .map(wordCard -> {
                    WordCardDto dto = convertToDto(wordCard);
                    dto.setFavorite(true); // 设置为收藏状态
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public boolean addWordCardToFavorites(Long userId, Long wordCardId) {
        User user = userMapper.selectById(userId);
        WordCard wordCard = wordCardMapper.selectById(wordCardId);

        if (user != null && wordCard != null) {
            // 检查是否已经收藏
            Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM tbl_user_favorites WHERE user_id = ? AND word_id = ?",
                Integer.class, userId, wordCardId
            );

            if (count != null && count == 0) {
                // 添加收藏关系
                jdbcTemplate.update(
                    "INSERT INTO tbl_user_favorites (user_id, word_id) VALUES (?, ?)",
                    userId, wordCardId
                );
                return true;
            }
            return false; // 已经收藏过了
        }
        return false; // 用户或单词不存在
    }

    @Override
    @Transactional
    public boolean removeWordCardFromFavorites(Long userId, Long wordCardId) {
        // 删除收藏关系
        int rowsAffected = jdbcTemplate.update(
            "DELETE FROM tbl_user_favorites WHERE user_id = ? AND word_id = ?",
            userId, wordCardId
        );
        return rowsAffected > 0;
    }

    // 转换实体到DTO
    private WordCardDto convertToDto(WordCard wordCard) {
        // 获取分类名称列表
        Set<String> categoryNames = getCategoryNamesByWordId(wordCard.getId());

        // 构建DTO对象
        return WordCardDto.builder()
                .id(wordCard.getId())
                .word(wordCard.getWord())
                .translation(wordCard.getTranslation())
                .phonetic(wordCard.getPhonetic())
                .partOfSpeech(wordCard.getPartOfSpeech())
                .definition(wordCard.getDefinition())
                .example(wordCard.getExample())
                .difficulty(wordCard.getDifficulty())
                .categories(categoryNames)
                .build();
    }

    private WordCard convertToEntity(WordCardDto dto) {
        return WordCard.builder()
                .word(dto.getWord())
                .translation(dto.getTranslation())
                .phonetic(dto.getPhonetic())
                .partOfSpeech(dto.getPartOfSpeech())
                .definition(dto.getDefinition())
                .example(dto.getExample())
                .difficulty(dto.getDifficulty())
                .build();
    }

    @Transactional(readOnly = true)
    public Set<String> getCategoryNamesByWordId(Long wordId) {
        if (wordId == null) {
            return new HashSet<>();
        }

        String sql = "SELECT c.name FROM tbl_categories c " +
                     "JOIN tbl_word_categories wc ON c.id = wc.category_id " +
                     "WHERE wc.word_id = ?";

        List<String> categoryNames = jdbcTemplate.queryForList(sql, String.class, wordId);
        return new HashSet<>(categoryNames);
    }

    @Transactional
    public void saveWordCardCategories(Long wordId, Set<String> categoryNames) {
        if (categoryNames != null && !categoryNames.isEmpty()) {
            for (String categoryName : categoryNames) {
                Category category = categoryMapper.findByName(categoryName);
                if (category == null) {
                    // 创建新分类
                    category = new Category();
                    category.setName(categoryName);
                    categoryMapper.insert(category);
                }
                // 添加单词与分类关联
                jdbcTemplate.update(
                    "INSERT INTO tbl_word_categories (word_id, category_id) VALUES (?, ?)",
                    wordId, category.getId()
                );
            }
        }
    }

    @Transactional
    private void deleteWordCardCategories(Long wordId) {
        jdbcTemplate.update(
            "DELETE FROM tbl_word_categories WHERE word_id = ?",
            wordId
        );
    }

    @Transactional
    private void deleteWordCardFavorites(Long wordId) {
        jdbcTemplate.update(
            "DELETE FROM tbl_user_favorites WHERE word_id = ?",
            wordId
        );
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isWordCardFavorited(Long userId, Long wordId) {
        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM tbl_user_favorites WHERE user_id = ? AND word_id = ?",
            Integer.class, userId, wordId
        );

        return count != null && count > 0;
    }

    @Override
    @Transactional(readOnly = true)
    public WordCardDto setFavoriteStatus(WordCardDto dto, Long userId) {
        boolean isFavorite = isWordCardFavorited(userId, dto.getId());
        dto.setFavorite(isFavorite);
        return dto;
    }

    @Override
    @Transactional(readOnly = true)
    public List<WordCardDto> setFavoriteStatusBatch(List<WordCardDto> dtos, Long userId) {
        return dtos.stream()
                .map(dto -> setFavoriteStatus(dto, userId))
                .collect(Collectors.toList());
    }
}
