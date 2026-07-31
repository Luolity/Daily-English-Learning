import type { IWordCard, IUserInfo, IProgressUpdate, IBadge } from '../store/types';
import axios from 'axios';
import { calcTotalPages, normalizeWordCardPage } from '../utils/pagination';
import { getUserAvatarUrl } from '../utils/avatar';

// 瀹氫箟API鍝嶅簲绫诲瀷
interface WordCardResponse {
  content?: IWordCard[];
  records?: IWordCard[];
  data?: IWordCard[];
  currentPage?: number;
  totalItems?: number;
  totalPages?: number;
  [key: string]: any; // 鍏佽鍏朵粬鍙兘鐨勫瓧娈?
}

// API基础URL - 确保与后端URL匹配
export const API_HOST = 'http://localhost:8081';
const BASE_URL = `${API_HOST}/api`;

/** 灏嗗悗绔浉瀵硅矾寰勮浆涓哄彲璁块棶鐨勫畬鏁? URL */
export function resolveMediaUrl(path?: string): string {
  if (!path) return '/static/images/profile/default-avatar.svg';
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (path.startsWith('blob:') || path.startsWith('wxfile:') || path.startsWith('file:')) return path;
  if (path.startsWith('/static')) return path;
  if (path.startsWith('/uploads')) return `${API_HOST}${path}`;
  return path;
}

// 鍒涘缓axios瀹炰緥
const axiosInstance = axios.create({
  baseURL: BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  // 允许跨域请求携带Cookie
  withCredentials: true,
  timeout: 30000 // 30绉掕秴鏃?
});

