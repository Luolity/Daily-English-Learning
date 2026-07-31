import { Store } from 'vuex';

// 徽章定义接口
export interface IBadge {
  id: string;
  name: string;
  description: string;
  icon: string;
  condition: (store: Store<any>) => boolean;
  level?: 'bronze' | 'silver' | 'gold' | 'platinum';
  category: 'streak' | 'vocabulary' | 'listening' | 'challenge' | 'special';
  dateEarned?: string;
}

// 徽章列表
const badges: IBadge[] = [
  // 连续学习徽章
  {
    id: 'streak_3',
    name: '初学乍练',
    description: '连续学习3天',
    icon: 'streak-3',
    level: 'bronze',
    category: 'streak',
    condition: (store) => store.getters.learningStreak >= 3
  },
  {
    id: 'streak_7',
    name: '坚持不懈',
    description: '连续学习7天',
    icon: 'streak-7',
    level: 'silver',
    category: 'streak',
    condition: (store) => store.getters.learningStreak >= 7
  },
  {
    id: 'streak_30',
    name: '学习达人',
    description: '连续学习30天',
    icon: 'streak-30',
    level: 'gold',
    category: 'streak',
    condition: (store) => store.getters.learningStreak >= 30
  },
  {
    id: 'streak_100',
    name: '英语大师',
    description: '连续学习100天',
    icon: 'streak-100',
    level: 'platinum',
    category: 'streak',
    condition: (store) => store.getters.learningStreak >= 100
  },
  
  // 单词学习徽章
  {
    id: 'vocabulary_50',
    name: '词汇新手',
    description: '学习50个单词',
    icon: 'vocab-50',
    level: 'bronze',
    category: 'vocabulary',
    condition: (store) => {
      const totalLearned = store.state.learningProgress.dailyStats.reduce(
        (sum: number, day: any) => sum + day.wordsLearned, 0
      );
      return totalLearned >= 50;
    }
  },
  {
    id: 'vocabulary_200',
    name: '词汇收藏家',
    description: '学习200个单词',
    icon: 'vocab-200',
    level: 'silver',
    category: 'vocabulary',
    condition: (store) => {
      const totalLearned = store.state.learningProgress.dailyStats.reduce(
        (sum: number, day: any) => sum + day.wordsLearned, 0
      );
      return totalLearned >= 200;
    }
  },
  {
    id: 'vocabulary_500',
    name: '词汇大师',
    description: '学习500个单词',
    icon: 'vocab-500',
    level: 'gold',
    category: 'vocabulary',
    condition: (store) => {
      const totalLearned = store.state.learningProgress.dailyStats.reduce(
        (sum: number, day: any) => sum + day.wordsLearned, 0
      );
      return totalLearned >= 500;
    }
  },
  
  // 挑战徽章
  {
    id: 'challenge_perfect',
    name: '完美挑战',
    description: '在挑战中获得100%正确率',
    icon: 'challenge-perfect',
    level: 'gold',
    category: 'challenge',
    condition: (store) => {
      const challenges = store.state.learningProgress.challenges || [];
      return challenges.some((c: any) => 
        c.correctCount === c.totalCount && c.totalCount >= 10
      );
    }
  },
  {
    id: 'challenge_master',
    name: '挑战大师',
    description: '完成10次挑战',
    icon: 'challenge-master',
    level: 'silver',
    category: 'challenge',
    condition: (store) => {
      const challenges = store.state.learningProgress.challenges || [];
      return challenges.length >= 10;
    }
  },
  
  // 特殊徽章
  {
    id: 'special_first_day',
    name: '初来乍到',
    description: '完成第一天的学习',
    icon: 'special-first',
    level: 'bronze',
    category: 'special',
    condition: (store) => store.state.learningProgress.dailyStats.length > 0
  },
  {
    id: 'special_all_targets',
    name: '目标达人',
    description: '连续7天达成每日学习目标',
    icon: 'special-target',
    level: 'gold',
    category: 'special',
    condition: (store) => {
      const stats = store.state.learningProgress.dailyStats;
      if (stats.length < 7) return false;
      
      // 获取最近7天的记录
      const recent = [...stats].sort((a: any, b: any) => 
        new Date(b.date).getTime() - new Date(a.date).getTime()
      ).slice(0, 7);
      
      if (recent.length < 7) return false;
      
      // 检查是否连续7天
      const today = new Date();
      for (let i = 0; i < 7; i++) {
        const targetDate = new Date();
        targetDate.setDate(today.getDate() - i);
        const dateStr = targetDate.toISOString().split('T')[0];
        
        if (!recent.find((day: any) => day.date === dateStr && day.wordsLearned >= 20)) {
          return false;
        }
      }
      
      return true;
    }
  }
];

