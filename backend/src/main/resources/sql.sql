/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80100
 Source Host           : localhost:3306
 Source Schema         : english_learning

 Target Server Type    : MySQL
 Target Server Version : 80100
 File Encoding         : 65001

 Date: 31/07/2026 15:38:50
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tbl_badges
-- ----------------------------
DROP TABLE IF EXISTS `tbl_badges`;
CREATE TABLE `tbl_badges`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `badge_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `date_earned` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tbl_badges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_badges
-- ----------------------------
INSERT INTO `tbl_badges` VALUES (1, 'streak_3', '初学乍练', '连续学习3天', 'streak-3', 'bronze', 'streak', '2023-06-03T10:15:30', 2);
INSERT INTO `tbl_badges` VALUES (2, 'streak_7', '坚持不懈', '连续学习7天', 'streak-7', 'silver', 'streak', '2023-06-07T11:20:45', 2);
INSERT INTO `tbl_badges` VALUES (3, 'vocabulary_50', '词汇新手', '学习50个单词', 'vocab-50', 'bronze', 'vocabulary', '2023-06-03T15:30:20', 2);
INSERT INTO `tbl_badges` VALUES (4, 'vocabulary_100', '词汇达人', '学习100个单词', 'vocab-100', 'silver', 'vocabulary', '2023-06-06T16:45:10', 2);
INSERT INTO `tbl_badges` VALUES (5, 'accuracy_80', '精准学习者', '正确率达到80%', 'accuracy-80', 'silver', 'challenge', '2023-06-05T09:25:30', 2);
INSERT INTO `tbl_badges` VALUES (6, 'streak_7', '坚持不懈', '连续学习7天', 'streak-7', 'silver', 'streak', '2023-06-03T14:35:25', 3);
INSERT INTO `tbl_badges` VALUES (7, 'streak_14', '学习狂人', '连续学习14天', 'streak-14', 'gold', 'streak', '2023-06-07T17:40:15', 3);
INSERT INTO `tbl_badges` VALUES (8, 'vocabulary_50', '词汇新手', '学习50个单词', 'vocab-50', 'bronze', 'vocabulary', '2023-06-02T12:10:40', 3);
INSERT INTO `tbl_badges` VALUES (9, 'vocabulary_100', '词汇达人', '学习100个单词', 'vocab-100', 'silver', 'vocabulary', '2023-06-04T13:50:30', 3);
INSERT INTO `tbl_badges` VALUES (10, 'vocabulary_200', '词汇大师', '学习200个单词', 'vocab-200', 'gold', 'vocabulary', '2023-06-06T18:20:10', 3);
INSERT INTO `tbl_badges` VALUES (11, 'accuracy_80', '精准学习者', '正确率达到80%', 'accuracy-80', 'silver', 'challenge', '2023-06-04T10:30:50', 3);
INSERT INTO `tbl_badges` VALUES (12, 'accuracy_90', '完美主义者', '正确率达到90%', 'accuracy-90', 'gold', 'challenge', '2023-06-06T11:45:25', 3);
INSERT INTO `tbl_badges` VALUES (13, 'streak_3', '初学乍练', '连续学习3天', 'streak-3', 'bronze', 'streak', '2026-05-22T18:05:27.5615588', 1);
INSERT INTO `tbl_badges` VALUES (14, 'streak_7', '坚持不懈', '连续学习7天', 'streak-7', 'silver', 'streak', '2026-05-22T18:05:27.5635648', 1);
INSERT INTO `tbl_badges` VALUES (15, 'streak_30', '习惯养成', '连续学习30天', 'streak-30', 'gold', 'streak', '2026-05-22T18:05:27.564866', 1);
INSERT INTO `tbl_badges` VALUES (16, 'accuracy_80', '精准学习者', '正确率达到80%', 'accuracy-80', 'silver', 'challenge', '2026-05-22T18:05:27.5658707', 1);
INSERT INTO `tbl_badges` VALUES (17, 'accuracy_95', '学霸', '正确率达到95%', 'accuracy-95', 'gold', 'challenge', '2026-05-22T18:05:27.5658707', 1);
INSERT INTO `tbl_badges` VALUES (18, 'special_first_day', '初来乍到', '完成第一天的学习', 'special-first', 'bronze', 'special', '2026-05-22T18:05:27.571341', 1);
INSERT INTO `tbl_badges` VALUES (19, 'accuracy_80', '精准学习者', '正确率达到80%', 'accuracy-80', 'silver', 'challenge', '2026-05-22T18:16:38.6355941', 38);
INSERT INTO `tbl_badges` VALUES (20, 'accuracy_95', '学霸', '正确率达到95%', 'accuracy-95', 'gold', 'challenge', '2026-05-22T18:16:38.6385993', 38);
INSERT INTO `tbl_badges` VALUES (21, 'special_first_day', '初来乍到', '完成第一天的学习', 'special-first', 'bronze', 'special', '2026-05-22T18:16:38.6415992', 38);
INSERT INTO `tbl_badges` VALUES (22, 'special_first_day', '初来乍到', '完成第一天的学习', 'special-first', 'bronze', 'special', '2026-05-29T10:40:35.6885472', 39);
INSERT INTO `tbl_badges` VALUES (23, 'accuracy_80', '精准学习者', '正确率达到80%', 'accuracy-80', 'silver', 'challenge', '2026-05-29T10:42:41.6307876', 39);

-- ----------------------------
-- Table structure for tbl_categories
-- ----------------------------
DROP TABLE IF EXISTS `tbl_categories`;
CREATE TABLE `tbl_categories`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_categories
-- ----------------------------
INSERT INTO `tbl_categories` VALUES (1, 'CET4', '大学英语四级词汇');
INSERT INTO `tbl_categories` VALUES (2, 'CET6', '大学英语六级词汇');
INSERT INTO `tbl_categories` VALUES (3, 'TOEFL', '托福考试词汇');
INSERT INTO `tbl_categories` VALUES (4, 'IELTS', '雅思考试词汇');
INSERT INTO `tbl_categories` VALUES (5, '日常英语', '日常交流常用词汇');

-- ----------------------------
-- Table structure for tbl_challenge_records
-- ----------------------------
DROP TABLE IF EXISTS `tbl_challenge_records`;
CREATE TABLE `tbl_challenge_records`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `score` int NULL DEFAULT 0,
  `total_questions` int NULL DEFAULT 0,
  `accuracy` double NULL DEFAULT 0,
  `time_spent` int NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tbl_challenge_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_challenge_records
-- ----------------------------
INSERT INTO `tbl_challenge_records` VALUES (1, 1, 5, 5, 1, 14, '2026-05-22 18:05:28');
INSERT INTO `tbl_challenge_records` VALUES (2, 38, 5, 5, 1, 15, '2026-05-22 18:16:39');
INSERT INTO `tbl_challenge_records` VALUES (3, 39, 13, 14, 0.9285714285714286, 64, '2026-05-29 10:42:42');
INSERT INTO `tbl_challenge_records` VALUES (4, 1, 2, 5, 0.4, 7, '2026-05-29 11:35:51');

-- ----------------------------
-- Table structure for tbl_learning_progress
-- ----------------------------
DROP TABLE IF EXISTS `tbl_learning_progress`;
CREATE TABLE `tbl_learning_progress`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `words_learned` int NULL DEFAULT 0,
  `time_spent` int NULL DEFAULT 0,
  `correct_count` int NULL DEFAULT 0,
  `total_count` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tbl_learning_progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_learning_progress
-- ----------------------------
INSERT INTO `tbl_learning_progress` VALUES (1, 2, '2023-06-01', 20, 60, 15, 20);
INSERT INTO `tbl_learning_progress` VALUES (2, 2, '2023-06-02', 15, 45, 12, 15);
INSERT INTO `tbl_learning_progress` VALUES (3, 2, '2023-06-03', 25, 75, 20, 25);
INSERT INTO `tbl_learning_progress` VALUES (4, 2, '2023-06-04', 18, 55, 15, 18);
INSERT INTO `tbl_learning_progress` VALUES (5, 2, '2023-06-05', 22, 65, 18, 22);
INSERT INTO `tbl_learning_progress` VALUES (6, 2, '2023-06-06', 10, 30, 8, 10);
INSERT INTO `tbl_learning_progress` VALUES (7, 2, '2023-06-07', 10, 30, 9, 10);
INSERT INTO `tbl_learning_progress` VALUES (8, 3, '2023-06-03', 30, 90, 25, 30);
INSERT INTO `tbl_learning_progress` VALUES (9, 3, '2023-06-04', 25, 75, 22, 25);
INSERT INTO `tbl_learning_progress` VALUES (10, 3, '2023-06-05', 35, 105, 30, 35);
INSERT INTO `tbl_learning_progress` VALUES (11, 3, '2023-06-06', 40, 120, 35, 40);
INSERT INTO `tbl_learning_progress` VALUES (12, 3, '2023-06-07', 20, 60, 18, 20);
INSERT INTO `tbl_learning_progress` VALUES (13, 15, '2025-06-20', 1, 1, 0, 0);
INSERT INTO `tbl_learning_progress` VALUES (14, 31, '2026-03-13', 5, 5, 0, 0);
INSERT INTO `tbl_learning_progress` VALUES (15, 37, '2026-05-22', 11, 13, 4, 10);
INSERT INTO `tbl_learning_progress` VALUES (16, 1, '2026-05-22', 5, 14, 5, 5);
INSERT INTO `tbl_learning_progress` VALUES (17, 38, '2026-05-22', 5, 15, 5, 5);
INSERT INTO `tbl_learning_progress` VALUES (18, 1, '2026-05-28', 2, 2, 0, 0);
INSERT INTO `tbl_learning_progress` VALUES (19, 39, '2026-05-29', 21, 71, 13, 14);
INSERT INTO `tbl_learning_progress` VALUES (20, 1, '2026-05-29', 9, 11, 2, 5);

-- ----------------------------
-- Table structure for tbl_roles
-- ----------------------------
DROP TABLE IF EXISTS `tbl_roles`;
CREATE TABLE `tbl_roles`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 132 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_roles
-- ----------------------------
INSERT INTO `tbl_roles` VALUES (1, 'ROLE_USER');
INSERT INTO `tbl_roles` VALUES (2, 'ROLE_MODERATOR');
INSERT INTO `tbl_roles` VALUES (3, 'ROLE_ADMIN');

-- ----------------------------
-- Table structure for tbl_wrong_words
-- ----------------------------
DROP TABLE IF EXISTS `tbl_wrong_words`;
CREATE TABLE `tbl_wrong_words`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `word_id` bigint NOT NULL,
  `wrong_count` int NOT NULL DEFAULT 1,
  `last_wrong_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_wrong_words_user_word`(`user_id` ASC, `word_id` ASC) USING BTREE,
  INDEX `word_id`(`word_id` ASC) USING BTREE,
  CONSTRAINT `tbl_wrong_words_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tbl_wrong_words_ibfk_2` FOREIGN KEY (`word_id`) REFERENCES `tbl_word_cards` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tbl_user_favorites
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user_favorites`;
CREATE TABLE `tbl_user_favorites`  (
  `user_id` bigint NOT NULL,
  `word_id` bigint NOT NULL,
  PRIMARY KEY (`user_id`, `word_id`) USING BTREE,
  INDEX `word_id`(`word_id` ASC) USING BTREE,
  CONSTRAINT `tbl_user_favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tbl_user_favorites_ibfk_2` FOREIGN KEY (`word_id`) REFERENCES `tbl_word_cards` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_user_favorites
-- ----------------------------
INSERT INTO `tbl_user_favorites` VALUES (15, 2);
INSERT INTO `tbl_user_favorites` VALUES (1, 7);
INSERT INTO `tbl_user_favorites` VALUES (3, 9);
INSERT INTO `tbl_user_favorites` VALUES (38, 9);

-- ----------------------------
-- Table structure for tbl_user_roles
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user_roles`;
CREATE TABLE `tbl_user_roles`  (
  `user_id` bigint NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE,
  INDEX `role_id`(`role_id` ASC) USING BTREE,
  CONSTRAINT `tbl_user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tbl_user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `tbl_roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_user_roles
-- ----------------------------
INSERT INTO `tbl_user_roles` VALUES (2, 1);
INSERT INTO `tbl_user_roles` VALUES (3, 1);
INSERT INTO `tbl_user_roles` VALUES (4, 1);
INSERT INTO `tbl_user_roles` VALUES (5, 1);
INSERT INTO `tbl_user_roles` VALUES (11, 1);
INSERT INTO `tbl_user_roles` VALUES (15, 1);
INSERT INTO `tbl_user_roles` VALUES (31, 1);
INSERT INTO `tbl_user_roles` VALUES (37, 1);
INSERT INTO `tbl_user_roles` VALUES (38, 1);
INSERT INTO `tbl_user_roles` VALUES (39, 1);
INSERT INTO `tbl_user_roles` VALUES (3, 2);
INSERT INTO `tbl_user_roles` VALUES (1, 3);

-- ----------------------------
-- Table structure for tbl_users
-- ----------------------------
DROP TABLE IF EXISTS `tbl_users`;
CREATE TABLE `tbl_users`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `learning_streak` int NULL DEFAULT 0,
  `last_study_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `total_words` int NULL DEFAULT 0,
  `total_time` int NULL DEFAULT 0,
  `correct_rate` double NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_users
-- ----------------------------
INSERT INTO `tbl_users` VALUES (1, 'admin', 'admin@example.com', '$2a$10$kGNqxesVh//hGZ93PFJcc.saiegKkeWFSLzDYWWALs8bNW0Wp561G', '管理员', '/uploads/avatars/1_9ddf3a02b031430b9f1c648cc93585b8.png', 32, '2023-06-07', 542, 12477, 0.9159862479194522);
INSERT INTO `tbl_users` VALUES (2, 'user1', 'user1@example.com', '$2a$10$WnYGgzJIEE8UJqQMGAGzpeUO.jJbcpGAjZGvRsEyqwm8JYWj6g5qW', '学习者一号', 'avatar2.png', 7, '2023-06-07', 120, 3600, 0.85);
INSERT INTO `tbl_users` VALUES (3, 'user2', 'user2@example.com', '$2a$10$WnYGgzJIEE8UJqQMGAGzpeUO.jJbcpGAjZGvRsEyqwm8JYWj6g5qW', '英语达人', 'avatar3.png', 15, '2023-06-07', 220, 5400, 0.88);
INSERT INTO `tbl_users` VALUES (4, 'testuser5', 'test5@example.com', '$2a$10$k55tnVDEGyyGeAODhTeYXuothiOKYPhnVlvm/CQzPb0vS9ptN5YEO', 'Test User 5', NULL, 0, NULL, 0, 0, 0);
INSERT INTO `tbl_users` VALUES (5, 'ad123', 'ad123@qq.com', '$2a$10$txEPelIUWfa5RnLHyMRyce7zjwW8A.952TFYRzjf5mZguO.XZobCu', 'ad123', NULL, 0, NULL, 0, 0, 0);
INSERT INTO `tbl_users` VALUES (11, 'admin123', '123456@qq.com', '$2a$10$Azl6cMgJxaadOn0vYlBM1uJtso3urM4b5kQAEXtWeY9ykEwfXSNs2', 'admin123', NULL, 0, NULL, 0, 0, 0);
INSERT INTO `tbl_users` VALUES (15, 'test', '123456789@qq.com', '$2a$10$4vOdewbDgcgvogSLsNSYrODBd3GvSvaG8ujx4QigxaXzh7XX40CfS', '王五', NULL, 0, '2025-06-20', 1, 1, 0);
INSERT INTO `tbl_users` VALUES (31, 'admin123456', 'admin123@qq.com', '$2a$10$xOTK3IxYzCp7V/TXQQ0NhOJMXycHcxdjnFYNh/P7aD.h7.Qpdcvcu', 'ad123456', NULL, 0, '2026-03-13', 5, 5, 0);
INSERT INTO `tbl_users` VALUES (37, 'user111', 'user1@qq.com', '$2a$10$j3jXAuvVTxmgy8qTqU2ekeyPNsW6EPp03jkWG/lj1SNyCDphQXu12', 'user111', NULL, 0, '2026-05-22', 11, 13, 0.19047619047619047);
INSERT INTO `tbl_users` VALUES (38, 'test1', 'test@qq.com', '$2a$10$kGNqxesVh//hGZ93PFJcc.saiegKkeWFSLzDYWWALs8bNW0Wp561G', 'test', '/uploads/avatars/38_7ee1d064a9c040acacf700d7e012b1ac.png', 0, '2026-05-22', 5, 15, 0.5);
INSERT INTO `tbl_users` VALUES (39, 'test2', 'test2@qq.com', '$2a$10$649Kg1kal0JBBDd0jYAe8OBvc5f1wrjo312fIjXBm/RMEgpADuLDW', 'test', '/uploads/avatars/39_366920c0437d42c5af69b8b9c1d9c4c2.png', 0, '2026-05-29', 21, 71, 0.37142857142857144);

-- ----------------------------
-- Table structure for tbl_word_cards
-- ----------------------------
DROP TABLE IF EXISTS `tbl_word_cards`;
CREATE TABLE `tbl_word_cards`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `word` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `translation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phonetic` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `part_of_speech` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `definition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `example` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `difficulty` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `word`(`word` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 371 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_word_cards
-- ----------------------------
INSERT INTO `tbl_word_cards` VALUES (2, 'ability', '能力，才能', '[əˈbɪləti]', 'n.', 'The quality or state of being able; power to perform.', 'He has the ability to solve complex problems.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (3, 'abroad', '国外', '[əˈbrɔːd]', 'adv.', 'In or to a foreign country.', 'He went abroad for his studies.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (4, 'absolute', '绝对的，完全的', '[ˈæbsəluːt]', 'adj.', 'Free from imperfection; complete; perfect.', 'He has absolute control over the situation.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (5, 'absorb', '吸收，吸引', '[əbˈsɔːrb]', 'v.', 'To take in or suck up like a sponge.', 'Plants absorb water through their roots.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (6, 'academic', '学术的，教学的', '[ˌækəˈdemɪk]', 'adj.', 'Relating to a college, academy, school, or other educational institution.', 'He has a strong academic background.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (7, 'accept', '接受，承认', '[əkˈsept]', 'v.', 'To receive something offered willingly.', 'She accepted the job offer.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (8, 'access', '通道，访问', '[ˈækses]', 'n.', 'A way of getting near, at, or to something or someone.', 'The building has wheelchair access.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (9, 'accommodate', '容纳，使适应', '[əˈkɑːmədeɪt]', 'v.', 'To provide with something desired, needed, or suited.', 'The hotel can accommodate up to 500 guests.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (10, 'accompany', '陪伴，伴随', '[əˈkʌmpəni]', 'v.', 'To go with as a companion or associate.', 'She accompanied me to the concert.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (11, 'balance', '平衡，均衡', '[ˈbæləns]', 'n.', 'A state of equilibrium or equipoise; equal distribution of weight, amount, etc.', 'She has a good balance between work and personal life.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (12, 'basic', '基本的，基础的', '[ˈbeɪsɪk]', 'adj.', 'Forming an essential foundation or starting point; fundamental.', 'These are the basic principles of mathematics.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (13, 'beautiful', '美丽的，漂亮的', '[ˈbjuːtɪfl]', 'adj.', 'Having beauty; pleasing to the senses or to the mind.', 'She has a beautiful singing voice.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (14, 'behavior', '行为，举止', '[bɪˈheɪvjər]', 'n.', 'The way in which one acts or conducts oneself, especially toward others.', 'His behavior was inappropriate for the formal occasion.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (15, 'believe', '相信，认为', '[bɪˈliːv]', 'v.', 'To have confidence in the truth, the existence, or the reliability of something.', 'I believe that everything happens for a reason.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (16, 'benefit', '益处，好处', '[ˈbenɪfɪt]', 'n.', 'An advantage or profit gained from something.', 'The new policy will bring benefits to all employees.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (17, 'beyond', '超过，超越', '[bɪˈjɑːnd]', 'prep.', 'At or to the further side of; past.', 'The mountains rise beyond the valley.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (18, 'biology', '生物学', '[baɪˈɑːlədʒi]', 'n.', 'The science of life or living matter in all its forms and phenomena.', 'She is studying biology at university.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (19, 'bitter', '苦的，辛酸的', '[ˈbɪtər]', 'adj.', 'Having a sharp, pungent taste or smell; not sweet.', 'The medicine had a bitter taste.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (20, 'brilliant', '辉煌的，才华横溢的', '[ˈbrɪljənt]', 'adj.', 'Exceptionally clever, talented, or impressive.', 'She gave a brilliant performance in the concert.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (21, 'business', '商业，生意', '[ˈbɪznəs]', 'n.', 'The practice of making one\'s living by engaging in commerce.', 'He started his own business after college.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (22, 'calculate', '计算，估算', '[ˈkælkjuleɪt]', 'v.', 'To determine or ascertain by mathematical methods.', 'He calculated the total cost of the project.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (23, 'capable', '有能力的，能干的', '[ˈkeɪpəbl]', 'adj.', 'Having the ability, fitness, or quality necessary to do or achieve a specified thing.', 'She is capable of handling difficult situations.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (24, 'career', '职业，事业', '[kəˈrɪər]', 'n.', 'An occupation undertaken for a significant period of a person\'s life with opportunities for progress.', 'He has had a successful career in medicine.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (25, 'category', '类别，范畴', '[ˈkætəɡɔːri]', 'n.', 'A class or division of people or things regarded as having particular shared characteristics.', 'These books fall into the category of science fiction.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (26, 'challenge', '挑战，质疑', '[ˈtʃælɪndʒ]', 'n.', 'A task or situation that tests someone\'s abilities.', 'Starting a new business is always a challenge.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (27, 'chance', '机会，可能性', '[tʃæns]', 'n.', 'A possibility of something happening; the occurrence of events in the absence of any obvious design.', 'There\'s a good chance of rain tomorrow.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (28, 'change', '改变，变化', '[tʃeɪndʒ]', 'v.', 'To make or become different.', 'The weather changed suddenly.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (29, 'character', '性格，特征', '[ˈkærəktər]', 'n.', 'The mental and moral qualities distinctive to an individual.', 'He has a strong character.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (30, 'choice', '选择，抉择', '[tʃɔɪs]', 'n.', 'An act of selecting or making a decision when faced with two or more possibilities.', 'You have a choice between tea and coffee.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (31, 'circumstance', '环境，情况', '[ˈsɜːrkəmstæns]', 'n.', 'A fact or condition connected with or relevant to an event or action.', 'The circumstances of his death are suspicious.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (32, 'damage', '损害，损坏', '[ˈdæmɪdʒ]', 'n.', 'Physical harm caused to something in such a way as to impair its value, usefulness, or normal function.', 'The storm caused a lot of damage to the roof.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (33, 'danger', '危险，威胁', '[ˈdeɪndʒər]', 'n.', 'The possibility of suffering harm or injury.', 'There is danger of flooding in low-lying areas.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (34, 'debate', '辩论，讨论', '[dɪˈbeɪt]', 'n.', 'A formal discussion on a particular topic in which opposing arguments are put forward.', 'The candidates will participate in a televised debate.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (35, 'decade', '十年', '[ˈdekeɪd]', 'n.', 'A period of ten years.', 'He has lived in this city for over a decade.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (36, 'decision', '决定，决策', '[dɪˈsɪʒn]', 'n.', 'A conclusion or resolution reached after consideration.', 'Making this decision was not easy.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (37, 'decline', '下降，衰退', '[dɪˈklaɪn]', 'v.', 'To diminish or deteriorate; to become gradually less, fewer, weaker, etc.', 'The number of students has declined over the years.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (38, 'define', '定义，解释', '[dɪˈfaɪn]', 'v.', 'To state or set forth the meaning of a word, phrase, etc.', 'Can you define what \"democracy\" means?', 'medium');
INSERT INTO `tbl_word_cards` VALUES (39, 'definitely', '肯定地，明确地', '[ˈdefɪnətli]', 'adv.', 'Without doubt; clearly.', 'I will definitely be there tomorrow.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (40, 'degree', '程度，学位', '[dɪˈɡriː]', 'n.', 'A unit of measurement of angles, temperature, or academic qualification.', 'She has a degree in economics.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (41, 'democracy', '民主，民主制', '[dɪˈmɑːkrəsi]', 'n.', 'A system of government by the whole population or all the eligible members of a state, typically through elected representatives.', 'The country has made a transition to democracy.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (42, 'earth', '地球，土地', '[ɜːrθ]', 'n.', 'The planet on which we live; the world.', 'The earth orbits around the sun.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (43, 'economy', '经济，节约', '[ɪˈkɑːnəmi]', 'n.', 'The state of a country or region in terms of the production and consumption of goods and services.', 'The country has a strong economy.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (44, 'education', '教育，教育程度', '[ˌedʒuˈkeɪʃn]', 'n.', 'The process of receiving or giving systematic instruction, especially at a school or university.', 'She has had a good education.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (45, 'effect', '影响，效果', '[ɪˈfekt]', 'n.', 'A change which is a result or consequence of an action or other cause.', 'The medicine had a rapid effect.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (46, 'efficient', '高效的，有效率的', '[ɪˈfɪʃnt]', 'adj.', 'Achieving maximum productivity with minimum wasted effort or expense.', 'The new system is more efficient than the old one.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (47, 'effort', '努力，尝试', '[ˈefərt]', 'n.', 'A vigorous or determined attempt.', 'She made a real effort to finish the work on time.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (48, 'either', '两者之一，任一', '[ˈaɪðər]', 'adj./pron.', 'One or the other of two people or things.', 'You can have either tea or coffee.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (49, 'element', '元素，要素', '[ˈelɪmənt]', 'n.', 'An essential or characteristic part of something abstract.', 'Music is an important element in the film.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (50, 'emergency', '紧急情况，突发事件', '[ɪˈmɜːrdʒənsi]', 'n.', 'A serious, unexpected, and often dangerous situation requiring immediate action.', 'In case of emergency, call 911.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (51, 'emotion', '情感，情绪', '[ɪˈmoʊʃn]', 'n.', 'A strong feeling deriving from one\'s circumstances, mood, or relationships with others.', 'She couldn\'t control her emotions.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (52, 'factor', '因素，要素', '[ˈfæktər]', 'n.', 'A circumstance, fact, or influence that contributes to a result or outcome.', 'Time is an important factor in the healing process.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (53, 'fail', '失败，不及格', '[feɪl]', 'v.', 'To be unsuccessful in achieving one\'s goal.', 'He failed the driving test.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (54, 'familiar', '熟悉的，常见的', '[fəˈmɪliər]', 'adj.', 'Well known from long or close association.', 'I\'m familiar with his work.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (55, 'family', '家庭，家族', '[ˈfæməli]', 'n.', 'A group consisting of parents and children living together in a household.', 'He comes from a large family.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (56, 'famous', '著名的，出名的', '[ˈfeɪməs]', 'adj.', 'Known about by many people.', 'She is a famous actress.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (57, 'fantastic', '极好的，极大的', '[fænˈtæstɪk]', 'adj.', 'Extraordinarily good or attractive.', 'We had a fantastic time at the party.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (58, 'fascinating', '迷人的，极有吸引力的', '[ˈfæsɪneɪtɪŋ]', 'adj.', 'Extremely interesting.', 'I found the documentary fascinating.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (59, 'feature', '特征，特点', '[ˈfiːtʃər]', 'n.', 'A distinctive attribute or aspect of something.', 'The new model has several improved features.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (60, 'feedback', '反馈，回应', '[ˈfiːdbæk]', 'n.', 'Information about reactions to a product, a person\'s performance of a task, etc., used as a basis for improvement.', 'The teacher gave me positive feedback on my essay.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (61, 'finally', '最后，终于', '[ˈfaɪnəli]', 'adv.', 'After a long time, typically involving difficulty or delay.', 'She finally arrived at the airport.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (62, 'gain', '获得，增加', '[ɡeɪn]', 'v./n.', 'To obtain or acquire; an increase in amount, magnitude, or degree.', 'She gained valuable experience from the job.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (63, 'general', '一般的，普通的', '[ˈdʒenrəl]', 'adj.', 'Affecting or concerning all or most people, places, or things; widespread.', 'The general opinion is that he did a good job.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (64, 'generation', '一代，产生', '[ˌdʒenəˈreɪʃn]', 'n.', 'All of the people born and living at about the same time, regarded collectively.', 'The younger generation is more comfortable with technology.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (65, 'genius', '天才，天赋', '[ˈdʒiːniəs]', 'n.', 'Exceptional intellectual or creative power or other natural ability.', 'Einstein was a mathematical genius.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (66, 'genuine', '真正的，真诚的', '[ˈdʒenjuɪn]', 'adj.', 'Truly what something is said to be; authentic.', 'The painting was a genuine Picasso.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (67, 'gesture', '手势，姿态', '[ˈdʒestʃər]', 'n.', 'A movement of part of the body, especially a hand or the head, to express an idea or meaning.', 'He made a gesture of apology.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (68, 'global', '全球的，球形的', '[ˈɡloʊbl]', 'adj.', 'Relating to the whole world; worldwide.', 'Global warming is a serious environmental issue.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (69, 'goal', '目标，球门', '[ɡoʊl]', 'n.', 'The object of a person\'s ambition or effort; an aim or desired result.', 'His goal is to become a doctor.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (70, 'gradual', '逐渐的，渐进的', '[ˈɡrædʒuəl]', 'adj.', 'Taking place or progressing slowly or by degrees.', 'There has been a gradual improvement in her health.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (71, 'growth', '生长，增长', '[ɡroʊθ]', 'n.', 'The process of increasing in physical size.', 'The company has experienced significant growth this year.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (72, 'habit', '习惯，习性', '[ˈhæbɪt]', 'n.', 'A settled or regular tendency or practice, especially one that is hard to give up.', 'He has a habit of biting his nails.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (73, 'handle', '处理，操作', '[ˈhændl]', 'v.', 'To manage a situation or problem.', 'She handled the crisis very well.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (74, 'happen', '发生，碰巧', '[ˈhæpən]', 'v.', 'To take place; occur.', 'The accident happened at midnight.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (75, 'happiness', '幸福，快乐', '[ˈhæpinəs]', 'n.', 'The state of being happy.', 'Money does not always bring happiness.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (76, 'harmful', '有害的，致伤的', '[ˈhɑːrmfl]', 'adj.', 'Causing or likely to cause harm.', 'Smoking is harmful to health.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (77, 'health', '健康，保健', '[helθ]', 'n.', 'The state of being free from illness or injury.', 'Regular exercise is good for your health.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (78, 'hesitate', '犹豫，踌躇', '[ˈhezɪteɪt]', 'v.', 'To pause before saying or doing something, especially through uncertainty.', 'She hesitated before answering the question.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (79, 'highlight', '强调，突出', '[ˈhaɪlaɪt]', 'v./n.', 'To emphasize; an outstanding part of an event or period of time.', 'The report highlights the need for further research.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (80, 'history', '历史，来历', '[ˈhɪstri]', 'n.', 'The study of past events, particularly in human affairs.', 'She teaches European history at the university.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (81, 'honest', '诚实的，正直的', '[ˈɑːnɪst]', 'adj.', 'Free of deceit and untruthfulness; sincere.', 'He gave me an honest answer.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (82, 'identify', '识别，认同', '[aɪˈdentɪfaɪ]', 'v.', 'To establish or indicate who or what someone or something is.', 'They couldn\'t identify the suspect.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (83, 'identity', '身份，特性', '[aɪˈdentəti]', 'n.', 'The fact of being who or what a person or thing is.', 'She suffered from a crisis of identity.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (84, 'ignore', '忽视，不理睬', '[ɪɡˈnɔːr]', 'v.', 'To refuse to take notice of or acknowledge; to disregard intentionally.', 'She ignored my advice and did it anyway.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (85, 'illegal', '非法的，违法的', '[ɪˈliːɡl]', 'adj.', 'Contrary to or forbidden by law, especially criminal law.', 'It is illegal to drive without a license.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (86, 'imagine', '想象，设想', '[ɪˈmædʒɪn]', 'v.', 'To form a mental image or concept of.', 'I can\'t imagine life without music.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (87, 'immediate', '立即的，直接的', '[ɪˈmiːdiət]', 'adj.', 'Occurring or done at once; instant.', 'The decision had an immediate effect on prices.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (88, 'impact', '影响，冲击', '[ˈɪmpækt]', 'n./v.', 'A marked effect or influence; to have a strong effect on someone or something.', 'The recession has had a severe impact on employment.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (89, 'implement', '实施，执行', '[ˈɪmplɪment]', 'v.', 'To put a decision, plan, agreement, etc. into effect.', 'The government will implement the new policy next month.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (90, 'importance', '重要性，重要地位', '[ɪmˈpɔːrtns]', 'n.', 'The state or fact of being of great significance or value.', 'He stressed the importance of regular exercise.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (91, 'improve', '改善，提高', '[ɪmˈpruːv]', 'v.', 'To make or become better.', 'Her English has improved a lot.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (122, 'machine', '机器，机械', '[məˈʃiːn]', 'n.', 'An apparatus using mechanical power and having several parts, each with a definite function and together performing a particular task.', 'The washing machine is broken.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (123, 'magic', '魔法，魔术；有魔力的', '[ˈmædʒɪk]', 'n./adj.', 'The power of apparently influencing events by using mysterious or supernatural forces.', 'The magician performed some amazing magic tricks.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (124, 'maintain', '维持，保养', '[meɪnˈteɪn]', 'v.', 'To cause or enable (a condition or state of affairs) to continue.', 'It is important to maintain a healthy lifestyle.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (125, 'major', '主要的；主修', '[ˈmeɪdʒər]', 'adj./n.', 'Important, serious, or significant; a student\'s principal subject or course of study.', 'What is your major in college?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (126, 'manage', '管理，设法', '[ˈmænɪdʒ]', 'v.', 'To be in charge of (a business, organization, or undertaking); to succeed in surviving or in attaining one\'s aims, especially against heavy odds.', 'She managed to finish the project on time.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (127, 'manufacture', '制造，制造业', '[ˌmænjuˈfæktʃər]', 'v./n.', 'To make (something) on a large scale using machinery; the process of manufacturing.', 'The company manufactures electronic devices.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (128, 'margin', '边缘，利润空间', '[ˈmɑːrdʒɪn]', 'n.', 'The edge or border of something; the amount by which something is won or falls short.', 'The company\'s profit margin has increased this year.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (129, 'market', '市场，集市', '[ˈmɑːrkɪt]', 'n.', 'A regular gathering of people for the purchase and sale of provisions, livestock, and other commodities.', 'She goes to the market every Saturday.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (130, 'marriage', '婚姻，结婚', '[ˈmærɪdʒ]', 'n.', 'The legally or formally recognized union of two people as partners in a personal relationship.', 'Their marriage lasted for over 30 years.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (131, 'mass', '大量，团，群众', '[mæs]', 'n.', 'A large body of matter with no definite shape; a large number of people or objects crowded together.', 'A mass of people gathered in the square.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (132, 'nature', '自然，本性', '[ˈneɪtʃər]', 'n.', 'The phenomena of the physical world collectively, including plants, animals, the landscape, and other features and products of the earth.', 'I love spending time in nature.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (133, 'necessary', '必要的，必需的', '[ˈnesəseri]', 'adj.', 'Required to be done, achieved, or present; needed.', 'Water is necessary for life.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (134, 'negotiate', '谈判，协商', '[nɪˈɡoʊʃieɪt]', 'v.', 'To try to reach an agreement or compromise by discussion with others.', 'The two companies are negotiating a merger deal.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (135, 'neighbor', '邻居', '[ˈneɪbər]', 'n.', 'A person living near or next door to the speaker or person referred to.', 'Our neighbors are very friendly.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (136, 'network', '网络，关系网', '[ˈnetwɜːrk]', 'n.', 'A group or system of interconnected people or things.', 'She has a wide network of professional contacts.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (137, 'nevertheless', '然而，不过', '[ˌnevərðəˈles]', 'adv.', 'In spite of that; notwithstanding; all the same.', 'It was a difficult task; nevertheless, she completed it successfully.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (138, 'normal', '正常的，标准的', '[ˈnɔːrml]', 'adj.', 'Conforming to a standard; usual, typical, or expected.', 'Her temperature is back to normal.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (139, 'notice', '注意到，通知', '[ˈnoʊtɪs]', 'v./n.', 'To become aware of; a formal announcement or warning.', 'Did you notice the changes in the office?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (140, 'notion', '概念，想法', '[ˈnoʊʃn]', 'n.', 'A conception of or belief about something; an idea.', 'The notion of time travel has fascinated people for centuries.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (141, 'nuclear', '核的，原子核的', '[ˈnuːkliər]', 'adj.', 'Relating to the nucleus of an atom; denoting, relating to, or powered by nuclear energy.', 'The country has a controversial nuclear energy program.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (142, 'object', '物体；目标；宾语 / 反对', '[ˈɑːbdʒɪkt]', 'n./v.', 'A material thing that can be seen and touched; a goal or purpose; to express disagreement with something.', 'The object of the game is to score more points than the opponent.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (143, 'observe', '观察，遵守', '[əbˈzɜːrv]', 'v.', 'To notice or perceive (something) and register it as being significant; to comply with (a law, rule, or custom).', 'The teacher observed the students during the experiment.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (144, 'obtain', '获得，得到', '[əbˈteɪn]', 'v.', 'To get, acquire, or secure (something).', 'She obtained a visa to travel abroad.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (145, 'obvious', '明显的', '[ˈɑːbviəs]', 'adj.', 'Easily perceived or understood; clear, self-evident, or apparent.', 'The answer is obvious to everyone.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (146, 'occasion', '场合，时机', '[əˈkeɪʒn]', 'n.', 'A particular time or instance of an event; a special or noteworthy event.', 'This is a special occasion for our family.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (147, 'occur', '发生，出现', '[əˈkɜːr]', 'v.', 'To happen; to take place.', 'The accident occurred around midnight.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (148, 'offer', '提供，提议', '[ˈɔːfər]', 'v./n.', 'To present or proffer (something) for (someone) to accept or reject as so desired; an expression of readiness to do or give something if desired.', 'He offered me a cup of tea.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (149, 'official', '官方的，官员', '[əˈfɪʃl]', 'adj./n.', 'Relating to an authority or public body and its duties, actions, and responsibilities; a person holding public office.', 'The official announcement will be made tomorrow.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (150, 'operate', '操作，动手术', '[ˈɑːpəreɪt]', 'v.', 'To control the functioning of (a machine, process, or system); to perform a surgical operation.', 'The surgeon will operate on the patient this afternoon.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (151, 'opinion', '意见，看法', '[əˈpɪnjən]', 'n.', 'A view or judgment formed about something, not necessarily based on fact or knowledge.', 'In my opinion, this is the best restaurant in town.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (152, 'particular', '特定的，挑剔的', '[pərˈtɪkjələr]', 'adj.', 'Used to single out an individual member of a specified group or class; especially great or intense.', 'Is there a particular topic you want to discuss?', 'medium');
INSERT INTO `tbl_word_cards` VALUES (153, 'partner', '伙伴，搭档', '[ˈpɑːrtnər]', 'n.', 'A person who shares or is associated with another in some action or endeavor; a spouse or romantic companion.', 'She is my business partner.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (154, 'passage', '通道，段落', '[ˈpæsɪdʒ]', 'n.', 'The act or process of moving through, under, over, or past something on the way from one place to another; a short section of a book, article, etc.', 'Read the following passage and answer the questions.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (155, 'passion', '热情，激情', '[ˈpæʃn]', 'n.', 'Strong and barely controllable emotion; a state or outburst of strong emotion.', 'Music is her greatest passion.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (156, 'patience', '耐心，忍耐', '[ˈpeɪʃns]', 'n.', 'The capacity to accept or tolerate delay, trouble, or suffering without getting angry or upset.', 'You need a lot of patience to be a teacher.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (157, 'pattern', '模式，图案', '[ˈpætərn]', 'n.', 'A repeated decorative design; a regular and intelligible form or sequence discernible in certain actions or situations.', 'Weather patterns have changed over recent decades.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (158, 'peace', '和平，平静', '[piːs]', 'n.', 'Freedom from disturbance; tranquility; a state or period in which there is no war or a war has ended.', 'I enjoy the peace and quiet of the countryside.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (159, 'perceive', '察觉，理解', '[pərˈsiːv]', 'v.', 'To become aware or conscious of (something); to come to realize or understand.', 'Children perceive the world differently from adults.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (160, 'perform', '表演，执行', '[pərˈfɔːrm]', 'v.', 'To carry out, accomplish, or fulfill (an action, task, or function); to entertain an audience.', 'She will perform a song at the concert.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (161, 'period', '时期，句号', '[ˈpɪriəd]', 'n.', 'A length or portion of time; a punctuation mark (.) used at the end of a sentence.', 'The project will take a period of six months.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (162, 'quality', '质量，品质', '[ˈkwɑːləti]', 'n.', 'The standard of something as measured against other things of a similar kind; the degree of excellence of something.', 'We only sell products of the highest quality.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (163, 'quantity', '数量，大量', '[ˈkwɑːntəti]', 'n.', 'The amount or number of a material or immaterial thing not usually estimated by spatial measurement.', 'Quality is more important than quantity.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (164, 'quarter', '四分之一，季度', '[ˈkwɔːrtər]', 'n.', 'Each of four equal or corresponding parts into which something is or can be divided; a period of three months.', 'The company\'s profits rose by a quarter this year.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (165, 'quest', '探索，追求', '[kwest]', 'n./v.', 'A long or arduous search for something; to search for something.', 'The knight went on a quest for the holy grail.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (166, 'quote', '引用，报价', '[kwoʊt]', 'v./n.', 'To repeat or copy out (a group of words from a text or speech), typically with an indication that one is not the original author; a quotation.', 'She quoted a famous line from Shakespeare.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (167, 'range', '范围，山脉', '[reɪndʒ]', 'n.', 'The area of variation between upper and lower limits on a particular scale; a line or series of mountains.', 'A wide range of products are available online.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (168, 'rapid', '快速的，迅速的', '[ˈræpɪd]', 'adj.', 'Happening in a short time or at a great rate.', 'There has been a rapid increase in demand for electric cars.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (169, 'rare', '稀有的，罕见的', '[rer]', 'adj.', '(Of an event, situation, or condition) not occurring very often; unusually good or remarkable.', 'It is rare to see snow in this region.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (170, 'rate', '比率，率；速度', '[reɪt]', 'n.', 'A measure, quantity, or frequency, typically one measured against another quantity or measure.', 'The unemployment rate has fallen to 5%.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (171, 'rather', '相当，宁愿', '[ˈræðər]', 'adv.', 'To a certain or significant extent or degree; used to indicate one\'s preference in a particular matter.', 'I would rather stay home than go out in the rain.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (172, 'react', '反应，回应', '[riˈækt]', 'v.', 'To respond or behave in a particular way in response to something.', 'How did she react to the news?', 'medium');
INSERT INTO `tbl_word_cards` VALUES (173, 'realize', '意识到，实现', '[ˈriːəlaɪz]', 'v.', 'To become fully aware of (something) as a fact; to achieve (something desired or anticipated).', 'I didn\'t realize you were waiting for me.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (174, 'reason', '理由，原因', '[ˈriːzn]', 'n.', 'A cause, explanation, or justification for an action or event.', 'The reason for the delay was the bad weather.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (175, 'receive', '收到，接待', '[rɪˈsiːv]', 'v.', 'To be given, presented with, or paid (something); to greet or welcome (a visitor) formally.', 'Did you receive my email?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (176, 'recognize', '认出，承认', '[ˈrekəɡnaɪz]', 'v.', 'To identify (someone or something) from having encountered them before; to acknowledge the existence, validity, or legality of.', 'I didn\'t recognize him with his new haircut.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (177, 'sacrifice', '牺牲，献祭', '[ˈsækrɪfaɪs]', 'v./n.', 'To give up (something important or valued) for the sake of other considerations; an act of sacrificing.', 'She made many sacrifices to become a doctor.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (178, 'salary', '薪水，工资', '[ˈsæləri]', 'n.', 'A fixed regular payment, typically paid on a monthly or biweekly basis but often expressed as an annual sum, made by an employer to an employee.', 'He received a generous salary increase.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (179, 'sample', '样品，样本', '[ˈsæmpl]', 'n.', 'A small part or quantity intended to show what the whole is like.', 'They gave us a free sample of the new product.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (180, 'satisfied', '感到满意的', '[ˈsætɪsfaɪd]', 'adj.', 'Contented; pleased.', 'The teacher was satisfied with my progress.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (181, 'scene', '场景，景色', '[siːn]', 'n.', 'The place where an incident in real life or fiction occurs or occurred; a view of a place as seen in a picture.', 'The movie has some incredible action scenes.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (182, 'schedule', '时间表，安排', '[ˈskedʒuːl]', 'n./v.', 'A plan for carrying out a process or procedure, giving lists of intended events and times; to arrange or plan (an event) to take place at a particular time.', 'The meeting is scheduled for 3 p.m.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (183, 'science', '科学', '[ˈsaɪəns]', 'n.', 'The intellectual and practical activity encompassing the systematic study of the structure and behavior of the physical and natural world through observation and experiment.', 'Science has advanced a lot in the last century.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (184, 'screen', '屏幕，屏风', '[skriːn]', 'n.', 'A flat panel or area on an electronic device on which images and data are displayed.', 'He spends too many hours staring at a screen.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (185, 'security', '安全，保安', '[sɪˈkjʊrəti]', 'n.', 'The state of being free from danger or threat; measures taken to ensure safety.', 'Airport security has been tightened.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (186, 'seek', '寻找，寻求', '[siːk]', 'v.', 'To attempt to find (something).', 'They are seeking a solution to the problem.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (187, 'select', '选择，挑选', '[sɪˈlekt]', 'v.', 'To carefully choose as being the best or most suitable.', 'You can select your preferred payment method.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (188, 'sense', '感觉，意义', '[sens]', 'n.', 'A faculty by which the body perceives an external stimulus; a feeling that something is the case.', 'She has a strong sense of responsibility.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (189, 'separate', '分离，分开', '[ˈsepərət]', 'v./adj.', 'To cause to move or be apart; forming or viewed as a unit apart or by itself.', 'The two groups went their separate ways.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (190, 'serious', '严肃的，严重的', '[ˈsɪriəs]', 'adj.', 'Demanding or characterized by careful consideration or application; significant or worrying.', 'The disease can have serious consequences.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (191, 'service', '服务，服役', '[ˈsɜːrvɪs]', 'n.', 'The action of helping or doing work for someone; a system supplying a public need such as transport, communications, or utilities.', 'Customer service was excellent at that hotel.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (192, 'technology', '技术，科技', '[tekˈnɑːlədʒi]', 'n.', 'The application of scientific knowledge for practical purposes, especially in industry.', 'Modern technology has transformed communication.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (193, 'temperature', '温度，体温', '[ˈtemprətʃər]', 'n.', 'The degree or intensity of heat present in a substance or object.', 'The temperature outside is below freezing.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (194, 'temporary', '暂时的，临时的', '[ˈtempəreri]', 'adj.', 'Lasting for only a limited period of time; not permanent.', 'He took a temporary job during the summer.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (195, 'tend', '倾向，照顾', '[tend]', 'v.', 'To regularly or frequently behave in a particular way or have a certain characteristic; to care for or look after.', 'Prices tend to rise during the holiday season.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (196, 'theory', '理论，学说', '[ˈθɪri]', 'n.', 'A supposition or a system of ideas intended to explain something, especially one based on general principles independent of the thing to be explained.', 'Einstein\'s theory of relativity revolutionized physics.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (197, 'therefore', '因此，所以', '[ˈðerfɔːr]', 'adv.', 'For that reason; consequently.', 'He was injured and therefore unable to play.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (198, 'threaten', '威胁，恐吓', '[ˈθretn]', 'v.', 'To state one\'s intention to take hostile action against someone in retribution for something done or not done; to cause someone to feel vulnerable or at risk.', 'The dark clouds threatened rain.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (199, 'tough', '坚韧的，困难的', '[tʌf]', 'adj.', 'Strong enough to withstand adverse conditions or rough handling; difficult and requiring determination or effort.', 'The exam was really tough.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (200, 'tradition', '传统，惯例', '[trəˈdɪʃn]', 'n.', 'The transmission of customs or beliefs from generation to generation, or the fact of being passed on in this way.', 'It is a tradition to have fireworks on New Year\'s Eve.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (201, 'trend', '趋势，动向', '[trend]', 'n.', 'A general direction in which something is developing or changing.', 'There is a growing trend toward remote work.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (202, 'ultimate', '最终的，根本的', '[ˈʌltɪmət]', 'adj.', 'Being or happening at the end of a process; final; the best achievable or imaginable of its kind.', 'The ultimate goal is to provide clean water for everyone.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (203, 'undergo', '经历，遭受', '[ˌʌndərˈɡoʊ]', 'v.', 'To experience or be subjected to (something, typically something unpleasant, painful, or arduous).', 'The patient will undergo surgery tomorrow.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (204, 'understand', '理解，明白', '[ˌʌndərˈstænd]', 'v.', 'To perceive the intended meaning of (words, a language, or a speaker); to interpret or view (something) in a particular way.', 'I don\'t understand what you mean.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (205, 'union', '联盟，工会', '[ˈjuːniən]', 'n.', 'The action or fact of joining or being joined, especially in a political context; an organized association of workers formed to protect and further their rights and interests.', 'The labor union negotiated better wages.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (206, 'unique', '独特的，唯一的', '[juˈniːk]', 'adj.', 'Being the only one of its kind; unlike anything else.', 'Each person has a unique set of fingerprints.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (207, 'value', '价值，价值观', '[ˈvæljuː]', 'n.', 'The regard that something is held to deserve; the importance, worth, or usefulness of something; principles or standards of behavior.', 'The value of this painting is over a million dollars.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (208, 'various', '各种各样的', '[ˈveriəs]', 'adj.', 'Different from one another; of different kinds or sorts.', 'We discussed various topics during the meeting.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (209, 'vehicle', '车辆，交通工具', '[ˈviːəkl]', 'n.', 'A thing used for transporting people or goods, especially on land, such as a car, truck, or cart.', 'The vehicle broke down on the highway.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (210, 'version', '版本，说法', '[ˈvɜːrʒn]', 'n.', 'A particular form of something differing in certain respects from an earlier form or other forms of the same type of thing; an account of a matter from a particular person\'s point of view.', 'The English version of the book is now available.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (211, 'victory', '胜利，成功', '[ˈvɪktəri]', 'n.', 'An act of defeating an enemy or opponent in a battle, game, or other competition.', 'The team celebrated their victory with their fans.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (212, 'weapon', '武器，兵器', '[ˈwepən]', 'n.', 'A thing designed or used for inflicting bodily harm or physical damage.', 'The police found a weapon at the crime scene.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (213, 'weather', '天气，气象', '[ˈweðər]', 'n.', 'The state of the atmosphere at a place and time as regards heat, dryness, sunshine, wind, rain, etc.', 'The weather forecast says it will rain tomorrow.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (214, 'welfare', '福利，幸福', '[ˈwelfer]', 'n.', 'The health, happiness, and fortunes of a person or group; statutory procedure or social effort designed to promote the basic physical and material well-being of people in need.', 'The government provides welfare for the unemployed.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (215, 'widespread', '广泛的，普遍的', '[ˈwaɪdspred]', 'adj.', 'Found or distributed over a large area or number of people.', 'The widespread use of smartphones has changed daily life.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (216, 'wisdom', '智慧，明智', '[ˈwɪzdəm]', 'n.', 'The quality of having experience, knowledge, and good judgment; the soundness of an action or decision with regard to the application of such experience, knowledge, and judgment.', 'He shared some words of wisdom with the students.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (217, 'xenophobia', '仇外心理，排外', '[ˌzenəˈfoʊbiə]', 'n.', 'Dislike of or prejudice against people from other countries.', 'Rising nationalism can sometimes lead to xenophobia.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (218, 'yield', '屈服，产出', '[jiːld]', 'v./n.', 'To produce or provide (a natural, agricultural, or industrial product); to give way to arguments, demands, or pressure.', 'The talks failed to yield any results.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (219, 'youth', '青年，青春', '[juːθ]', 'n.', 'The period between childhood and adult age; young people considered as a group.', 'He spent his youth in the countryside.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (220, 'yearly', '每年的', '[ˈjɪrli]', 'adj./adv.', 'Happening or produced once a year; every year.', 'The company publishes a yearly report on its finances.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (221, 'zone', '区域，地带', '[zoʊn]', 'n.', 'An area or stretch of land having a particular characteristic, purpose, or use, or subject to particular restrictions.', 'This is a no-parking zone.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (242, 'background', '背景', '[ˈbækɡraʊnd]', 'n.', 'The circumstances or situation prevailing at a particular time.', 'She has a background in computer science.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (243, 'battle', '战斗', '[ˈbætl]', 'n.', 'A sustained fight between large organized armed forces.', 'The battle lasted for three days.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (244, 'bear', '熊/忍受', '[ber]', 'n./v.', 'A large mammal; to endure or tolerate.', 'I can\'t bear the pain.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (245, 'beat', '打/击败', '[biːt]', 'v.', 'To strike repeatedly; to defeat in a game or competition.', 'Our team beat the opponents 3-0.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (246, 'become', '成为', '[bɪˈkʌm]', 'v.', 'To begin to be.', 'She became a teacher last year.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (247, 'before', '在…之前', '[bɪˈfɔːr]', 'prep./conj.', 'During the period of time preceding a particular event.', 'Wash your hands before eating.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (248, 'begin', '开始', '[bɪˈɡɪn]', 'v.', 'To start; to perform the first part of an action.', 'The meeting will begin at 10 a.m.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (249, 'being', '生物/存在', '[ˈbiːɪŋ]', 'n.', 'A living creature; existence.', 'Human beings are social creatures.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (250, 'belief', '信仰', '[bɪˈliːf]', 'n.', 'An acceptance that something is true or exists.', 'He has a strong belief in justice.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (251, 'belong', '属于', '[bɪˈlɔːŋ]', 'v.', 'To be the property of; to be a member of a group.', 'This book belongs to me.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (252, 'campaign', '运动/战役', '[kæmˈpeɪn]', 'n.', 'An organized course of action to achieve a goal.', 'The presidential campaign is in full swing.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (253, 'campus', '校园', '[ˈkæmpəs]', 'n.', 'The grounds and buildings of a university or college.', 'Students gathered on the campus for the rally.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (254, 'cancel', '取消', '[ˈkænsl]', 'v.', 'To decide that a planned event will not take place.', 'The flight was canceled due to bad weather.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (255, 'candidate', '候选人', '[ˈkændɪdət]', 'n.', 'A person who applies for a job or is nominated for election.', 'Several candidates were interviewed for the position.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (256, 'capital', '首都/资本', '[ˈkæpɪtl]', 'n.', 'The most important city; wealth in the form of money or assets.', 'London is the capital of the United Kingdom.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (257, 'capture', '捕获', '[ˈkæptʃər]', 'v.', 'To take into one\'s possession or control by force.', 'The police captured the criminal.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (258, 'carbon', '碳', '[ˈkɑːrbən]', 'n.', 'A chemical element that is the basis of all known life.', 'Carbon dioxide is a greenhouse gas.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (259, 'care', '关心', '[ker]', 'n./v.', 'The provision of what is necessary for welfare; to feel concern.', 'She cares deeply about the environment.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (260, 'case', '情况/案例', '[keɪs]', 'n.', 'An instance of a particular situation; a legal action.', 'In many cases, the problem can be solved easily.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (261, 'cause', '原因/事业', '[kɔːz]', 'n./v.', 'A person or thing that gives rise to an action or condition.', 'The cause of the fire is still unknown.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (262, 'data', '数据', '[ˈdeɪtə]', 'n.', 'Facts and statistics collected together for reference or analysis.', 'The data shows a significant increase in sales.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (263, 'deal', '交易/处理', '[diːl]', 'n./v.', 'An agreement for mutual benefit; to take action regarding.', 'We need to deal with this problem immediately.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (264, 'death', '死亡', '[deθ]', 'n.', 'The action or fact of dying; the end of life.', 'The death of the old man shocked the community.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (265, 'deep', '深的', '[diːp]', 'adj.', 'Extending far down from the top or surface.', 'The lake is very deep here.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (266, 'defense', '防御', '[dɪˈfens]', 'n.', 'The action of defending from or resisting attack.', 'The country invested heavily in national defense.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (267, 'demand', '要求', '[dɪˈmænd]', 'n./v.', 'An insistent request, made as if by right.', 'The workers demanded higher wages.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (268, 'deny', '否认', '[dɪˈnaɪ]', 'v.', 'To state that one refuses to admit the truth of.', 'She denied all the accusations.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (269, 'depart', '离开', '[dɪˈpɑːrt]', 'v.', 'To leave, especially in order to start a journey.', 'The train departs at noon.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (270, 'each', '每个', '[iːtʃ]', 'det./pron.', 'Used to refer to every one of two or more people or things.', 'Each student received a certificate.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (271, 'eager', '渴望的', '[ˈiːɡər]', 'adj.', 'Wanting to do or have something very much.', 'The children were eager to open their presents.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (272, 'earn', '赚取', '[ɜːrn]', 'v.', 'To obtain money in return for labor or services.', 'She earns a good salary.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (273, 'ease', '容易/舒适', '[iːz]', 'n.', 'Absence of difficulty or effort.', 'He passed the test with ease.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (274, 'easy', '容易的', '[ˈiːzi]', 'adj.', 'Achieved without great effort; presenting few difficulties.', 'The exam was surprisingly easy.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (275, 'economic', '经济的', '[ˌiːkəˈnɑːmɪk]', 'adj.', 'Relating to economics or the economy.', 'The country is facing a severe economic crisis.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (276, 'effective', '有效的', '[ɪˈfektɪv]', 'adj.', 'Successful in producing a desired or intended result.', 'The medicine proved to be very effective.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (277, 'elder', '年长的', '[ˈeldər]', 'adj./n.', 'Of a greater age among a group of associated people.', 'His elder brother is a doctor.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (278, 'elect', '选举', '[ɪˈlekt]', 'v.', 'To choose someone to hold public office by voting.', 'She was elected president of the student council.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (279, 'electric', '电的', '[ɪˈlektrɪk]', 'adj.', 'Of, worked by, or producing electricity.', 'The guitar has an electric amplifier.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (280, 'electronic', '电子的', '[ɪˌlekˈtrɑːnɪk]', 'adj.', 'Operating with the aid of microchips and transistors.', 'Electronic devices are everywhere.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (281, 'eliminate', '消除', '[ɪˈlɪmɪneɪt]', 'v.', 'To completely remove or get rid of something.', 'We need to eliminate all sources of error.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (282, 'face', '脸/面对', '[feɪs]', 'n./v.', 'The front part of the head; to confront and deal with.', 'She faced many challenges in her career.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (283, 'fact', '事实', '[fækt]', 'n.', 'A thing that is known or proved to be true.', 'It\'s a fact that water boils at 100 degrees Celsius.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (284, 'fair', '公平的', '[fer]', 'adj.', 'In accordance with the rules; legitimate.', 'We need a fair distribution of resources.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (285, 'faith', '信仰', '[feɪθ]', 'n.', 'Complete trust or confidence in someone or something.', 'I have faith in your abilities.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (286, 'fall', '落下/秋天', '[fɔːl]', 'v./n.', 'To move downward; the season after summer.', 'Leaves fall from the trees in autumn.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (287, 'false', '错误的', '[fɔːls]', 'adj.', 'Not according with truth or fact; incorrect.', 'The rumor turned out to be false.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (288, 'fan', '风扇/迷', '[fæn]', 'n.', 'A device for creating a current of air; an admirer.', 'She is a big fan of classical music.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (289, 'game', '游戏', '[ɡeɪm]', 'n.', 'A form of play or sport, especially a competitive one.', 'They played a game of chess.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (290, 'gap', '差距', '[ɡæp]', 'n.', 'A break or opening; a disparity or difference.', 'There is a growing gap between rich and poor.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (291, 'garden', '花园', '[ˈɡɑːrdn]', 'n.', 'A piece of ground used for growing flowers, fruit, or vegetables.', 'She spends her weekends in the garden.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (292, 'gas', '气体/汽油', '[ɡæs]', 'n.', 'An air-like fluid; gasoline.', 'Natural gas is a clean fuel.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (293, 'gather', '聚集', '[ˈɡæðər]', 'v.', 'To come together; to collect.', 'People gathered in the square to celebrate.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (294, 'half', '一半', '[hæf]', 'n./det.', 'Either of two equal parts into which something can be divided.', 'Half of the cake was eaten.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (295, 'hand', '手/传递', '[hænd]', 'n./v.', 'The end part of the arm; to give or pass.', 'Please hand me the salt.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (296, 'hard', '困难的/硬的', '[hɑːrd]', 'adj.', 'Solid, firm; requiring great effort.', 'The math problem was really hard.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (297, 'hate', '憎恨', '[heɪt]', 'v.', 'To feel intense dislike for.', 'I hate getting up early on weekends.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (298, 'have', '有', '[hæv]', 'v.', 'To possess, own, or hold.', 'I have a car.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (299, 'illustrate', '说明', '[ˈɪləstreɪt]', 'v.', 'To explain by using examples, charts, etc.', 'The diagram illustrates the process.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (300, 'image', '图像', '[ˈɪmɪdʒ]', 'n.', 'A representation of the external form of a person or thing.', 'The company is trying to improve its public image.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (301, 'imply', '暗示', '[ɪmˈplaɪ]', 'v.', 'To strongly suggest something not expressly stated.', 'His silence implied consent.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (302, 'import', '进口', '[ˈɪmpɔːrt]', 'n./v.', 'To bring goods or services into a country from abroad.', 'The country imports a lot of oil.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (303, 'include', '包含', '[ɪnˈkluːd]', 'v.', 'To contain as part of a whole.', 'The price includes breakfast.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (304, 'joke', '笑话', '[dʒoʊk]', 'n.', 'A thing said to cause amusement or laughter.', 'He told a funny joke.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (305, 'journal', '期刊', '[ˈdʒɜːrnl]', 'n.', 'A daily record of events; a newspaper or magazine.', 'She writes in her journal every night.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (306, 'kid', '小孩', '[kɪd]', 'n.', 'A child or young person.', 'The kids are playing in the park.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (307, 'kill', '杀死', '[kɪl]', 'v.', 'To cause the death of.', 'The hunter killed the wild animal.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (308, 'king', '国王', '[kɪŋ]', 'n.', 'The male ruler of an independent state.', 'The king ruled the country for 50 years.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (309, 'lead', '领导/铅', '[liːd]/[led]', 'v./n.', 'To guide; the initiative in an action.', 'Who is going to lead the team?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (310, 'leave', '离开', '[liːv]', 'v.', 'To go away from.', 'He will leave the office at 5 p.m.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (311, 'legal', '法律的', '[ˈliːɡl]', 'adj.', 'Relating to the law.', 'You need legal advice before signing the contract.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (312, 'lend', '借出', '[lend]', 'v.', 'To grant the use of something on condition of return.', 'Can you lend me a pen?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (313, 'lesson', '课', '[ˈlesn]', 'n.', 'A period of learning or teaching.', 'The lesson starts at 9 a.m.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (314, 'mark', '标记/分数', '[mɑːrk]', 'n./v.', 'A small area of a different color; a grade or score.', 'She got full marks in the test.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (315, 'master', '主人/大师', '[ˈmæstər]', 'n./v.', 'A person with authority; to acquire complete skill in.', 'He has mastered three languages.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (316, 'material', '材料', '[məˈtɪriəl]', 'n.', 'The matter from which a thing is made.', 'The building materials are very expensive.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (317, 'matter', '事情/物质', '[ˈmætər]', 'n.', 'Physical substance; a subject or issue.', 'What\'s the matter with you?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (318, 'mean', '意思是/吝啬的', '[miːn]', 'v./adj.', 'To intend to convey; unkind.', 'What does this word mean?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (319, 'measure', '测量', '[ˈmeʒər]', 'v.', 'To ascertain the size or amount of something.', 'We need to measure the length of the room.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (320, 'name', '名字', '[neɪm]', 'n./v.', 'A word by which a person or thing is known.', 'What\'s your name?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (321, 'narrow', '狭窄的', '[ˈnæroʊ]', 'adj.', 'Of small width in relation to length.', 'The road is very narrow.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (322, 'nation', '国家', '[ˈneɪʃn]', 'n.', 'A large body of people united by common descent, culture, or language.', 'Every nation has its own traditions.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (323, 'native', '本国的', '[ˈneɪtɪv]', 'adj./n.', 'Associated with the place of a person\'s birth.', 'English is his native language.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (324, 'natural', '自然的', '[ˈnætʃrəl]', 'adj.', 'Existing in or caused by nature; not made by humankind.', 'Natural disasters are becoming more frequent.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (325, 'ocean', '海洋', '[ˈoʊʃn]', 'n.', 'A very large expanse of sea.', 'The Pacific Ocean is the largest.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (326, 'odd', '奇怪的', '[ɑːd]', 'adj.', 'Different from what is usual or expected; strange.', 'It\'s odd that he didn\'t call.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (327, 'offense', '冒犯', '[əˈfens]', 'n.', 'A breach of a law or rule; annoyance or resentment.', 'His remarks caused great offense.', 'hard');
INSERT INTO `tbl_word_cards` VALUES (328, 'oil', '油', '[ɔɪl]', 'n.', 'A viscous liquid derived from petroleum, used as fuel.', 'The price of oil has increased.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (329, 'old', '老的', '[oʊld]', 'adj.', 'Having lived for a long time; no longer young.', 'The old man walked slowly.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (330, 'pain', '疼痛', '[peɪn]', 'n.', 'Physical suffering or discomfort caused by illness or injury.', 'He felt a sharp pain in his back.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (331, 'paper', '纸/论文', '[ˈpeɪpər]', 'n.', 'Material manufactured in thin sheets; an essay.', 'She wrote a research paper on climate change.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (332, 'parent', '父母', '[ˈperənt]', 'n.', 'A father or mother.', 'My parents are visiting this weekend.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (333, 'part', '部分', '[pɑːrt]', 'n.', 'A piece or segment of something.', 'The first part of the movie was boring.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (334, 'pass', '通过/传递', '[pæs]', 'v.', 'To move past; to succeed in a test; to transfer.', 'Did you pass the driving test?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (335, 'past', '过去的', '[pæst]', 'n./adj.', 'Gone by in time; the time before the present.', 'We can learn from past mistakes.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (336, 'pay', '支付', '[peɪ]', 'v.', 'To give money for work done or goods received.', 'How much did you pay for the tickets?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (337, 'perhaps', '也许', '[pərˈhæps]', 'adv.', 'Used to express uncertainty or possibility.', 'Perhaps we should try a different approach.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (338, 'qualify', '使有资格', '[ˈkwɑːlɪfaɪ]', 'v.', 'To become officially recognized as a practitioner; to be entitled.', 'She qualified as a doctor last year.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (339, 'quick', '快的', '[kwɪk]', 'adj.', 'Moving fast or doing something in a short time.', 'She gave a quick response.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (340, 'quiet', '安静的', '[ˈkwaɪət]', 'adj.', 'Making little or no noise.', 'The library is a quiet place.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (341, 'raise', '举起/提高', '[reɪz]', 'v.', 'To lift to a higher position; to increase.', 'The company decided to raise salaries.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (342, 'reach', '到达', '[riːtʃ]', 'v.', 'To stretch out in order to touch; to arrive at.', 'We reached the summit at noon.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (343, 'read', '阅读', '[riːd]', 'v.', 'To look at and comprehend written or printed matter.', 'I like to read novels.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (344, 'ready', '准备好的', '[ˈredi]', 'adj.', 'In a suitable state for an activity; prepared.', 'Dinner is ready.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (345, 'real', '真实的', '[ˈriːəl]', 'adj.', 'Actually existing; not imagined or supposed.', 'Is that a real diamond?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (346, 'really', '真正地', '[ˈriːəli]', 'adv.', 'In actual fact; truly.', 'I really appreciate your help.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (347, 'safe', '安全的', '[seɪf]', 'adj.', 'Protected from danger or risk.', 'Keep your valuables in a safe place.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (348, 'same', '相同的', '[seɪm]', 'adj./pron.', 'Identical; not different.', 'We have the same opinion.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (349, 'save', '拯救/节省', '[seɪv]', 'v.', 'To keep safe; to keep for future use.', 'Doctors saved his life.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (350, 'say', '说', '[seɪ]', 'v.', 'To utter words to convey information.', 'What did she say?', 'easy');
INSERT INTO `tbl_word_cards` VALUES (351, 'school', '学校', '[skuːl]', 'n.', 'An institution for educating children.', 'The kids go to school by bus.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (352, 'score', '分数', '[skɔːr]', 'n.', 'The number of points achieved in a game or test.', 'The final score was 3-1.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (353, 'sea', '海', '[siː]', 'n.', 'The expanse of salt water that covers most of the earth.', 'The sea was calm and blue.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (354, 'search', '搜索', '[sɜːrtʃ]', 'v./n.', 'To try to find something by looking carefully.', 'They searched for the missing child.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (355, 'table', '桌子', '[ˈteɪbl]', 'n.', 'A piece of furniture with a flat top and legs.', 'Put the book on the table.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (356, 'take', '拿/花费', '[teɪk]', 'v.', 'To lay hold of; to carry or bring with one.', 'Please take a seat.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (357, 'talent', '才能', '[ˈtælənt]', 'n.', 'Natural aptitude or skill.', 'She has a talent for music.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (358, 'talk', '谈话', '[tɔːk]', 'v./n.', 'To speak in order to give information or express ideas.', 'We need to talk about your future.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (359, 'target', '目标', '[ˈtɑːrɡɪt]', 'n.', 'A person, object, or place selected as the aim of an attack; an objective.', 'The company set ambitious sales targets.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (360, 'universe', '宇宙', '[ˈjuːnɪvɜːrs]', 'n.', 'All existing matter and space as a whole.', 'The universe is constantly expanding.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (361, 'university', '大学', '[ˌjuːnɪˈvɜːrsəti]', 'n.', 'An institution of higher education awarding degrees.', 'She is studying engineering at the university.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (362, 'unless', '除非', '[ənˈles]', 'conj.', 'Except if.', 'You won\'t pass unless you study hard.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (363, 'view', '视野/观点', '[vjuː]', 'n.', 'The ability to see; a particular way of regarding something.', 'The house has a beautiful view of the lake.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (364, 'village', '村庄', '[ˈvɪlɪdʒ]', 'n.', 'A group of houses smaller than a town.', 'He grew up in a small village.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (365, 'visit', '参观', '[ˈvɪzɪt]', 'v./n.', 'To go to see and spend time with someone or a place.', 'We plan to visit Paris next year.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (366, 'wait', '等待', '[weɪt]', 'v.', 'To stay where one is until a particular time or event.', 'Wait here, I\'ll be right back.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (367, 'walk', '走路', '[wɔːk]', 'v.', 'To move at a regular pace by lifting and setting down each foot.', 'She walks to work every day.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (368, 'want', '想要', '[wɑːnt]', 'v.', 'To have a desire to possess or do; wish for.', 'I want a cup of coffee.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (369, 'x-ray', 'X射线', '[ˈeks reɪ]', 'n.', 'An electromagnetic wave able to pass through many materials.', 'The doctor took an x-ray of his leg.', 'medium');
INSERT INTO `tbl_word_cards` VALUES (370, 'yet', '还/然而', '[jet]', 'adv./conj.', 'Up until now; but at the same time.', 'I haven\'t finished yet.', 'easy');
INSERT INTO `tbl_word_cards` VALUES (371, 'young', '年轻的', '[jʌŋ]', 'adj.', 'Having lived for only a short time.', 'She is too young to drive.', 'easy');

-- ----------------------------
-- Table structure for tbl_word_categories
-- ----------------------------
DROP TABLE IF EXISTS `tbl_word_categories`;
CREATE TABLE `tbl_word_categories`  (
  `word_id` bigint NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`word_id`, `category_id`) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  CONSTRAINT `tbl_word_categories_ibfk_1` FOREIGN KEY (`word_id`) REFERENCES `tbl_word_cards` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tbl_word_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `tbl_categories` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_word_categories
-- ----------------------------
INSERT INTO `tbl_word_categories` VALUES (2, 1);
INSERT INTO `tbl_word_categories` VALUES (3, 1);
INSERT INTO `tbl_word_categories` VALUES (5, 1);
INSERT INTO `tbl_word_categories` VALUES (7, 1);
INSERT INTO `tbl_word_categories` VALUES (11, 1);
INSERT INTO `tbl_word_categories` VALUES (12, 1);
INSERT INTO `tbl_word_categories` VALUES (13, 1);
INSERT INTO `tbl_word_categories` VALUES (15, 1);
INSERT INTO `tbl_word_categories` VALUES (16, 1);
INSERT INTO `tbl_word_categories` VALUES (21, 1);
INSERT INTO `tbl_word_categories` VALUES (24, 1);
INSERT INTO `tbl_word_categories` VALUES (26, 1);
INSERT INTO `tbl_word_categories` VALUES (27, 1);
INSERT INTO `tbl_word_categories` VALUES (28, 1);
INSERT INTO `tbl_word_categories` VALUES (29, 1);
INSERT INTO `tbl_word_categories` VALUES (30, 1);
INSERT INTO `tbl_word_categories` VALUES (32, 1);
INSERT INTO `tbl_word_categories` VALUES (33, 1);
INSERT INTO `tbl_word_categories` VALUES (36, 1);
INSERT INTO `tbl_word_categories` VALUES (39, 1);
INSERT INTO `tbl_word_categories` VALUES (40, 1);
INSERT INTO `tbl_word_categories` VALUES (42, 1);
INSERT INTO `tbl_word_categories` VALUES (44, 1);
INSERT INTO `tbl_word_categories` VALUES (45, 1);
INSERT INTO `tbl_word_categories` VALUES (47, 1);
INSERT INTO `tbl_word_categories` VALUES (48, 1);
INSERT INTO `tbl_word_categories` VALUES (51, 1);
INSERT INTO `tbl_word_categories` VALUES (53, 1);
INSERT INTO `tbl_word_categories` VALUES (55, 1);
INSERT INTO `tbl_word_categories` VALUES (56, 1);
INSERT INTO `tbl_word_categories` VALUES (57, 1);
INSERT INTO `tbl_word_categories` VALUES (61, 1);
INSERT INTO `tbl_word_categories` VALUES (122, 1);
INSERT INTO `tbl_word_categories` VALUES (125, 1);
INSERT INTO `tbl_word_categories` VALUES (126, 1);
INSERT INTO `tbl_word_categories` VALUES (129, 1);
INSERT INTO `tbl_word_categories` VALUES (130, 1);
INSERT INTO `tbl_word_categories` VALUES (132, 1);
INSERT INTO `tbl_word_categories` VALUES (133, 1);
INSERT INTO `tbl_word_categories` VALUES (135, 1);
INSERT INTO `tbl_word_categories` VALUES (138, 1);
INSERT INTO `tbl_word_categories` VALUES (139, 1);
INSERT INTO `tbl_word_categories` VALUES (142, 1);
INSERT INTO `tbl_word_categories` VALUES (145, 1);
INSERT INTO `tbl_word_categories` VALUES (147, 1);
INSERT INTO `tbl_word_categories` VALUES (148, 1);
INSERT INTO `tbl_word_categories` VALUES (149, 1);
INSERT INTO `tbl_word_categories` VALUES (151, 1);
INSERT INTO `tbl_word_categories` VALUES (153, 1);
INSERT INTO `tbl_word_categories` VALUES (158, 1);
INSERT INTO `tbl_word_categories` VALUES (161, 1);
INSERT INTO `tbl_word_categories` VALUES (162, 1);
INSERT INTO `tbl_word_categories` VALUES (164, 1);
INSERT INTO `tbl_word_categories` VALUES (168, 1);
INSERT INTO `tbl_word_categories` VALUES (171, 1);
INSERT INTO `tbl_word_categories` VALUES (173, 1);
INSERT INTO `tbl_word_categories` VALUES (174, 1);
INSERT INTO `tbl_word_categories` VALUES (175, 1);
INSERT INTO `tbl_word_categories` VALUES (180, 1);
INSERT INTO `tbl_word_categories` VALUES (183, 1);
INSERT INTO `tbl_word_categories` VALUES (184, 1);
INSERT INTO `tbl_word_categories` VALUES (188, 1);
INSERT INTO `tbl_word_categories` VALUES (190, 1);
INSERT INTO `tbl_word_categories` VALUES (191, 1);
INSERT INTO `tbl_word_categories` VALUES (193, 1);
INSERT INTO `tbl_word_categories` VALUES (197, 1);
INSERT INTO `tbl_word_categories` VALUES (204, 1);
INSERT INTO `tbl_word_categories` VALUES (207, 1);
INSERT INTO `tbl_word_categories` VALUES (208, 1);
INSERT INTO `tbl_word_categories` VALUES (211, 1);
INSERT INTO `tbl_word_categories` VALUES (213, 1);
INSERT INTO `tbl_word_categories` VALUES (219, 1);
INSERT INTO `tbl_word_categories` VALUES (221, 1);
INSERT INTO `tbl_word_categories` VALUES (244, 1);
INSERT INTO `tbl_word_categories` VALUES (245, 1);
INSERT INTO `tbl_word_categories` VALUES (246, 1);
INSERT INTO `tbl_word_categories` VALUES (247, 1);
INSERT INTO `tbl_word_categories` VALUES (248, 1);
INSERT INTO `tbl_word_categories` VALUES (251, 1);
INSERT INTO `tbl_word_categories` VALUES (254, 1);
INSERT INTO `tbl_word_categories` VALUES (256, 1);
INSERT INTO `tbl_word_categories` VALUES (259, 1);
INSERT INTO `tbl_word_categories` VALUES (260, 1);
INSERT INTO `tbl_word_categories` VALUES (261, 1);
INSERT INTO `tbl_word_categories` VALUES (263, 1);
INSERT INTO `tbl_word_categories` VALUES (264, 1);
INSERT INTO `tbl_word_categories` VALUES (265, 1);
INSERT INTO `tbl_word_categories` VALUES (267, 1);
INSERT INTO `tbl_word_categories` VALUES (270, 1);
INSERT INTO `tbl_word_categories` VALUES (272, 1);
INSERT INTO `tbl_word_categories` VALUES (274, 1);
INSERT INTO `tbl_word_categories` VALUES (279, 1);
INSERT INTO `tbl_word_categories` VALUES (282, 1);
INSERT INTO `tbl_word_categories` VALUES (283, 1);
INSERT INTO `tbl_word_categories` VALUES (284, 1);
INSERT INTO `tbl_word_categories` VALUES (286, 1);
INSERT INTO `tbl_word_categories` VALUES (288, 1);
INSERT INTO `tbl_word_categories` VALUES (289, 1);
INSERT INTO `tbl_word_categories` VALUES (291, 1);
INSERT INTO `tbl_word_categories` VALUES (292, 1);
INSERT INTO `tbl_word_categories` VALUES (294, 1);
INSERT INTO `tbl_word_categories` VALUES (295, 1);
INSERT INTO `tbl_word_categories` VALUES (296, 1);
INSERT INTO `tbl_word_categories` VALUES (297, 1);
INSERT INTO `tbl_word_categories` VALUES (298, 1);
INSERT INTO `tbl_word_categories` VALUES (303, 1);
INSERT INTO `tbl_word_categories` VALUES (304, 1);
INSERT INTO `tbl_word_categories` VALUES (306, 1);
INSERT INTO `tbl_word_categories` VALUES (307, 1);
INSERT INTO `tbl_word_categories` VALUES (308, 1);
INSERT INTO `tbl_word_categories` VALUES (309, 1);
INSERT INTO `tbl_word_categories` VALUES (310, 1);
INSERT INTO `tbl_word_categories` VALUES (312, 1);
INSERT INTO `tbl_word_categories` VALUES (313, 1);
INSERT INTO `tbl_word_categories` VALUES (314, 1);
INSERT INTO `tbl_word_categories` VALUES (316, 1);
INSERT INTO `tbl_word_categories` VALUES (317, 1);
INSERT INTO `tbl_word_categories` VALUES (318, 1);
INSERT INTO `tbl_word_categories` VALUES (320, 1);
INSERT INTO `tbl_word_categories` VALUES (324, 1);
INSERT INTO `tbl_word_categories` VALUES (325, 1);
INSERT INTO `tbl_word_categories` VALUES (328, 1);
INSERT INTO `tbl_word_categories` VALUES (329, 1);
INSERT INTO `tbl_word_categories` VALUES (330, 1);
INSERT INTO `tbl_word_categories` VALUES (331, 1);
INSERT INTO `tbl_word_categories` VALUES (332, 1);
INSERT INTO `tbl_word_categories` VALUES (333, 1);
INSERT INTO `tbl_word_categories` VALUES (334, 1);
INSERT INTO `tbl_word_categories` VALUES (335, 1);
INSERT INTO `tbl_word_categories` VALUES (336, 1);
INSERT INTO `tbl_word_categories` VALUES (337, 1);
INSERT INTO `tbl_word_categories` VALUES (339, 1);
INSERT INTO `tbl_word_categories` VALUES (340, 1);
INSERT INTO `tbl_word_categories` VALUES (341, 1);
INSERT INTO `tbl_word_categories` VALUES (342, 1);
INSERT INTO `tbl_word_categories` VALUES (343, 1);
INSERT INTO `tbl_word_categories` VALUES (344, 1);
INSERT INTO `tbl_word_categories` VALUES (345, 1);
INSERT INTO `tbl_word_categories` VALUES (346, 1);
INSERT INTO `tbl_word_categories` VALUES (347, 1);
INSERT INTO `tbl_word_categories` VALUES (348, 1);
INSERT INTO `tbl_word_categories` VALUES (349, 1);
INSERT INTO `tbl_word_categories` VALUES (350, 1);
INSERT INTO `tbl_word_categories` VALUES (351, 1);
INSERT INTO `tbl_word_categories` VALUES (352, 1);
INSERT INTO `tbl_word_categories` VALUES (353, 1);
INSERT INTO `tbl_word_categories` VALUES (355, 1);
INSERT INTO `tbl_word_categories` VALUES (356, 1);
INSERT INTO `tbl_word_categories` VALUES (358, 1);
INSERT INTO `tbl_word_categories` VALUES (361, 1);
INSERT INTO `tbl_word_categories` VALUES (363, 1);
INSERT INTO `tbl_word_categories` VALUES (364, 1);
INSERT INTO `tbl_word_categories` VALUES (365, 1);
INSERT INTO `tbl_word_categories` VALUES (366, 1);
INSERT INTO `tbl_word_categories` VALUES (367, 1);
INSERT INTO `tbl_word_categories` VALUES (368, 1);
INSERT INTO `tbl_word_categories` VALUES (370, 1);
INSERT INTO `tbl_word_categories` VALUES (371, 1);
INSERT INTO `tbl_word_categories` VALUES (4, 2);
INSERT INTO `tbl_word_categories` VALUES (6, 2);
INSERT INTO `tbl_word_categories` VALUES (8, 2);
INSERT INTO `tbl_word_categories` VALUES (10, 2);
INSERT INTO `tbl_word_categories` VALUES (14, 2);
INSERT INTO `tbl_word_categories` VALUES (17, 2);
INSERT INTO `tbl_word_categories` VALUES (18, 2);
INSERT INTO `tbl_word_categories` VALUES (19, 2);
INSERT INTO `tbl_word_categories` VALUES (20, 2);
INSERT INTO `tbl_word_categories` VALUES (22, 2);
INSERT INTO `tbl_word_categories` VALUES (23, 2);
INSERT INTO `tbl_word_categories` VALUES (25, 2);
INSERT INTO `tbl_word_categories` VALUES (34, 2);
INSERT INTO `tbl_word_categories` VALUES (35, 2);
INSERT INTO `tbl_word_categories` VALUES (37, 2);
INSERT INTO `tbl_word_categories` VALUES (38, 2);
INSERT INTO `tbl_word_categories` VALUES (43, 2);
INSERT INTO `tbl_word_categories` VALUES (46, 2);
INSERT INTO `tbl_word_categories` VALUES (49, 2);
INSERT INTO `tbl_word_categories` VALUES (50, 2);
INSERT INTO `tbl_word_categories` VALUES (52, 2);
INSERT INTO `tbl_word_categories` VALUES (54, 2);
INSERT INTO `tbl_word_categories` VALUES (58, 2);
INSERT INTO `tbl_word_categories` VALUES (59, 2);
INSERT INTO `tbl_word_categories` VALUES (60, 2);
INSERT INTO `tbl_word_categories` VALUES (123, 2);
INSERT INTO `tbl_word_categories` VALUES (124, 2);
INSERT INTO `tbl_word_categories` VALUES (127, 2);
INSERT INTO `tbl_word_categories` VALUES (131, 2);
INSERT INTO `tbl_word_categories` VALUES (134, 2);
INSERT INTO `tbl_word_categories` VALUES (136, 2);
INSERT INTO `tbl_word_categories` VALUES (140, 2);
INSERT INTO `tbl_word_categories` VALUES (141, 2);
INSERT INTO `tbl_word_categories` VALUES (143, 2);
INSERT INTO `tbl_word_categories` VALUES (144, 2);
INSERT INTO `tbl_word_categories` VALUES (146, 2);
INSERT INTO `tbl_word_categories` VALUES (150, 2);
INSERT INTO `tbl_word_categories` VALUES (152, 2);
INSERT INTO `tbl_word_categories` VALUES (154, 2);
INSERT INTO `tbl_word_categories` VALUES (155, 2);
INSERT INTO `tbl_word_categories` VALUES (156, 2);
INSERT INTO `tbl_word_categories` VALUES (157, 2);
INSERT INTO `tbl_word_categories` VALUES (160, 2);
INSERT INTO `tbl_word_categories` VALUES (163, 2);
INSERT INTO `tbl_word_categories` VALUES (166, 2);
INSERT INTO `tbl_word_categories` VALUES (167, 2);
INSERT INTO `tbl_word_categories` VALUES (169, 2);
INSERT INTO `tbl_word_categories` VALUES (170, 2);
INSERT INTO `tbl_word_categories` VALUES (172, 2);
INSERT INTO `tbl_word_categories` VALUES (176, 2);
INSERT INTO `tbl_word_categories` VALUES (178, 2);
INSERT INTO `tbl_word_categories` VALUES (179, 2);
INSERT INTO `tbl_word_categories` VALUES (181, 2);
INSERT INTO `tbl_word_categories` VALUES (182, 2);
INSERT INTO `tbl_word_categories` VALUES (185, 2);
INSERT INTO `tbl_word_categories` VALUES (186, 2);
INSERT INTO `tbl_word_categories` VALUES (187, 2);
INSERT INTO `tbl_word_categories` VALUES (189, 2);
INSERT INTO `tbl_word_categories` VALUES (192, 2);
INSERT INTO `tbl_word_categories` VALUES (194, 2);
INSERT INTO `tbl_word_categories` VALUES (195, 2);
INSERT INTO `tbl_word_categories` VALUES (196, 2);
INSERT INTO `tbl_word_categories` VALUES (198, 2);
INSERT INTO `tbl_word_categories` VALUES (199, 2);
INSERT INTO `tbl_word_categories` VALUES (200, 2);
INSERT INTO `tbl_word_categories` VALUES (201, 2);
INSERT INTO `tbl_word_categories` VALUES (205, 2);
INSERT INTO `tbl_word_categories` VALUES (206, 2);
INSERT INTO `tbl_word_categories` VALUES (209, 2);
INSERT INTO `tbl_word_categories` VALUES (210, 2);
INSERT INTO `tbl_word_categories` VALUES (212, 2);
INSERT INTO `tbl_word_categories` VALUES (214, 2);
INSERT INTO `tbl_word_categories` VALUES (216, 2);
INSERT INTO `tbl_word_categories` VALUES (218, 2);
INSERT INTO `tbl_word_categories` VALUES (220, 2);
INSERT INTO `tbl_word_categories` VALUES (242, 2);
INSERT INTO `tbl_word_categories` VALUES (243, 2);
INSERT INTO `tbl_word_categories` VALUES (249, 2);
INSERT INTO `tbl_word_categories` VALUES (250, 2);
INSERT INTO `tbl_word_categories` VALUES (252, 2);
INSERT INTO `tbl_word_categories` VALUES (253, 2);
INSERT INTO `tbl_word_categories` VALUES (255, 2);
INSERT INTO `tbl_word_categories` VALUES (257, 2);
INSERT INTO `tbl_word_categories` VALUES (258, 2);
INSERT INTO `tbl_word_categories` VALUES (262, 2);
INSERT INTO `tbl_word_categories` VALUES (266, 2);
INSERT INTO `tbl_word_categories` VALUES (268, 2);
INSERT INTO `tbl_word_categories` VALUES (269, 2);
INSERT INTO `tbl_word_categories` VALUES (271, 2);
INSERT INTO `tbl_word_categories` VALUES (273, 2);
INSERT INTO `tbl_word_categories` VALUES (275, 2);
INSERT INTO `tbl_word_categories` VALUES (276, 2);
INSERT INTO `tbl_word_categories` VALUES (277, 2);
INSERT INTO `tbl_word_categories` VALUES (278, 2);
INSERT INTO `tbl_word_categories` VALUES (280, 2);
INSERT INTO `tbl_word_categories` VALUES (285, 2);
INSERT INTO `tbl_word_categories` VALUES (287, 2);
INSERT INTO `tbl_word_categories` VALUES (290, 2);
INSERT INTO `tbl_word_categories` VALUES (293, 2);
INSERT INTO `tbl_word_categories` VALUES (299, 2);
INSERT INTO `tbl_word_categories` VALUES (300, 2);
INSERT INTO `tbl_word_categories` VALUES (301, 2);
INSERT INTO `tbl_word_categories` VALUES (302, 2);
INSERT INTO `tbl_word_categories` VALUES (305, 2);
INSERT INTO `tbl_word_categories` VALUES (311, 2);
INSERT INTO `tbl_word_categories` VALUES (315, 2);
INSERT INTO `tbl_word_categories` VALUES (319, 2);
INSERT INTO `tbl_word_categories` VALUES (321, 2);
INSERT INTO `tbl_word_categories` VALUES (322, 2);
INSERT INTO `tbl_word_categories` VALUES (323, 2);
INSERT INTO `tbl_word_categories` VALUES (326, 2);
INSERT INTO `tbl_word_categories` VALUES (338, 2);
INSERT INTO `tbl_word_categories` VALUES (354, 2);
INSERT INTO `tbl_word_categories` VALUES (357, 2);
INSERT INTO `tbl_word_categories` VALUES (359, 2);
INSERT INTO `tbl_word_categories` VALUES (360, 2);
INSERT INTO `tbl_word_categories` VALUES (362, 2);
INSERT INTO `tbl_word_categories` VALUES (369, 2);
INSERT INTO `tbl_word_categories` VALUES (6, 3);
INSERT INTO `tbl_word_categories` VALUES (9, 3);
INSERT INTO `tbl_word_categories` VALUES (31, 3);
INSERT INTO `tbl_word_categories` VALUES (41, 3);
INSERT INTO `tbl_word_categories` VALUES (128, 3);
INSERT INTO `tbl_word_categories` VALUES (137, 3);
INSERT INTO `tbl_word_categories` VALUES (159, 3);
INSERT INTO `tbl_word_categories` VALUES (165, 3);
INSERT INTO `tbl_word_categories` VALUES (177, 3);
INSERT INTO `tbl_word_categories` VALUES (202, 3);
INSERT INTO `tbl_word_categories` VALUES (203, 3);
INSERT INTO `tbl_word_categories` VALUES (215, 3);
INSERT INTO `tbl_word_categories` VALUES (217, 3);
INSERT INTO `tbl_word_categories` VALUES (281, 3);
INSERT INTO `tbl_word_categories` VALUES (327, 3);
INSERT INTO `tbl_word_categories` VALUES (9, 4);
INSERT INTO `tbl_word_categories` VALUES (41, 4);
INSERT INTO `tbl_word_categories` VALUES (128, 4);
INSERT INTO `tbl_word_categories` VALUES (159, 4);
INSERT INTO `tbl_word_categories` VALUES (217, 4);
INSERT INTO `tbl_word_categories` VALUES (281, 4);
INSERT INTO `tbl_word_categories` VALUES (327, 4);
INSERT INTO `tbl_word_categories` VALUES (3, 5);
INSERT INTO `tbl_word_categories` VALUES (7, 5);
INSERT INTO `tbl_word_categories` VALUES (11, 5);
INSERT INTO `tbl_word_categories` VALUES (13, 5);
INSERT INTO `tbl_word_categories` VALUES (15, 5);
INSERT INTO `tbl_word_categories` VALUES (21, 5);
INSERT INTO `tbl_word_categories` VALUES (24, 5);
INSERT INTO `tbl_word_categories` VALUES (27, 5);
INSERT INTO `tbl_word_categories` VALUES (28, 5);
INSERT INTO `tbl_word_categories` VALUES (33, 5);
INSERT INTO `tbl_word_categories` VALUES (42, 5);
INSERT INTO `tbl_word_categories` VALUES (48, 5);
INSERT INTO `tbl_word_categories` VALUES (53, 5);
INSERT INTO `tbl_word_categories` VALUES (55, 5);
INSERT INTO `tbl_word_categories` VALUES (57, 5);
INSERT INTO `tbl_word_categories` VALUES (122, 5);
INSERT INTO `tbl_word_categories` VALUES (125, 5);
INSERT INTO `tbl_word_categories` VALUES (126, 5);
INSERT INTO `tbl_word_categories` VALUES (129, 5);
INSERT INTO `tbl_word_categories` VALUES (132, 5);
INSERT INTO `tbl_word_categories` VALUES (135, 5);
INSERT INTO `tbl_word_categories` VALUES (138, 5);
INSERT INTO `tbl_word_categories` VALUES (142, 5);
INSERT INTO `tbl_word_categories` VALUES (148, 5);
INSERT INTO `tbl_word_categories` VALUES (151, 5);
INSERT INTO `tbl_word_categories` VALUES (153, 5);
INSERT INTO `tbl_word_categories` VALUES (158, 5);
INSERT INTO `tbl_word_categories` VALUES (162, 5);
INSERT INTO `tbl_word_categories` VALUES (171, 5);
INSERT INTO `tbl_word_categories` VALUES (174, 5);
INSERT INTO `tbl_word_categories` VALUES (184, 5);
INSERT INTO `tbl_word_categories` VALUES (191, 5);
INSERT INTO `tbl_word_categories` VALUES (193, 5);
INSERT INTO `tbl_word_categories` VALUES (204, 5);
INSERT INTO `tbl_word_categories` VALUES (207, 5);
INSERT INTO `tbl_word_categories` VALUES (213, 5);
INSERT INTO `tbl_word_categories` VALUES (219, 5);
INSERT INTO `tbl_word_categories` VALUES (244, 5);
INSERT INTO `tbl_word_categories` VALUES (245, 5);
INSERT INTO `tbl_word_categories` VALUES (246, 5);
INSERT INTO `tbl_word_categories` VALUES (247, 5);
INSERT INTO `tbl_word_categories` VALUES (248, 5);
INSERT INTO `tbl_word_categories` VALUES (251, 5);
INSERT INTO `tbl_word_categories` VALUES (254, 5);
INSERT INTO `tbl_word_categories` VALUES (256, 5);
INSERT INTO `tbl_word_categories` VALUES (259, 5);
INSERT INTO `tbl_word_categories` VALUES (260, 5);
INSERT INTO `tbl_word_categories` VALUES (261, 5);
INSERT INTO `tbl_word_categories` VALUES (263, 5);
INSERT INTO `tbl_word_categories` VALUES (264, 5);
INSERT INTO `tbl_word_categories` VALUES (265, 5);
INSERT INTO `tbl_word_categories` VALUES (267, 5);
INSERT INTO `tbl_word_categories` VALUES (270, 5);
INSERT INTO `tbl_word_categories` VALUES (272, 5);
INSERT INTO `tbl_word_categories` VALUES (274, 5);
INSERT INTO `tbl_word_categories` VALUES (279, 5);
INSERT INTO `tbl_word_categories` VALUES (282, 5);
INSERT INTO `tbl_word_categories` VALUES (283, 5);
INSERT INTO `tbl_word_categories` VALUES (284, 5);
INSERT INTO `tbl_word_categories` VALUES (286, 5);
INSERT INTO `tbl_word_categories` VALUES (288, 5);
INSERT INTO `tbl_word_categories` VALUES (289, 5);
INSERT INTO `tbl_word_categories` VALUES (291, 5);
INSERT INTO `tbl_word_categories` VALUES (292, 5);
INSERT INTO `tbl_word_categories` VALUES (294, 5);
INSERT INTO `tbl_word_categories` VALUES (295, 5);
INSERT INTO `tbl_word_categories` VALUES (296, 5);
INSERT INTO `tbl_word_categories` VALUES (297, 5);
INSERT INTO `tbl_word_categories` VALUES (298, 5);
INSERT INTO `tbl_word_categories` VALUES (303, 5);
INSERT INTO `tbl_word_categories` VALUES (304, 5);
INSERT INTO `tbl_word_categories` VALUES (306, 5);
INSERT INTO `tbl_word_categories` VALUES (307, 5);
INSERT INTO `tbl_word_categories` VALUES (308, 5);
INSERT INTO `tbl_word_categories` VALUES (309, 5);
INSERT INTO `tbl_word_categories` VALUES (310, 5);
INSERT INTO `tbl_word_categories` VALUES (312, 5);
INSERT INTO `tbl_word_categories` VALUES (313, 5);
INSERT INTO `tbl_word_categories` VALUES (314, 5);
INSERT INTO `tbl_word_categories` VALUES (316, 5);
INSERT INTO `tbl_word_categories` VALUES (317, 5);
INSERT INTO `tbl_word_categories` VALUES (318, 5);
INSERT INTO `tbl_word_categories` VALUES (320, 5);
INSERT INTO `tbl_word_categories` VALUES (324, 5);
INSERT INTO `tbl_word_categories` VALUES (325, 5);
INSERT INTO `tbl_word_categories` VALUES (328, 5);
INSERT INTO `tbl_word_categories` VALUES (329, 5);
INSERT INTO `tbl_word_categories` VALUES (330, 5);
INSERT INTO `tbl_word_categories` VALUES (331, 5);
INSERT INTO `tbl_word_categories` VALUES (332, 5);
INSERT INTO `tbl_word_categories` VALUES (333, 5);
INSERT INTO `tbl_word_categories` VALUES (334, 5);
INSERT INTO `tbl_word_categories` VALUES (335, 5);
INSERT INTO `tbl_word_categories` VALUES (336, 5);
INSERT INTO `tbl_word_categories` VALUES (337, 5);
INSERT INTO `tbl_word_categories` VALUES (339, 5);
INSERT INTO `tbl_word_categories` VALUES (340, 5);
INSERT INTO `tbl_word_categories` VALUES (341, 5);
INSERT INTO `tbl_word_categories` VALUES (342, 5);
INSERT INTO `tbl_word_categories` VALUES (343, 5);
INSERT INTO `tbl_word_categories` VALUES (344, 5);
INSERT INTO `tbl_word_categories` VALUES (345, 5);
INSERT INTO `tbl_word_categories` VALUES (346, 5);
INSERT INTO `tbl_word_categories` VALUES (347, 5);
INSERT INTO `tbl_word_categories` VALUES (348, 5);
INSERT INTO `tbl_word_categories` VALUES (349, 5);
INSERT INTO `tbl_word_categories` VALUES (350, 5);
INSERT INTO `tbl_word_categories` VALUES (351, 5);
INSERT INTO `tbl_word_categories` VALUES (352, 5);
INSERT INTO `tbl_word_categories` VALUES (353, 5);
INSERT INTO `tbl_word_categories` VALUES (355, 5);
INSERT INTO `tbl_word_categories` VALUES (356, 5);
INSERT INTO `tbl_word_categories` VALUES (358, 5);
INSERT INTO `tbl_word_categories` VALUES (361, 5);
INSERT INTO `tbl_word_categories` VALUES (363, 5);
INSERT INTO `tbl_word_categories` VALUES (364, 5);
INSERT INTO `tbl_word_categories` VALUES (365, 5);
INSERT INTO `tbl_word_categories` VALUES (366, 5);
INSERT INTO `tbl_word_categories` VALUES (367, 5);
INSERT INTO `tbl_word_categories` VALUES (368, 5);
INSERT INTO `tbl_word_categories` VALUES (370, 5);
INSERT INTO `tbl_word_categories` VALUES (371, 5);

SET FOREIGN_KEY_CHECKS = 1;