// 璇锋眰鎷︽埅鍣? - 娣诲姞token
axiosInstance.interceptors.request.use(
  config => {
    const token = uni.getStorageSync('token');
    console.log('璇锋眰鎷︽埅鍣ㄨ幏鍙栧埌鐨則oken:', token);
    
    if (token && config.headers) {
      config.headers['Authorization'] = `Bearer ${token}`;
      console.log('宸叉坊鍔燗uthorization璇锋眰澶?');
    } else if (!token) {
      console.warn('鏈壘鍒皌oken锛岃姹傚彲鑳戒細琚嫆缁?');
    } else if (!config.headers) {
      console.warn('鏃犳硶娣诲姞Authorization璇锋眰澶达紝config.headers涓嶅瓨鍦?');
    }
    
    console.log('鍙戦€佽姹?:', {
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

// 鍝嶅簲鎷︽埅鍣? - 澶勭悊閿欒
axiosInstance.interceptors.response.use(
  response => {
    console.log('鏀跺埌鍝嶅簲:', response);
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

// HTTP璇锋眰鏂规硶
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

// API鏈嶅姟
export const api = {
  // 鐢ㄦ埛璁よ瘉
  auth: {
    // 鐧诲綍
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
        console.error('鐧诲綍澶辫触:', error);
        throw error;
      }
    },
    
    // 娉ㄥ唽
    register: async (username: string, email: string, password: string, nickname?: string) => {
      try {
        console.log('开始注册请求，参数:', { username, email, nickname: nickname || username });
        const response = await axiosInstance.post('/auth/signup', { 
          username, 
          email, 
          password, 
          nickname: nickname || username 
        });
        console.log('娉ㄥ唽璇锋眰鎴愬姛锛屽搷搴?:', response);
        
        // 娉ㄥ唽鎴愬姛鍚庣洿鎺ョ櫥褰?
        return api.auth.login(username, password);
      } catch (error: any) {
        console.error('娉ㄥ唽澶辫触锛岃缁嗛敊璇?:', error);
        if (error.code === 'ECONNABORTED') {
          console.error('璇锋眰瓒呮椂锛岃妫€鏌ョ綉缁滆繛鎺ユ垨鏈嶅姟鍣ㄧ姸鎬?');
        }
        if (error.response) {
          console.error('鏈嶅姟鍣ㄥ搷搴?:', {
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
    
    // 閫€鍑虹櫥褰?
    logout: async () => {
      // 清除本地token
      uni.removeStorageSync('token');
      return true;
    }
  },
  
  // 鍗曡瘝鍗＄墖
  wordCards: {
    // 鑾峰彇鍗曡瘝鎬绘暟锛堝垎椤靛墠鍏堟煡鎬绘暟锛屽啀璁＄畻鎬婚〉鏁? = ceil(totalItems / pageSize)锛?
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
        console.error('鑾峰彇鍗曡瘝鎬绘暟澶辫触:', error);
        throw error;
      }
    },

    // 鑾峰彇鍗曡瘝鍒楄〃
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
        
        console.log('璇锋眰鍙傛暟:', params);
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
        
        // 濡傛灉鍝嶅簲鏈韩灏辨槸鏁扮粍锛屽寘瑁呮垚棰勬湡鐨勬牸寮?
        if (Array.isArray(data)) {
          return normalizeWordCardPage(
            { content: data, currentPage: page, totalItems: data.length },
            page,
            size
          );
        }
        
        // 灏濊瘯浠庡叾浠栧彲鑳界殑瀛楁涓彁鍙栨暟鎹?
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
        
        // 鏈€鍚庣殑鍏滃簳锛岃繑鍥炵┖鏁扮粍
        return normalizeWordCardPage({ content: [], currentPage: page, totalItems: 0 }, page, size);
      } catch (error) {
        console.error('鑾峰彇鍗曡瘝鍒楄〃澶辫触:', error);
        throw error;
      }
    },
    
    // 鑾峰彇鍗曚釜鍗曡瘝
    getWordCard: async (id: string) => {
      try {
        const response = await axiosInstance.get(`/wordcards/${id}`);
        return response.data;
      } catch (error) {
        console.error('鑾峰彇鍗曡瘝璇︽儏澶辫触:', error);
        throw error;
      }
    },
    
    // 鑾峰彇鍗曡瘝锛堥€氳繃鍗曡瘝鍚嶏級
    getWordCardByWord: async (word: string) => {
      try {
        const response = await axiosInstance.get(`/wordcards/word/${encodeURIComponent(word)}`);
        return response.data;
      } catch (error) {
        console.error('閫氳繃鍗曡瘝鑾峰彇璇︽儏澶辫触:', error);
        throw error;
      }
    },
    
    // 鑾峰彇鏀惰棌鐨勫崟璇?
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
        
        // 濡傛灉鍝嶅簲鏈韩灏辨槸鏁扮粍锛屽寘瑁呮垚棰勬湡鐨勬牸寮?
        if (Array.isArray(data)) {
          return { 
            content: data,
            currentPage: 0,
            totalItems: data.length,
            totalPages: 1
          };
        }
        
        // 灏濊瘯浠庡叾浠栧彲鑳界殑瀛楁涓彁鍙栨暟鎹?
        const favorites = data.records || data.data || [];
        if (favorites) {
          return {
            content: favorites,
            currentPage: data.currentPage || 0,
            totalItems: data.totalItems || favorites.length,
            totalPages: data.totalPages || 1
          };
        }
        
        // 鏈€鍚庣殑鍏滃簳锛岃繑鍥炵┖鏁扮粍
        return { content: [] };
      } catch (error) {
        console.error('鑾峰彇鏀惰棌鍗曡瘝澶辫触:', error);
        throw error;
      }
    },
    
    // 娣诲姞鍒版敹钘?
    addToFavorites: async (wordCardId: string) => {
      try {
        const response = await axiosInstance.post(`/wordcards/favorites/${wordCardId}`);
        return response.data;
      } catch (error) {
        console.error('娣诲姞鍒版敹钘忓け璐?:', error);
        throw error;
      }
    },
    
    // 浠庢敹钘忎腑绉婚櫎
    removeFromFavorites: async (wordCardId: string) => {
      try {
        const response = await axiosInstance.delete(`/wordcards/favorites/${wordCardId}`);
        return response.data;
      } catch (error) {
        console.error('浠庢敹钘忎腑绉婚櫎澶辫触:', error);
        throw error;
      }
    },

    // 绠＄悊鍛橈細鍒涘缓鍗曡瘝
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

    // 绠＄悊鍛橈細鍒犻櫎鍗曡瘝
    deleteWordCard: async (id: string | number) => {
      return await axiosInstance.delete(`/wordcards/${id}`);
    },

    // 绠＄悊鍛橈細鏇存柊鍗曡瘝
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
  
  // 瀛︿範杩涘害
  progress: {
    // 鑾峰彇瀛︿範杩涘害
    getProgress: async () => {
      try {
        const response = await axiosInstance.get('/progress');
        return response.data;
      } catch (error) {
        console.error('鑾峰彇瀛︿範杩涘害澶辫触:', error);
        throw error;
      }
    },

    // 鑾峰彇瀛︿範姹囨€荤粺璁?
    getStats: async () => {
      try {
        return await axiosInstance.get('/progress/stats');
      } catch (error) {
        console.error('获取学习统计失败:', error);
        throw error;
      }
    },
    
    // 鏇存柊瀛︿範杩涘害
    updateProgress: async (progress: IProgressUpdate) => {
      try {
        const response = await axiosInstance.post('/progress', progress);
        return response.data;
      } catch (error) {
        console.error('鏇存柊瀛︿範杩涘害澶辫触:', error);
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
  
  // 寰界珷
  badges: {
    // 鑾峰彇鐢ㄦ埛宸茶幏寰楃殑寰界珷
    getUserBadges: async () => {
      try {
        const response = await axiosInstance.get('/badges');
        return Array.isArray(response) ? response : [];
      } catch (error) {
        console.error('鑾峰彇鐢ㄦ埛寰界珷澶辫触:', error);
        throw error;
      }
    },

    // 妫€鏌ュ苟瑙ｉ攣绗﹀悎鏉′欢鐨勫窘绔?
    checkAndAwardBadges: async () => {
      try {
        await axiosInstance.get('/badges/check');
      } catch (error) {
        console.error('妫€鏌ュ窘绔犲け璐?:', error);
        throw error;
      }
    },

    // 鑾峰彇鎵€鏈夊窘绔狅紙鍚? getUserBadges锛?
    getAllBadges: async () => {
      return api.badges.getUserBadges();
    },
    
    // 鑾峰彇鎸囧畾绫诲埆鐨勫窘绔?
    getBadgesByCategory: async (category: string) => {
      try {
        console.log(`寮€濮嬭幏鍙?${category}绫诲埆鐨勫窘绔?...`);
        const response = await axiosInstance.get(`/badges/category/${category}`);
        console.log(`鑾峰彇${category}绫诲埆鐨勫窘绔犳垚鍔燂紝鍝嶅簲:`, response.data);
        return response.data;
      } catch (error) {
        console.error(`鑾峰彇${category}绫诲埆鐨勫窘绔犲け璐?:`, error);
        throw error;
      }
    },
    
    // 鑾峰彇鐗瑰畾寰界珷璇︽儏
    getUserBadgeById: async (badgeId: string) => {
      try {
        console.log(`寮€濮嬭姹傚窘绔?${badgeId}璇︽儏...`);
        const response = await axiosInstance.get(`/badges/${badgeId}`);
        console.log(`鑾峰彇寰界珷${badgeId}璇︽儏鎴愬姛锛屽搷搴?:`, response);
        return response.data;
      } catch (error) {
        console.error(`鑾峰彇寰界珷${badgeId}璇︽儏澶辫触:`, error);
        throw error;
      }
    },
    
    // 鑾峰彇寰界珷瀹屾垚搴?
    getBadgeCompletion: async () => {
      try {
        console.log('寮€濮嬭幏鍙栧窘绔犲畬鎴愬害...');
        const response = await axiosInstance.get('/badges/completion');
        console.log('鑾峰彇寰界珷瀹屾垚搴︽垚鍔燂紝鍝嶅簲:', response);
        // 响应是一个对象，包含message字段
        if (typeof response === 'object' && response !== null && 'message' in response) {
          return parseInt(response.message as string || '0', 10);
        }
        return 0;
      } catch (error) {
        console.error('鑾峰彇寰界珷瀹屾垚搴﹀け璐?:', error);
        throw error;
      }
    }
  },

  // 鎸戞垬
  challenge: {
    submitRecord: async (record: any) => {
      try {
        const response = await axiosInstance.post('/challenge/submit', record);
        return response;
      } catch (error) {
        console.error('鎻愪氦鎸戞垬璁板綍澶辫触:', error);
        throw error;
      }
    },
    getLeaderboard: async (limit: number = 10) => {
      try {
        const response = await axiosInstance.get('/challenge/leaderboard', { params: { limit } });
        return response;
      } catch (error) {
        console.error('鑾峰彇鎺掕姒滃け璐?:', error);
        throw error;
      }
    },
    getHistory: async () => {
      try {
        const response = await axiosInstance.get('/challenge/history');
        return response;
      } catch (error) {
        console.error('鑾峰彇鎸戞垬鍘嗗彶澶辫触:', error);
        throw error;
      }
    }
  },
  
  // 鐢ㄦ埛淇℃伅
  user: {
    // 鑾峰彇鐢ㄦ埛淇℃伅
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
        console.error('鑾峰彇鐢ㄦ埛淇℃伅澶辫触:', error);
        throw error;
      }
    },
    
    // 鏇存柊鐢ㄦ埛淇℃伅
    updateUserInfo: async (userInfo: Partial<IUserInfo>) => {
      try {
        const response = await axiosInstance.put('/users/profile', userInfo);
        const data = (response as any)?.data ?? response;
        return data;
      } catch (error) {
        console.error('鏇存柊鐢ㄦ埛淇℃伅澶辫触:', error);
        throw error;
      }
    },
    
    // 涓婁紶澶村儚锛坲ni-app 浣跨敤 uploadFile锛?
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
                reject(new Error('涓婁紶澶辫触'));
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
