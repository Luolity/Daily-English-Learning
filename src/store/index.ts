import { createStore } from 'vuex'
import createPersistedState from 'vuex-persistedstate'
import type { IWordCard, IVocabulary, ILearningProgress, IBadge, IAchievement, IProgressUpdate, IUserInfo, IAppSettings } from './types'
import { getUserAvatarUrl } from '../utils/avatar'
import { api } from '../services/api'
import { calcTotalPages } from '../utils/pagination'

// 导入API响应类型
interface WordCardResponse {
  content?: IWordCard[];
  records?: IWordCard[];
  data?: IWordCard[];
  currentPage?: number;
  totalItems?: number;
  totalPages?: number;
  [key: string]: any;
}

export default createStore({
  plugins: [
    createPersistedState({
      storage: {
        getItem: (key: string) => uni.getStorageSync(key),
        setItem: (key: string, value: string) => uni.setStorageSync(key, value),
        removeItem: (key: string) => uni.removeStorageSync(key)
      }
    })
  ],
  state: {
    // 用户信息
    userInfo: {
      id: '',
      nickname: '',
      avatar: '',
      roles: [],
      isLoggedIn: false
    } as IUserInfo,
    // 单词学习
    vocabulary: {
      wordList: [] as IWordCard[],
      favorites: [] as IWordCard[],
      categories: ['CET4', 'CET6', 'TOEFL', 'IELTS', 'GRE']
    } as IVocabulary,
    // 学习进度
    learningProgress: {
      streak: 0, // 连续学习天数
      lastStudyDate: '', // 上次学习日期
      totalWords: 0, // 已学单词总数
      totalTime: 0, // 总学习时间（分钟）
      dailyStats: [] as ILearningProgress[], // 每日学习统计
      correctRate: 0 // 正确率
    },
    // 成就系统
    achievements: {
      badges: [] as IBadge[], // 已获得徽章
      unlockedAchievements: [] as IAchievement[], // 已解锁成就
      badgeCompletion: 0 // 徽章完成度
    },
    // 听力练习
    listening: {
      downloadedAudios: [] as any[], // 已下载的音频
      history: [] as any[] // 听力练习历史
    },
    loading: false,
    error: null as string | null,
    appSettings: {
      theme: 'light',
      soundEnabled: true,
      notificationEnabled: true,
      dailyTarget: 20,
      defaultDifficulty: 'medium'
    } as IAppSettings
  },
  mutations: {
    // 用户相关
    SET_USER_INFO(state, userInfo: Partial<IUserInfo>) {
      state.userInfo = { ...state.userInfo, ...userInfo };
    },
    SET_APP_SETTING(state, { key, value }: { key: keyof IAppSettings; value: IAppSettings[keyof IAppSettings] }) {
      if (key in state.appSettings) {
        (state.appSettings as Record<string, unknown>)[key] = value;
      }
    },
    LOGIN(state, userInfo: IUserInfo) {
      state.userInfo = {
        ...userInfo,
        avatar: userInfo.avatar ? getUserAvatarUrl(userInfo.avatar) : getUserAvatarUrl(),
        isLoggedIn: true
      };
    },
    LOGOUT(state) {
      state.userInfo = {
        id: '',
        nickname: '',
        avatar: '',
        roles: [],
        isLoggedIn: false
      };
      state.vocabulary = {
        wordList: [],
        favorites: [],
        categories: ['CET4', 'CET6', 'TOEFL', 'IELTS', 'GRE']
      };
      state.learningProgress = {
        streak: 0,
        lastStudyDate: '',
        totalWords: 0,
        totalTime: 0,
        dailyStats: [],
        correctRate: 0
      };
      state.achievements = {
        badges: [],
        unlockedAchievements: [],
        badgeCompletion: 0
      };
      state.listening = {
        downloadedAudios: [],
        history: []
      };
    },
    
    // 单词相关
    SET_WORD_LIST(state, wordList: IWordCard[]) {
      state.vocabulary.wordList = wordList;
    },
    ADD_TO_FAVORITES(state, word: IWordCard) {
      if (!state.vocabulary.favorites.some((item: IWordCard) => item.id === word.id)) {
        state.vocabulary.favorites.push(word);
      }
    },
    REMOVE_FROM_FAVORITES(state, wordId: string) {
      state.vocabulary.favorites = state.vocabulary.favorites.filter((word: IWordCard) => word.id !== wordId);
    },
    SET_FAVORITES(state, favorites: IWordCard[]) {
      state.vocabulary.favorites = favorites;
    },
    
    // 学习进度相关
    UPDATE_LEARNING_PROGRESS(state, progress: IProgressUpdate) {
      const today = new Date().toISOString().split('T')[0];
      
      // 更新连续学习天数
      if (state.learningProgress.lastStudyDate !== today) {
        const yesterday = new Date();
        yesterday.setDate(yesterday.getDate() - 1);
        const yesterdayStr = yesterday.toISOString().split('T')[0];
        
        if (state.learningProgress.lastStudyDate === yesterdayStr) {
          state.learningProgress.streak += 1;
        } else if (state.learningProgress.lastStudyDate !== today) {
          state.learningProgress.streak = 1;
        }
        
        state.learningProgress.lastStudyDate = today;
      }
      
      // 更新学习统计
      state.learningProgress.totalWords += progress.wordsLearned || 0;
      state.learningProgress.totalTime += progress.timeSpent || 0;
      
      // 更新每日统计
      const todayStats = state.learningProgress.dailyStats.find(item => item.date === today);
      if (todayStats) {
        todayStats.wordsLearned += progress.wordsLearned || 0;
        todayStats.timeSpent += progress.timeSpent || 0;
        todayStats.correctCount += progress.correctCount || 0;
        todayStats.totalCount += progress.totalCount || 0;
      } else {
        state.learningProgress.dailyStats.push({
          date: today,
          wordsLearned: progress.wordsLearned || 0,
          timeSpent: progress.timeSpent || 0,
          correctCount: progress.correctCount || 0,
          totalCount: progress.totalCount || 0
        });
      }
      
      // 更新正确率
      if (progress.totalCount && progress.totalCount > 0) {
        const totalCorrect = state.learningProgress.dailyStats.reduce((sum, item) => sum + item.correctCount, 0);
        const totalQuestions = state.learningProgress.dailyStats.reduce((sum, item) => sum + item.totalCount, 0);
        state.learningProgress.correctRate = totalCorrect / totalQuestions;
      }
    },
    
    // 成就相关
    ADD_BADGE(state, badge: IBadge & { badgeId?: string }) {
      const badgeKey = badge.badgeId || badge.id;
      if (!state.achievements.badges.some(item => (item as any).badgeId === badgeKey || item.id === badgeKey)) {
        state.achievements.badges.push({ ...badge, id: badgeKey, badgeId: badgeKey } as IBadge);
      }
    },
    UNLOCK_ACHIEVEMENT(state, achievement: IAchievement) {
      if (!state.achievements.unlockedAchievements.some(item => item.id === achievement.id)) {
        state.achievements.unlockedAchievements.push(achievement);
      }
    },
    
    // 听力相关
    ADD_DOWNLOADED_AUDIO(state, audio: any) {
      if (!state.listening.downloadedAudios.some(item => item.id === audio.id)) {
        state.listening.downloadedAudios.push(audio);
      }
    },
    ADD_LISTENING_HISTORY(state, history: any) {
      state.listening.history.push(history);
    },
    SET_LOADING(state, loading) {
      state.loading = loading;
    },
    SET_ERROR(state, error) {
      state.error = error;
    },
    SET_BADGES(state, badges: IBadge[]) {
      state.achievements.badges = badges;
    },
    SET_BADGE_COMPLETION(state, completion: number) {
      state.achievements.badgeCompletion = completion;
    }
  },
  actions: {
    // 获取单词列表
    async fetchWordList({ commit }, { category, difficulty, keyword, page = 1, size = 10 }: { category?: string, difficulty?: string, keyword?: string, page?: number, size?: number }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        const response = await api.wordCards.getWordCards(page, size, category, difficulty, keyword);
        console.log('getWordCards response:', response);
        
        // 健壮性判断
        if (response && response.content && Array.isArray(response.content)) {
          const totalItems = response.totalItems ?? 0;
          commit('SET_WORD_LIST', response.content);
          return {
            content: response.content,
            currentPage: response.currentPage || page,
            pageSize: size,
            totalItems,
            totalPages: calcTotalPages(totalItems, size)
          };
        } else if (response && Array.isArray(response)) {
          commit('SET_WORD_LIST', response);
          return {
            content: response,
            currentPage: page,
            pageSize: size,
            totalItems: response.length,
            totalPages: calcTotalPages(response.length, size)
          };
        } else if (response) {
          const possibleWordList = response.records || response.data || response.wordList || [];
          const totalItems = response.totalItems ?? 0;
          commit('SET_WORD_LIST', possibleWordList);
          console.warn('返回数据结构不符合预期，尝试提取数据:', possibleWordList);
          return {
            content: possibleWordList,
            currentPage: response.currentPage || page,
            pageSize: size,
            totalItems,
            totalPages: calcTotalPages(totalItems, size)
          };
        } else {
          commit('SET_WORD_LIST', []);
          console.error('获取单词列表失败，返回内容异常:', response);
          return {
            content: [],
            currentPage: page,
            pageSize: size,
            totalItems: 0,
            totalPages: 0
          };
        }
      } catch (error) {
        console.error('获取单词列表失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '获取单词列表失败');
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 添加到生词本
    async addToFavorites({ commit }, word: IWordCard) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        await api.wordCards.addToFavorites(word.id);
        commit('ADD_TO_FAVORITES', word);
        uni.showToast({
          title: '已添加到生词本',
          icon: 'success'
        });
        return true;
      } catch (error) {
        console.error('添加到生词本失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '添加到生词本失败');
        uni.showToast({
          title: '添加失败',
          icon: 'error'
        });
        return false;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 从生词本移除
    async removeFromFavorites({ commit }, wordId: string) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        await api.wordCards.removeFromFavorites(wordId);
        commit('REMOVE_FROM_FAVORITES', wordId);
        uni.showToast({
          title: '已从生词本移除',
          icon: 'success'
        });
        return true;
      } catch (error) {
        console.error('从生词本移除失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '从生词本移除失败');
        uni.showToast({
          title: '移除失败',
          icon: 'error'
        });
        return false;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 更新学习进度
    async updateProgress({ commit, dispatch, state }, progress: IProgressUpdate) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        commit('UPDATE_LEARNING_PROGRESS', progress);
        await api.progress.updateProgress(progress);
        await dispatch('checkAndAwardBadges');
        return state.learningProgress;
      } catch (error) {
        console.error('更新学习进度失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '更新学习进度失败');
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },

    // 检查并刷新徽章
    async checkAndAwardBadges({ dispatch }) {
      try {
        await api.badges.checkAndAwardBadges();
        await dispatch('fetchBadges');
        await dispatch('getBadgeCompletion');
        return true;
      } catch (error) {
        console.error('检查徽章解锁失败:', error);
        return false;
      }
    },
    
    // 获取用户徽章
    async fetchBadges({ commit }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        console.log('开始获取用户徽章...');
        // 获取用户徽章列表
        const badges = await api.badges.getUserBadges();
        console.log('获取用户徽章响应:', badges);
        
        const normalized = (Array.isArray(badges) ? badges : []).map((b: any) => ({
          id: b.badgeId || b.id,
          badgeId: b.badgeId || b.id,
          name: b.name,
          description: b.description,
          icon: b.icon,
          level: b.level,
          category: b.category,
          dateEarned: b.dateEarned
        }));
        commit('SET_BADGES', normalized);
        
        return badges;
      } catch (error) {
        console.error('获取用户徽章失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '获取用户徽章失败');
        return [];
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 获取徽章完成度
    async getBadgeCompletion({ commit }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        // 获取徽章完成度
        const completion = await api.badges.getBadgeCompletion();
        
        // 更新状态
        commit('SET_BADGE_COMPLETION', completion);
        
        return completion;
      } catch (error) {
        console.error('获取徽章完成度失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '获取徽章完成度失败');
        return 0;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 登录功能
    async login({ commit }, { username, password }: { username: string, password: string }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        console.log('正在尝试登录...');
        const userInfo = await api.auth.login(username, password);
        console.log('登录成功:', userInfo);
        commit('LOGIN', userInfo);
        return userInfo;
      } catch (error) {
        console.error('登录失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '登录失败');
        uni.showToast({
          title: '登录失败，请检查用户名和密码',
          icon: 'none'
        });
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 注册功能
    async register({ commit }, { username, email, password, nickname }: { username: string, email: string, password: string, nickname?: string }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        console.log('正在尝试注册...');
        const userInfo = await api.auth.register(username, email, password, nickname);
        console.log('注册成功:', userInfo);
        commit('LOGIN', userInfo);
        return userInfo;
      } catch (error: any) {
        console.error('注册失败:', error);
        // 使用服务器返回的错误消息
        const errorMessage = error.message || '注册失败';
        commit('SET_ERROR', errorMessage);
        // 不在这里显示Toast，让UI组件决定如何显示错误
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 退出登录
    async logout({ commit }) {
      commit('SET_LOADING', true);
      
      try {
        await api.auth.logout();
        commit('LOGOUT');
        return true;
      } catch (error) {
        console.error('退出登录失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '退出登录失败');
        return false;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 检查登录状态
    async checkLoginStatus({ commit }) {
      try {
        const token = uni.getStorageSync('token');
        
        if (token) {
          // 获取用户信息
          const userInfo = await api.user.getUserInfo();
          commit('LOGIN', {
            ...userInfo,
            isLoggedIn: true
          });
          return true;
        } else {
          commit('LOGOUT');
          return false;
        }
      } catch (error) {
        console.error('检查登录状态失败:', error);
        uni.removeStorageSync('token');
        commit('LOGOUT');
        return false;
      }
    },
    
    // 获取收藏的单词
    async fetchFavorites({ commit }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        const response = await api.wordCards.getFavorites();
        console.log('getFavorites response:', response);
        
        // 健壮性处理
        let favorites: IWordCard[] = [];
        
        if (response && response.content && Array.isArray(response.content)) {
          favorites = response.content;
        } else if (response && Array.isArray(response)) {
          favorites = response;
        } else if (response) {
          // 尝试从其他可能的字段中提取数据
          favorites = response.records || response.data || response.favorites || [];
        }
        
        commit('SET_FAVORITES', favorites);
        return favorites;
      } catch (error) {
        console.error('获取收藏单词失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '获取收藏单词失败');
        return [];
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 更新用户信息（本地 + 可选同步服务端）
    updateUserInfo({ commit }, userInfo: Partial<IUserInfo>) {
      const patch = { ...userInfo };
      if (userInfo.avatar !== undefined) {
        patch.avatar = getUserAvatarUrl(userInfo.avatar);
      }
      commit('SET_USER_INFO', patch);
      return patch;
    },

    // 应用设置（每日目标、默认难度等）
    updateUserSetting({ commit }, { key, value }: { key: keyof IAppSettings; value: IAppSettings[keyof IAppSettings] }) {
      commit('SET_APP_SETTING', { key, value });
      return { key, value };
    },

    // 从服务端刷新用户信息（含头像）
    async fetchUserProfile({ commit, state }) {
      if (!state.userInfo.isLoggedIn) return null;
      try {
        const info = await api.user.getUserInfo();
        commit('SET_USER_INFO', info);
        return info;
      } catch (error) {
        console.error('刷新用户信息失败:', error);
        return null;
      }
    },

    // 上传头像
    async uploadAvatar({ commit }, filePath: string) {
      try {
        const result = await api.user.uploadAvatar(filePath);
        const avatarUrl = getUserAvatarUrl(result.avatar);
        commit('SET_USER_INFO', { avatar: avatarUrl });
        return { avatar: avatarUrl };
      } catch (error) {
        console.error('上传头像失败:', error);
        throw error;
      }
    },

    // 获取学习进度
    async fetchLearningProgress({ commit }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        console.log('获取学习进度...');
        const progress = await api.progress.getProgress();
        console.log('获取学习进度成功:', progress);
        commit('SET_USER_INFO', {
          learningStreak: progress.streak,
          lastStudyDate: progress.lastStudyDate,
          totalWords: progress.totalWords,
          totalTime: progress.totalTime,
          correctRate: progress.correctRate
        });
        return progress;
      } catch (error) {
        console.error('获取学习进度失败:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '获取学习进度失败');
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    }
  },
  getters: {
    isLoggedIn: state => state.userInfo.isLoggedIn,
    userInfo: state => state.userInfo,
    favoriteWords: state => state.vocabulary.favorites,
    learningStreak: state => state.learningProgress.streak,
    correctRate: state => state.learningProgress.correctRate,
    dailyStats: state => state.learningProgress.dailyStats,
    badges: state => state.achievements.badges,
    achievements: state => state.achievements.unlockedAchievements,
    categories: state => state.vocabulary.categories,
    isLoading: state => state.loading,
    error: state => state.error,
    userSettings: state => state.appSettings,
    dailyTarget: state => state.appSettings.dailyTarget,
    defaultDifficulty: state => state.appSettings.defaultDifficulty,
    userAvatarUrl: state => getUserAvatarUrl(state.userInfo.avatar)
  }
}); 