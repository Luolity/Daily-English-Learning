import type { IWordCard, IUserInfo, IProgressUpdate, IBadge } from '../store/types';
import axios from 'axios';
import { calcTotalPages, normalizeWordCardPage } from '../utils/pagination';
import { getUserAvatarUrl } from '../utils/avatar';

// 定义API响应类型
interface WordCardResponse {
  content?: IWordCard[];
  records?: IWordCard[];
  data?: IWordCard[];
  currentPage?: number;
  totalItems?: number;
  totalPages?: number;
  [key: string]: any; // 允许其他可能的字段
}

// API基础URL - 确保与后端URL匹配
export const API_HOST = 'http://localhost:8081';
const BASE_URL = `${API_HOST}/api`;

/** 将后端相对路径转为可访问的完整 URL */
export function resolveMediaUrl(path?: string): string {
  if (!path) return '/static/images/profile/default-avatar.svg';
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (path.startsWith('blob:') || path.startsWith('wxfile:') || path.startsWith('file:')) return path;
  if (path.startsWith('/static')) return path;
  if (path.startsWith('/uploads')) return `${API_HOST}${path}`;
  return path;
}

// 创建axios实例
const axiosInstance = axios.create({
  baseURL: BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  // 允许跨域请求携带Cookie
  withCredentials: true,
  timeout: 30000 // 30秒超时
});

// 请求拦截器 - 添加token
axiosInstance.interceptors.request.use(
  config => {
    const token = uni.getStorageSync('token');
    console.log('请求拦截器获取到的token:', token);
    
    if (token && config.headers) {
      config.headers['Authorization'] = `Bearer ${token}`;
      console.log('已添加Authorization请求头');
    } else if (!token) {
      console.warn('未找到token，请求可能会被拒绝');
    } else if (!config.headers) {
      console.warn('无法添加Authorization请求头，config.headers不存在');
    }
    
    console.log('发送请求:', {
      url: config.url,
      method: config.method,
      data: config.data,
      headers: config.headers
    });
    return config;
  },
  error => {
    console.error('请求错误:', error);
    return Promise.reject(error);
  }
);

// 响应拦截器 - 处理错误
axiosInstance.interceptors.response.use(
  response => {
    console.log('收到响应:', response);
    return response.data;
  },
  error => {
    console.error('响应错误:', error);
    // 从响应中提取错误信息
    if (error.response) {
      console.error('错误详情:', {
        status: error.response.status,
        data: error.response.data
      });
      
      // 如果响应中包含message字段，使用它作为错误消息
      if (error.response.data && error.response.data.message) {
        error.message = error.response.data.message;
      }
    }
    return Promise.reject(error);
  }
);

// HTTP请求方法
async function request<T>(url: string, options: any = {}): Promise<T> {
  try {
    const config = {
      method: options.method || 'GET',
      url,
      data: options.body ? JSON.parse(options.body) : undefined,
      params: options.params
    };
    
    return await axiosInstance.request(config);
  } catch (error) {
    console.error('API请求错误:', error);
    throw error;
  }
}