// 检查并发放徽章
export const checkAndAwardBadges = (store: Store<any>): IBadge[] => {
  const userBadges = store.state.user.badges || [];
  const newBadges: IBadge[] = [];
  
  badges.forEach(badge => {
    // 如果用户已有该徽章，跳过
    if (userBadges.some((b: IBadge) => b.id === badge.id)) return;
    
    // 检查徽章条件
    if (badge.condition(store)) {
      // 添加获得日期
      const badgeWithDate = {
        ...badge,
        dateEarned: new Date().toISOString()
      };
      
      // 添加到新徽章列表
      newBadges.push(badgeWithDate);
      
      // 保存到用户徽章中
      store.dispatch('addBadge', badgeWithDate);
    }
  });
  
  return newBadges;
};

// 获取徽章图标路径
export const getBadgeIconPath = (iconName: string): string => {
  return `/static/images/badges/${iconName}.png`;
};

// 显示获得徽章的动画和提示
export const showBadgeEarnedAnimation = (badge: IBadge): Promise<void> => {
  return new Promise((resolve) => {
    // 创建动画
    const animation = uni.createAnimation({
      duration: 1000,
      timingFunction: 'ease',
    });
    
    // 设置动画效果
    animation.scale(1.2).step();
    animation.scale(1).step();
    
    // 显示徽章获得提示
    uni.showToast({
      title: `获得徽章：${badge.name}`,
      icon: 'none',
      duration: 3000,
      image: getBadgeIconPath(badge.icon)
    });
    
    // 显示自定义弹窗
    uni.showModal({
      title: '恭喜获得新徽章！',
      content: `${badge.name}\n${badge.description}`,
      showCancel: false,
      confirmText: '太棒了',
      success: () => {
        resolve();
      }
    });
  });
};

// 获取用户所有徽章
export const getUserBadges = (store: Store<any>): IBadge[] => {
  try {
    // 检查store.state.achievements是否存在
    if (store.state.achievements && store.state.achievements.badges) {
      return store.state.achievements.badges;
    }
    
    // 如果没有找到，尝试从store.state.user获取
    if (store.state.user && store.state.user.badges) {
      return store.state.user.badges;
    }
    
    // 如果都没有找到，返回空数组
    return [];
  } catch (error) {
    console.error('获取徽章失败:', error);
    return [];
  }
};

// 获取特定类别的徽章
export const getBadgesByCategory = (store: Store<any>, category: string): IBadge[] => {
  const userBadges = getUserBadges(store);
  return userBadges.filter(badge => badge.category === category);
};

// 计算徽章完成度百分比
export const calculateBadgeCompletion = (store: Store<any>): number => {
  const userBadges = getUserBadges(store);
  return Math.round((userBadges.length / badges.length) * 100);
};

// 分享徽章到社交媒体
export const shareBadgeToSocial = (badge: IBadge): Promise<boolean> => {
  return new Promise((resolve) => {
    // 模拟分享功能，实际项目中应使用真实的分享API
    uni.showModal({
      title: '分享徽章',
      content: `确定要分享"${badge.name}"徽章到微信吗？`,
      success: (res) => {
        if (res.confirm) {
          // 模拟分享成功
          setTimeout(() => {
            uni.showToast({
              title: '分享成功',
              icon: 'success'
            });
            resolve(true);
          }, 1000);
        } else {
          resolve(false);
        }
      }
    });
  });
};

export default {
  badges,
  checkAndAwardBadges,
  getBadgeIconPath,
  showBadgeEarnedAnimation,
  getUserBadges,
  getBadgesByCategory,
  calculateBadgeCompletion,
  shareBadgeToSocial
}; 