import { createStore } from 'vuex'
import createPersistedState from 'vuex-persistedstate'
import type { IWordCard, IVocabulary, ILearningProgress, IBadge, IAchievement, IProgressUpdate, IUserInfo, IAppSettings } from './types'
import { getUserAvatarUrl } from '../utils/avatar'
import { api } from '../services/api'
import { calcTotalPages } from '../utils/pagination'

// 瀵煎叆API鍝嶅簲绫诲瀷
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
    // 鐢ㄦ埛淇℃伅
    userInfo: {
      id: '',
      nickname: '',
      avatar: '',
      roles: [],
      isLoggedIn: false
    } as IUserInfo,
    // 鍗曡瘝瀛︿範
    vocabulary: {
      wordList: [] as IWordCard[],
      favorites: [] as IWordCard[],
      categories: ['CET4', 'CET6', 'TOEFL', 'IELTS', 'GRE']
    } as IVocabulary,
    // 瀛︿範杩涘害
    learningProgress: {
      streak: 0, // 杩炵画瀛︿範澶╂暟
      lastStudyDate: '', // 上次学习日期
      totalWords: 0, // 已学单词总数
      totalTime: 0, // 鎬诲涔犳椂闂达紙鍒嗛挓锛?
      dailyStats: [] as ILearningProgress[], // 每日学习统计
      correctRate: 0 // 姝ｇ‘鐜?
    },
    // 鎴愬氨绯荤粺
    achievements: {
      badges: [] as IBadge[], // 宸茶幏寰楀窘绔?
      unlockedAchievements: [] as IAchievement[], // 宸茶В閿佹垚灏?
      badgeCompletion: 0 // 寰界珷瀹屾垚搴?
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
    // 鐢ㄦ埛鐩稿叧
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
    
    // 鍗曡瘝鐩稿叧
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
    
    // 瀛︿範杩涘害鐩稿叧
    UPDATE_LEARNING_PROGRESS(state, progress: IProgressUpdate) {
      const today = new Date().toISOString().split('T')[0];
      
      // 鏇存柊杩炵画瀛︿範澶╂暟
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
      
      // 鏇存柊姝ｇ‘鐜?
      if (progress.totalCount && progress.totalCount > 0) {
        const totalCorrect = state.learningProgress.dailyStats.reduce((sum, item) => sum + item.correctCount, 0);
        const totalQuestions = state.learningProgress.dailyStats.reduce((sum, item) => sum + item.totalCount, 0);
        state.learningProgress.correctRate = totalCorrect / totalQuestions;
      }
    },
    
    // 鎴愬氨鐩稿叧
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
    // 鑾峰彇鍗曡瘝鍒楄〃
    async fetchWordList({ commit }, { category, difficulty, keyword, page = 1, size = 10 }: { category?: string, difficulty?: string, keyword?: string, page?: number, size?: number }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        const response = await api.wordCards.getWordCards(page, size, category, difficulty, keyword);
        console.log('getWordCards response:', response);
        
        // 鍋ュ．鎬у垽鏂?
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
          console.error('鑾峰彇鍗曡瘝鍒楄〃澶辫触锛岃繑鍥炲唴瀹瑰紓甯?:', response);
          return {
            content: [],
            currentPage: page,
            pageSize: size,
            totalItems: 0,
            totalPages: 0
          };
        }
      } catch (error) {
        console.error('鑾峰彇鍗曡瘝鍒楄〃澶辫触:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '鑾峰彇鍗曡瘝鍒楄〃澶辫触');
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 娣诲姞鍒扮敓璇嶆湰
    async addToFavorites({ commit }, word: IWordCard) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        await api.wordCards.addToFavorites(word.id);
        commit('ADD_TO_FAVORITES', word);
        uni.showToast({
          title: '宸叉坊鍔犲埌鐢熻瘝鏈?',
          icon: 'success'
        });
        return true;
      } catch (error) {
        console.error('娣诲姞鍒扮敓璇嶆湰澶辫触:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '娣诲姞鍒扮敓璇嶆湰澶辫触');
        uni.showToast({
          title: '娣诲姞澶辫触',
          icon: 'error'
        });
        return false;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 浠庣敓璇嶆湰绉婚櫎
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
        console.error('浠庣敓璇嶆湰绉婚櫎澶辫触:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '浠庣敓璇嶆湰绉婚櫎澶辫触');
        uni.showToast({
          title: '绉婚櫎澶辫触',
          icon: 'error'
        });
        return false;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 鏇存柊瀛︿範杩涘害
    async updateProgress({ commit, dispatch, state }, progress: IProgressUpdate) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        commit('UPDATE_LEARNING_PROGRESS', progress);
        await api.progress.updateProgress(progress);
        await dispatch('checkAndAwardBadges');
        return state.learningProgress;
      } catch (error) {
        console.error('鏇存柊瀛︿範杩涘害澶辫触:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '鏇存柊瀛︿範杩涘害澶辫触');
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },

    // 妫€鏌ュ苟鍒锋柊寰界珷
    async checkAndAwardBadges({ dispatch }) {
      try {
        await api.badges.checkAndAwardBadges();
        await dispatch('fetchBadges');
        await dispatch('getBadgeCompletion');
        return true;
      } catch (error) {
        console.error('妫€鏌ュ窘绔犺В閿佸け璐?:', error);
        return false;
      }
    },
    
    // 鑾峰彇鐢ㄦ埛寰界珷
    async fetchBadges({ commit }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        console.log('寮€濮嬭幏鍙栫敤鎴峰窘绔?...');
        // 鑾峰彇鐢ㄦ埛寰界珷鍒楄〃
        const badges = await api.badges.getUserBadges();
        console.log('鑾峰彇鐢ㄦ埛寰界珷鍝嶅簲:', badges);
        
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
        console.error('鑾峰彇鐢ㄦ埛寰界珷澶辫触:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '鑾峰彇鐢ㄦ埛寰界珷澶辫触');
        return [];
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 鑾峰彇寰界珷瀹屾垚搴?
    async getBadgeCompletion({ commit }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        // 鑾峰彇寰界珷瀹屾垚搴?
        const completion = await api.badges.getBadgeCompletion();
        
        // 鏇存柊鐘舵€?
        commit('SET_BADGE_COMPLETION', completion);
        
        return completion;
      } catch (error) {
        console.error('鑾峰彇寰界珷瀹屾垚搴﹀け璐?:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '鑾峰彇寰界珷瀹屾垚搴﹀け璐?');
        return 0;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 鐧诲綍鍔熻兘
    async login({ commit }, { username, password }: { username: string, password: string }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        console.log('姝ｅ湪灏濊瘯鐧诲綍...');
        const userInfo = await api.auth.login(username, password);
        console.log('鐧诲綍鎴愬姛:', userInfo);
        commit('LOGIN', userInfo);
        return userInfo;
      } catch (error) {
        console.error('鐧诲綍澶辫触:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '鐧诲綍澶辫触');
        uni.showToast({
          title: '鐧诲綍澶辫触锛岃妫€鏌ョ敤鎴峰悕鍜屽瘑鐮?',
          icon: 'none'
        });
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 娉ㄥ唽鍔熻兘
    async register({ commit }, { username, email, password, nickname }: { username: string, email: string, password: string, nickname?: string }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        console.log('姝ｅ湪灏濊瘯娉ㄥ唽...');
        const userInfo = await api.auth.register(username, email, password, nickname);
        console.log('娉ㄥ唽鎴愬姛:', userInfo);
        commit('LOGIN', userInfo);
        return userInfo;
      } catch (error: any) {
        console.error('娉ㄥ唽澶辫触:', error);
        // 使用服务器返回的错误消息
        const errorMessage = error.message || '娉ㄥ唽澶辫触';
        commit('SET_ERROR', errorMessage);
        // 不在这里显示Toast，让UI组件决定如何显示错误
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 閫€鍑虹櫥褰?
    async logout({ commit }) {
      commit('SET_LOADING', true);
      
      try {
        await api.auth.logout();
        commit('LOGOUT');
        return true;
      } catch (error) {
        console.error('閫€鍑虹櫥褰曞け璐?:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '閫€鍑虹櫥褰曞け璐?');
        return false;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 妫€鏌ョ櫥褰曠姸鎬?
    async checkLoginStatus({ commit }) {
      try {
        const token = uni.getStorageSync('token');
        
        if (token) {
          // 鑾峰彇鐢ㄦ埛淇℃伅
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
        console.error('妫€鏌ョ櫥褰曠姸鎬佸け璐?:', error);
        uni.removeStorageSync('token');
        commit('LOGOUT');
        return false;
      }
    },
    
    // 鑾峰彇鏀惰棌鐨勫崟璇?
    async fetchFavorites({ commit }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        const response = await api.wordCards.getFavorites();
        console.log('getFavorites response:', response);
        
        // 鍋ュ．鎬у鐞?
        let favorites: IWordCard[] = [];
        
        if (response && response.content && Array.isArray(response.content)) {
          favorites = response.content;
        } else if (response && Array.isArray(response)) {
          favorites = response;
        } else if (response) {
          // 灏濊瘯浠庡叾浠栧彲鑳界殑瀛楁涓彁鍙栨暟鎹?
          favorites = response.records || response.data || response.favorites || [];
        }
        
        commit('SET_FAVORITES', favorites);
        return favorites;
      } catch (error) {
        console.error('鑾峰彇鏀惰棌鍗曡瘝澶辫触:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '鑾峰彇鏀惰棌鍗曡瘝澶辫触');
        return [];
      } finally {
        commit('SET_LOADING', false);
      }
    },
    
    // 鏇存柊鐢ㄦ埛淇℃伅锛堟湰鍦? + 鍙€夊悓姝ユ湇鍔＄锛?
    updateUserInfo({ commit }, userInfo: Partial<IUserInfo>) {
      const patch = { ...userInfo };
      if (userInfo.avatar !== undefined) {
        patch.avatar = getUserAvatarUrl(userInfo.avatar);
      }
      commit('SET_USER_INFO', patch);
      return patch;
    },

    // 搴旂敤璁剧疆锛堟瘡鏃ョ洰鏍囥€侀粯璁ら毦搴︾瓑锛?
    updateUserSetting({ commit }, { key, value }: { key: keyof IAppSettings; value: IAppSettings[keyof IAppSettings] }) {
      commit('SET_APP_SETTING', { key, value });
      return { key, value };
    },

    // 浠庢湇鍔＄鍒锋柊鐢ㄦ埛淇℃伅锛堝惈澶村儚锛?
    async fetchUserProfile({ commit, state }) {
      if (!state.userInfo.isLoggedIn) return null;
      try {
        const info = await api.user.getUserInfo();
        commit('SET_USER_INFO', info);
        return info;
      } catch (error) {
        console.error('鍒锋柊鐢ㄦ埛淇℃伅澶辫触:', error);
        return null;
      }
    },

    // 涓婁紶澶村儚
    async uploadAvatar({ commit }, filePath: string) {
      try {
        const result = await api.user.uploadAvatar(filePath);
        const avatarUrl = getUserAvatarUrl(result.avatar);
        commit('SET_USER_INFO', { avatar: avatarUrl });
        return { avatar: avatarUrl };
      } catch (error) {
        console.error('涓婁紶澶村儚澶辫触:', error);
        throw error;
      }
    },

    // 鑾峰彇瀛︿範杩涘害
    async fetchLearningProgress({ commit }) {
      commit('SET_LOADING', true);
      commit('SET_ERROR', null);
      
      try {
        console.log('鑾峰彇瀛︿範杩涘害...');
        const progress = await api.progress.getProgress();
        console.log('鑾峰彇瀛︿範杩涘害鎴愬姛:', progress);
        commit('SET_USER_INFO', {
          learningStreak: progress.streak,
          lastStudyDate: progress.lastStudyDate,
          totalWords: progress.totalWords,
          totalTime: progress.totalTime,
          correctRate: progress.correctRate
        });
        return progress;
      } catch (error) {
        console.error('鑾峰彇瀛︿範杩涘害澶辫触:', error);
        commit('SET_ERROR', error instanceof Error ? error.message : '鑾峰彇瀛︿範杩涘害澶辫触');
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
