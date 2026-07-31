-- 为尚未关联分类的单词补充 CET4 分类，便于按分类筛选时也能覆盖全库
-- 执行前请确认 tbl_categories 中已有 CET4（id=1）
INSERT IGNORE INTO tbl_word_categories (word_id, category_id)
SELECT w.id, 1
FROM tbl_word_cards w
WHERE NOT EXISTS (
    SELECT 1 FROM tbl_word_categories wc WHERE wc.word_id = w.id
);