// API服务
export const api = {
  // 用户认证
  auth: {
    // 登录
    login: async (username: string, password: string) => {
      try {
        const data = await axiosInstance.post('/auth/signin', { username, password });
        const res = data as any;
        uni.setStorageSync('token', res.accessToken);
        return {
          id: res.id,
          nickname: res.nickname || res.username,
          avatar: getUserAvatarUrl(res.avatar),
          roles: res.roles || [],
          isLoggedIn: true
        };
      } catch (error) {
        console.error('登录失败:', error);
        throw error;
      }
    },
    
    // 注册
    register: async (username: string, email: string, password: string, nickname?: string) => {
      try {
        console.log('开始注册请求，参数:', { username, email, nickname: nickname || username });
        const response = await axiosInstance.post('/auth/signup', { 
          username, 
          email, 
          password, 
          nickname: nickname || username 
        });
        console.log('注册请求成功，响应:', response);
        
        // 注册成功后直接登录
        return api.auth.login(username, password);
      } catch (error: any) {
        console.error('注册失败，详细错误:', error);
        if (error.code === 'ECONNABORTED') {
          console.error('请求超时，请检查网络连接或服务器状态');
        }
        if (error.response) {
          console.error('服务器响应:', {
            status: error.response.status,
            data: error.response.data,
            headers: error.response.headers
          });
        } else if (error.request) {
          console.error('未收到响应，请求信息:', error.request);
        }
        // 确保错误对象包含来自服务器的错误消息
        if (error.response && error.response.data && error.response.data.message) {
          const errorWithMessage = new Error(error.response.data.message);
          throw errorWithMessage;
        }
        throw error;
      }
    },
    
    // 退出登录
    logout: async () => {
      // 清除本地token
      uni.removeStorageSync('token');
      return true;
    }
  },
  
  // 单词卡片
  wordCards: {
    // 获取单词总数（分页前先查总数，再计算总页数 = ceil(totalItems / pageSize)）
    getWordCardCount: async (
      category?: string,
      difficulty?: string,
      keyword?: string
    ): Promise<{ totalItems: number }> => {
      try {
        const params: Record<string, string> = {};
        if (category) params.category = category;
        if (difficulty) params.difficulty = difficulty;
        if (keyword) params.keyword = keyword;
        const response = await axiosInstance.get('/wordcards/count', { params });
        const data = response as { totalItems?: number };
        return { totalItems: data.totalItems ?? 0 };
      } catch (error) {
        console.error('获取单词总数失败:', error);
        throw error;
      }
    },

    // 获取单词列表
    getWordCards: async (
      page: number = 1,
      size: number = 10,
      category?: string,
      difficulty?: string,
      keyword?: string
    ): Promise<WordCardResponse> => {
      try {
        const params: any = { page, size };
        if (category) params.category = category;
        if (difficulty) params.difficulty = difficulty;
        if (keyword) params.keyword = keyword;
        
        console.log('请求参数:', params);
        const response = await axiosInstance.get('/wordcards', { params });
        console.log('API getWordCards 原始响应:', response);
        
        // 确保返回的数据结构符合前端的预期
        const data = response as unknown as WordCardResponse;
        
        // 如果响应已经包含content字段并且是数组，直接返回
        if (data.content && Array.isArray(data.content)) {
          const items = data.totalItems ?? data.total ?? 0;
          return normalizeWordCardPage(
            {
              content: data.content,
              currentPage: data.currentPage ?? data.current ?? page,
              totalItems: items,
              pageSize: data.pageSize ?? size
            },
            page,
            size
          );
        }
        
        // 如果响应本身就是数组，包装成预期的格式
        if (Array.isArray(data)) {
          return normalizeWordCardPage(
            { content: data, currentPage: page, totalItems: data.length },
            page,
            size
          );
        }
        
        // 尝试从其他可能的字段中提取数据
        const wordList = data.records || data.data || [];
        if (wordList && Array.isArray(wordList)) {
          const items = data.totalItems ?? data.total ?? 0;
          return normalizeWordCardPage(
            {
              content: wordList,
              currentPage: data.currentPage ?? data.current ?? page,
              totalItems: items,
              pageSize: data.pageSize ?? size
            },
            page,
            size
          );
        }
        
        // 最后的兜底，返回空数组
        return normalizeWordCardPage({ content: [], currentPage: page, totalItems: 0 }, page, size);
      } catch (error) {
        console.error('获取单词列表失败:', error);
        throw error;
      }
    },
    
    // 获取单个单词
    getWordCard: async (id: string) => {
      try {
        const response = await axiosInstance.get(`/wordcards/${id}`);
        return response.data;
      } catch (error) {
        console.error('获取单词详情失败:', error);
        throw error;
      }
    },
    
    // 获取单词（通过单词名）
    getWordCardByWord: async (word: string) => {
      try {
        const response = await axiosInstance.get(`/wordcards/word/${encodeURIComponent(word)}`);
        return response.data;
      } catch (error) {
        console.error('通过单词获取详情失败:', error);
        throw error;
      }
    },
    
    // 获取收藏的单词
    getFavorites: async (): Promise<WordCardResponse> => {
      try {
        const response = await axiosInstance.get('/wordcards/favorites');
        console.log('API getFavorites 原始响应:', response);
        
        // 确保返回的数据结构符合前端的预期
        const data = response as unknown as WordCardResponse;
        
        // 如果响应已经包含content字段并且是数组，直接返回
        if (data.content && Array.isArray(data.content)) {
          return data;
        }
        
        // 如果响应本身就是数组，包装成预期的格式
        if (Array.isArray(data)) {
          return { 
            content: data,
            currentPage: 0,
            totalItems: data.length,
            totalPages: 1
          };
        }
        
        // 尝试从其他可能的字段中提取数据
        const favorites = data.records || data.data || [];
        if (favorites) {
          return {
            content: favorites,
            currentPage: data.currentPage || 0,
            totalItems: data.totalItems || favorites.length,
            totalPages: data.totalPages || 1
          };
        }
        
        // 最后的兜底，返回空数组
        return { content: [] };
      } catch (error) {
        console.error('获取收藏单词失败:', error);
        throw error;
      }
    },
    
    // 添加到收藏
    addToFavorites: async (wordCardId: string) => {
      try {
        const response = await axiosInstance.post(`/wordcards/favorites/${wordCardId}`);
        return response.data;
      } catch (error) {
        console.error('添加到收藏失败:', error);
        throw error;
      }
    },
    
    // 从收藏中移除
    removeFromFavorites: async (wordCardId: string) => {
      try {
        const response = await axiosInstance.delete(`/wordcards/favorites/${wordCardId}`);
        return response.data;
      } catch (error) {
        console.error('从收藏中移除失败:', error);
        throw error;
      }
    },

    // 管理员：创建单词
    createWordCard: async (wordCard: Partial<IWordCard>) => {
      const payload = {
        word: wordCard.word,
        translation: wordCard.translation,
        phonetic: wordCard.phonetic || '',
        partOfSpeech: wordCard.partOfSpeech || '',
        definition: wordCard.definition || wordCard.translation || wordCard.word,
        example: wordCard.example || '',
        difficulty: wordCard.difficulty || 'easy',
        categories: wordCard.categories || []
      };
      return await axiosInstance.post('/wordcards', payload);
    },

    // 管理员：删除单词
    deleteWordCard: async (id: string | number) => {
      return await axiosInstance.delete(`/wordcards/${id}`);
    },

    // 管理员：更新单词
    updateWordCard: async (id: string | number, wordCard: Partial<IWordCard>) => {
      const payload = {
        word: wordCard.word,
        translation: wordCard.translation,
        phonetic: wordCard.phonetic || '',
        partOfSpeech: wordCard.partOfSpeech || '',
        definition: wordCard.definition || wordCard.translation || wordCard.word,
        example: wordCard.example || '',
        difficulty: wordCard.difficulty || 'easy',
        categories: wordCard.categories || []
      };
      return await axiosInstance.put(`/wordcards/${id}`, payload);
    }
  },
  
  // 学习进度
  progress: {
    // 获取学习进度
    getProgress: async () => {
      try {
        const response = await axiosInstance.get('/progress');
        return response.data;
      } catch (error) {
        console.error('获取学习进度失败:', error);
        throw error;
      }
    },

    // 获取学习汇总统计
    getStats: async () => {
      try {
        return await axiosInstance.get('/progress/stats');
      } catch (error) {
        console.error('获取学习统计失败:', error);
        throw error;
      }
    },
    
    // 更新学习进度
    updateProgress: async (progress: IProgressUpdate) => {
      try {
        const response = await axiosInstance.post('/progress', progress);
        return response.data;
      } catch (error) {
        console.error('更新学习进度失败:', error);
        throw error;
      }
    },
    
    // 获取每日学习统计
    getDailyStats: async (startDate?: string, endDate?: string) => {
      try {
        const params: any = {};
        if (startDate && endDate) {
          params.startDate = startDate;
          params.endDate = endDate;
        }
        
        const response = await axiosInstance.get('/progress/daily', { params });
        return response.data;
      } catch (error) {
        console.error('获取每日学习统计失败:', error);
        throw error;
      }
    }
  },
  
  // 徽章
  badges: {
    // 获取用户已获得的徽章
    getUserBadges: async () => {
      try {
        const response = await axiosInstance.get('/badges');
        return Array.isArray(response) ? response : [];
      } catch (error) {
        console.error('获取用户徽章失败:', error);
        throw error;
      }
    },

    // 检查并解锁符合条件的徽章
    checkAndAwardBadges: async () => {
      try {
        await axiosInstance.get('/badges/check');
      } catch (error) {
        console.error('检查徽章失败:', error);
        throw error;
      }
    },

    // 获取所有徽章（同 getUserBadges）
    getAllBadges: async () => {
      return api.badges.getUserBadges();
    },
    
    // 获取指定类别的徽章
    getBadgesByCategory: async (category: string) => {
      try {
        console.log(`开始获取${category}类别的徽章...`);
        const response = await axiosInstance.get(`/badges/category/${category}`);
        console.log(`获取${category}类别的徽章成功，响应:`, response.data);
        return response.data;
      } catch (error) {
        console.error(`获取${category}类别的徽章失败:`, error);
        throw error;
      }
    },
    
    // 获取特定徽章详情
    getUserBadgeById: async (badgeId: string) => {
      try {
        console.log(`开始请求徽章${badgeId}详情...`);
        const response = await axiosInstance.get(`/badges/${badgeId}`);
        console.log(`获取徽章${badgeId}详情成功，响应:`, response);
        return response.data;
      } catch (error) {
        console.error(`获取徽章${badgeId}详情失败:`, error);
        throw error;
      }
    },
    
    // 获取徽章完成度
    getBadgeCompletion: async () => {
      try {
        console.log('开始获取徽章完成度...');
        const response = await axiosInstance.get('/badges/completion');
        console.log('获取徽章完成度成功，响应:', response);
        // 响应是一个对象，包含message字段
        if (typeof response === 'object' && response !== null && 'message' in response) {
          return parseInt(response.message as string || '0', 10);
        }
        return 0;
      } catch (error) {
        console.error('获取徽章完成度失败:', error);
        throw error;
      }
    }
  },

  // 挑战
  challenge: {
    submitRecord: async (record: any) => {
      try {
        const response = await axiosInstance.post('/challenge/submit', record);
        return response;
      } catch (error) {
        console.error('提交挑战记录失败:', error);
        throw error;
      }
    },
    getLeaderboard: async (limit: number = 10) => {
      try {
        const response = await axiosInstance.get('/challenge/leaderboard', { params: { limit } });
        return response;
      } catch (error) {
        console.error('获取排行榜失败:', error);
        throw error;
      }
    },
    getHistory: async () => {
      try {
        const response = await axiosInstance.get('/challenge/history');
        return response;
      } catch (error) {
        console.error('获取挑战历史失败:', error);
        throw error;
      }
    }
  },
  
  // 用户信息
  wrongWords: {
    getWrongWords: async (): Promise<IWordCard[]> => {
      return await axiosInstance.get('/wrong-words');
    },
    removeWrongWord: async (wordId: string | number) => {
      return await axiosInstance.delete(`/wrong-words/${wordId}`);
    }
  },

  user: {
    // 获取用户信息
    getUserInfo: async () => {
      try {
        const response = await axiosInstance.get('/users/profile');
        const data = (response as any)?.data ?? response;
        return {
          id: data.id,
          nickname: data.nickname || data.username,
          avatar: getUserAvatarUrl(data.avatar),
          roles: data.roles || [],
          isLoggedIn: true
        };
      } catch (error) {
        console.error('获取用户信息失败:', error);
        throw error;
      }
    },
    
    // 更新用户信息
    updateUserInfo: async (userInfo: Partial<IUserInfo>) => {
      try {
        const response = await axiosInstance.put('/users/profile', userInfo);
        const data = (response as any)?.data ?? response;
        return data;
      } catch (error) {
        console.error('更新用户信息失败:', error);
        throw error;
      }
    },
    
    // 上传头像（uni-app 使用 uploadFile）
    uploadAvatar: (filePath: string): Promise<{ avatar: string }> => {
      return new Promise((resolve, reject) => {
        const token = uni.getStorageSync('token');
        uni.uploadFile({
          url: `${BASE_URL}/users/avatar`,
          filePath,
          name: 'file',
          header: token ? { Authorization: `Bearer ${token}` } : {},
          success: (res) => {
            try {
              if (res.statusCode && res.statusCode >= 400) {
                reject(new Error('上传失败'));
                return;
              }
              const data = typeof res.data === 'string' ? JSON.parse(res.data) : res.data;
              resolve({ avatar: resolveMediaUrl(data.avatar) });
            } catch (e) {
              reject(e);
            }
          },
          fail: (err) => reject(err)
        });
      });
    }
  }
};

export default api;
