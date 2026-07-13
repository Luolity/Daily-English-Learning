// 单词卡片接口
export type IWordCard = {
  id: string;
  word: string;
  translation: string;
  phonetic: string;
  partOfSpeech: string;
  definition: string;
  example: string;
  difficulty: 'easy' | 'medium' | 'hard';
  categories: string[];
}

// 词汇库接口
export type IVocabulary = {
  wordList: IWordCard[];
  favorites: IWordCard[];
  categories: string[];
}

// 学习进度接口
export type ILearningProgress = {
  date: string;
  wordsLearned: number;
  timeSpent: number;
  correctCount: number;
  totalCount: number;
}

// 徽章接口
export type IBadge = {
  id: string;
  name: string;
  description: string;
  icon: string;
}

// 成就接口
export type IAchievement = {
  id: string;
  name: string;
  description: string;
  icon: string;
  unlockDate: string;
}

// 听力资源接口
export type IAudio = {
  id: string;
  title: string;
  category: string;
  duration: number;
  url: string;
  transcript: string;
}

// 听力历史记录接口
export type IListeningHistory = {
  id: string;
  audioId: string;
  date: string;
  duration: number;
  completionRate: number;
  score?: number;
}

// 学习进度更新参数接口
export type IProgressUpdate = {
  wordsLearned?: number;
  timeSpent?: number;
  correctCount?: number;
  totalCount?: number;
}

// 用户信息接口
export type IUserInfo = {
  id: string;
  nickname: string;
  avatar: string;
  isLoggedIn: boolean;
  roles?: string[];
}

// 应用设置
export type IAppSettings = {
  theme: 'light' | 'dark' | 'system';
  soundEnabled: boolean;
  notificationEnabled: boolean;
  dailyTarget: number;
  defaultDifficulty: 'easy' | 'medium' | 'hard';
} 