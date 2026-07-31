import { Store } from 'vuex';

// 寰界珷瀹氫箟鎺ュ彛
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

// 寰界珷鍒楄〃
const badges: IBadge[] = [
  // 杩炵画瀛︿範寰界珷
  {
    id: 'streak_3',
    name: '初学乍练',
    description: '杩炵画瀛︿範3澶?',
    icon: 'streak-3',
    level: 'bronze',
    category: 'streak',
    condition: (store) => store.getters.learningStreak >= 3
  },
  {
    id: 'streak_7',
    name: '鍧氭寔涓嶆噲',
    description: '杩炵画瀛︿範7澶?',
    icon: 'streak-7',
    level: 'silver',
    category: 'streak',
    condition: (store) => store.getters.learningStreak >= 7
  },
  {
    id: 'streak_30',
    name: '瀛︿範杈句汉',
    description: '杩炵画瀛︿範30澶?',
    icon: 'streak-30',
    level: 'gold',
    category: 'streak',
    condition: (store) => store.getters.learningStreak >= 30
  },
  {
    id: 'streak_100',
    name: '英语大师',
    description: '杩炵画瀛︿範100澶?',
    icon: 'streak-100',
    level: 'platinum',
    category: 'streak',
    condition: (store) => store.getters.learningStreak >= 100
  },
  
  // 鍗曡瘝瀛︿範寰界珷
  {
    id: 'vocabulary_50',
    name: '璇嶆眹鏂版墜',
    description: '瀛︿範50涓崟璇?',
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
    name: '璇嶆眹鏀惰棌瀹?',
    description: '瀛︿範200涓崟璇?',
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
    name: '璇嶆眹澶у笀',
    description: '瀛︿範500涓崟璇?',
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
  
  // 鎸戞垬寰界珷
  {
    id: 'challenge_perfect',
    name: '瀹岀編鎸戞垬',
    description: '鍦ㄦ寫鎴樹腑鑾峰緱100%姝ｇ‘鐜?',
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
    name: '鎸戞垬澶у笀',
    description: '瀹屾垚10娆℃寫鎴?',
    icon: 'challenge-master',
    level: 'silver',
    category: 'challenge',
    condition: (store) => {
      const challenges = store.state.learningProgress.challenges || [];
      return challenges.length >= 10;
    }
  },
  
  // 鐗规畩寰界珷
  {
    id: 'special_first_day',
    name: '鍒濇潵涔嶅埌',
    description: '完成第一天的学习',
    icon: 'special-first',
    level: 'bronze',
    category: 'special',
    condition: (store) => store.state.learningProgress.dailyStats.length > 0
  },
  {
    id: 'special_all_targets',
    name: '目标达人',
    description: '杩炵画7澶╄揪鎴愭瘡鏃ュ涔犵洰鏍?',
    icon: 'special-target',
    level: 'gold',
    category: 'special',
    condition: (store) => {
      const stats = store.state.learningProgress.dailyStats;
      if (stats.length < 7) return false;
      
      // 鑾峰彇鏈€杩?7澶╃殑璁板綍
      const recent = [...stats].sort((a: any, b: any) => 
        new Date(b.date).getTime() - new Date(a.date).getTime()
      ).slice(0, 7);
      
      if (recent.length < 7) return false;
      
      // 妫€鏌ユ槸鍚﹁繛缁?7澶?
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

// 妫€鏌ュ苟鍙戞斁寰界珷
export const checkAndAwardBadges = (store: Store<any>): IBadge[] => {
  const userBadges = store.state.user.badges || [];
  const newBadges: IBadge[] = [];
  
  badges.forEach(badge => {
    // 濡傛灉鐢ㄦ埛宸叉湁璇ュ窘绔狅紝璺宠繃
    if (userBadges.some((b: IBadge) => b.id === badge.id)) return;
    
    // 妫€鏌ュ窘绔犳潯浠?
    if (badge.condition(store)) {
      // 娣诲姞鑾峰緱鏃ユ湡
      const badgeWithDate = {
        ...badge,
        dateEarned: new Date().toISOString()
      };
      
      // 娣诲姞鍒版柊寰界珷鍒楄〃
      newBadges.push(badgeWithDate);
      
      // 淇濆瓨鍒扮敤鎴峰窘绔犱腑
      store.dispatch('addBadge', badgeWithDate);
    }
  });
  
  return newBadges;
};

// 获取徽章图标路径
export const getBadgeIconPath = (iconName: string): string => {
  return `/static/images/badges/${iconName}.png`;
};

// 鏄剧ず鑾峰緱寰界珷鐨勫姩鐢诲拰鎻愮ず
export const showBadgeEarnedAnimation = (badge: IBadge): Promise<void> => {
  return new Promise((resolve) => {
    // 鍒涘缓鍔ㄧ敾
    const animation = uni.createAnimation({
      duration: 1000,
      timingFunction: 'ease',
    });
    
    // 璁剧疆鍔ㄧ敾鏁堟灉
    animation.scale(1.2, 1.2).step();
    animation.scale(1, 1).step();
    
    // 鏄剧ず寰界珷鑾峰緱鎻愮ず
    uni.showToast({
      title: `鑾峰緱寰界珷锛?${badge.name}`,
      icon: 'none',
      duration: 3000,
      image: getBadgeIconPath(badge.icon)
    });
    
    // 鏄剧ず鑷畾涔夊脊绐?
    uni.showModal({
      title: '恭喜获得新徽章！',
      content: `${badge.name}\n${badge.description}`,
      showCancel: false,
      confirmText: '澶浜?',
      success: () => {
        resolve();
      }
    });
  });
};

// 鑾峰彇鐢ㄦ埛鎵€鏈夊窘绔?
export const getUserBadges = (store: Store<any>): IBadge[] => {
  try {
    // 检查store.state.achievements是否存在
    if (store.state.achievements && store.state.achievements.badges) {
      return store.state.achievements.badges;
    }
    
    // 濡傛灉娌℃湁鎵惧埌锛屽皾璇曚粠store.state.user鑾峰彇
    if (store.state.user && store.state.user.badges) {
      return store.state.user.badges;
    }
    
    // 濡傛灉閮芥病鏈夋壘鍒帮紝杩斿洖绌烘暟缁?
    return [];
  } catch (error) {
    console.error('鑾峰彇寰界珷澶辫触:', error);
    return [];
  }
};

// 鑾峰彇鐗瑰畾绫诲埆鐨勫窘绔?
export const getBadgesByCategory = (store: Store<any>, category: string): IBadge[] => {
  const userBadges = getUserBadges(store);
  return userBadges.filter(badge => badge.category === category);
};

// 璁＄畻寰界珷瀹屾垚搴︾櫨鍒嗘瘮
export const calculateBadgeCompletion = (store: Store<any>): number => {
  const userBadges = getUserBadges(store);
  return Math.round((userBadges.length / badges.length) * 100);
};

// 鍒嗕韩寰界珷鍒扮ぞ浜ゅ獟浣?
export const shareBadgeToSocial = (badge: IBadge): Promise<boolean> => {
  return new Promise((resolve) => {
    // 妯℃嫙鍒嗕韩鍔熻兘锛屽疄闄呴」鐩腑搴斾娇鐢ㄧ湡瀹炵殑鍒嗕韩API
    uni.showModal({
      title: '鍒嗕韩寰界珷',
      content: `确定要分享“${badge.name}”徽章到微信吗？`,
      success: (res) => {
        if (res.confirm) {
          // 妯℃嫙鍒嗕韩鎴愬姛
          setTimeout(() => {
            uni.showToast({
              title: '鍒嗕韩鎴愬姛',
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
