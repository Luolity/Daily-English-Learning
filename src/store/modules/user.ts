import type { IBadge } from '../../services/badge';

// 用户状态接口
interface UserState {
  id: string;
  nickname: string;
  avatar: string;
  badges: IBadge[];
  settings: {
    theme: string;
    soundEnabled: boolean;
    notificationEnabled: boolean;
  };
}

// 初始状态
const state: UserState = {
  id: '1',
  nickname: '英语学习者',
  avatar: '/static/images/profile/default-avatar.png',
  badges: [],
  settings: {
    theme: 'light',
    soundEnabled: true,
    notificationEnabled: true
  }
};

// Getters
const getters = {
  userInfo: (state: UserState) => {
    return {
      id: state.id,
      nickname: state.nickname,
      avatar: state.avatar
    };
  },
  userBadges: (state: UserState) => state.badges,
  userSettings: (state: UserState) => state.settings
};

// Mutations
const mutations = {
  SET_USER_INFO(state: UserState, userInfo: Partial<UserState>) {
    if (userInfo.nickname) state.nickname = userInfo.nickname;
    if (userInfo.avatar) state.avatar = userInfo.avatar;
  },
  SET_USER_SETTING(state: UserState, { key, value }: { key: string; value: any }) {
    if (state.settings.hasOwnProperty(key)) {
      (state.settings as any)[key] = value;
    }
  },
  ADD_BADGE(state: UserState, badge: IBadge) {
    // 防止重复添加
    if (!state.badges.some(b => b.id === badge.id)) {
      state.badges.push(badge);
    }
  },
  REMOVE_BADGE(state: UserState, badgeId: string) {
    state.badges = state.badges.filter(badge => badge.id !== badgeId);
  },
  SET_BADGES(state: UserState, badges: IBadge[]) {
    state.badges = badges;
  }
};

// Actions
const actions = {
  updateUserInfo({ commit }: { commit: Function }, userInfo: Partial<UserState>) {
    commit('SET_USER_INFO', userInfo);
    return Promise.resolve();
  },
  updateUserSetting({ commit }: { commit: Function }, setting: { key: string; value: any }) {
    commit('SET_USER_SETTING', setting);
    return Promise.resolve();
  },
  addBadge({ commit }: { commit: Function }, badge: IBadge) {
    commit('ADD_BADGE', badge);
    return Promise.resolve(badge);
  },
  removeBadge({ commit }: { commit: Function }, badgeId: string) {
    commit('REMOVE_BADGE', badgeId);
    return Promise.resolve();
  },
  setBadges({ commit }: { commit: Function }, badges: IBadge[]) {
    commit('SET_BADGES', badges);
    return Promise.resolve();
  }
};

export default {
  state,
  getters,
  mutations,
  actions
}; 