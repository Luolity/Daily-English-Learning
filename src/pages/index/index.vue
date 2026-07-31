<template>
  <view class="page-container">
    <view class="index-container">
      <view class="header">
        <view class="welcome-section">
          <view class="welcome-text">
            <text class="greeting">{{ greeting }}</text>
            <text class="username">{{ userInfo.nickname || '同学' }}</text>
          </view>
          <view class="avatar" @click="navigateTo('/pages/profile/index')">
            <image class="avatar-image" :src="userAvatarUrl" mode="aspectFill" />
          </view>
        </view>

        <view class="streak-card">
          <view class="streak-info">
            <view class="streak-count">
              <text class="streak-number">{{ learningStreak }}</text>
              <text class="streak-label">天</text>
            </view>
            <text class="streak-text">连续学习</text>
          </view>
          <view class="streak-calendar">
            <view
                v-for="(day, index) in recentDays"
                :key="index"
                class="calendar-day"
                :class="{ active: day.isStudied, today: day.isToday }"
            >
              <text class="day-name">{{ day.name }}</text>
              <view class="day-dot"></view>
            </view>
          </view>
          <view v-if="hasNewBadge && latestBadge" class="streak-badge" @click="showBadgeDetails">
            <text class="badge-icon">🏆</text>
            <text class="badge-text">{{ latestBadge.name }}</text>
          </view>
        </view>
      </view>

      <view class="daily-goal-section">
        <view class="section-header">
          <text class="section-title">今日目标</text>
          <text class="goal-progress">{{ dailyGoal.completed }}/{{ dailyGoal.total }}</text>
        </view>
        <view class="progress-bar">
          <view class="progress" :style="{ width: dailyGoal.percentage + '%' }"></view>
        </view>
      </view>

      <view class="quick-actions">
        <view class="action-card" @click="navigateTo('/pages/vocabulary/wordcard')">
          <view class="action-icon vocabulary">
            <svg-icon name="book" color="#9c27b0" :size="24" />
          </view>
          <text class="action-title">单词学习</text>
        </view>
        <view class="action-card" @click="navigateTo('/pages/listening/sentence')">
          <view class="action-icon listening">
            <svg-icon name="headphone" color="#03a9f4" :size="24" />
          </view>
          <text class="action-title">听力练习</text>
        </view>
        <view class="action-card" @click="navigateTo('/pages/vocabulary/challenge')">
          <view class="action-icon challenge">
            <svg-icon name="target" color="#ff9800" :size="24" />
          </view>
          <text class="action-title">记忆挑战</text>
        </view>
        <view class="action-card" @click="navigateTo('/pages/vocabulary/favorites')">
          <view class="action-icon favorites">
            <svg-icon name="star" color="#ffc107" :size="24" />
          </view>
          <text class="action-title">生词本</text>
        </view>
      </view>

      <view class="daily-challenge-section">
        <view class="section-header">
          <text class="section-title">每日挑战</text>
          <text class="view-all" @click="navigateTo('/pages/listening/challenge')">查看全部</text>
        </view>
        <view class="challenge-card" @click="navigateTo('/pages/listening/challenge')">
          <view class="challenge-image">
            <svg-icon name="headphone" color="#ffffff" :size="36" />
          </view>
          <view class="challenge-content">
            <text class="challenge-title">今日听力挑战</text>
            <text class="challenge-description">完成听力测验，获取成就徽章</text>
            <view class="challenge-status" :class="{ completed: isDailyChallengeCompleted }">
              <text>{{ isDailyChallengeCompleted ? '已完成' : '去挑战' }}</text>
            </view>
          </view>
        </view>
      </view>

      <view class="word-of-day-section">
        <view class="section-header">
          <text class="section-title">每日单词</text>
          <view class="refresh-btn" @click="refreshDailyWord">
            <svg-icon name="refresh" :size="22" color="#4caf50" />
          </view>
        </view>
        <view class="word-card" v-if="dailyWord && dailyWord.word">
          <view class="word-header">
            <text class="word">{{ dailyWord.word || 'Loading...' }}</text>
            <text class="phonetic">{{ dailyWord.phonetic || '' }}</text>
            <view class="word-tools">
              <button class="word-tool-btn" @click="playWordPronunciation">
                <svg-icon name="sound" :size="20" color="#666" />
              </button>
              <button
                  class="word-tool-btn"
                  :class="{ active: isWordFavorite }"
                  @click="toggleWordFavorite"
              >
                <svg-icon name="star" :size="20" :color="isWordFavorite ? '#ffc107' : '#666'" />
              </button>
            </view>
          </view>
          <view class="word-content">
            <text class="part-of-speech">{{ dailyWord.partOfSpeech || '' }}</text>
            <text class="translation">{{ dailyWord.translation || '' }}</text>
            <text class="definition">{{ dailyWord.definition || '' }}</text>
            <text class="example" v-if="dailyWord.example">{{ dailyWord.example }}</text>
          </view>
        </view>
        <view class="word-card empty" v-else @click="fetchDailyWord">
          <view class="empty-state">
            <svg-icon name="book" :size="40" color="#e0e0e0" />
            <text class="empty-text">点击加载每日单词</text>
          </view>
        </view>
      </view>
    </view>
    <tab-bar :current="0"></tab-bar>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted, nextTick } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useStore } from 'vuex'
import { getUserAvatarUrl } from '../../utils/avatar'
import type { IBadge } from '../../services/badge'
import badgeService from '../../services/badge'
import type { IWordCard } from '../../store/types'
import SvgIcon from '../../components/SvgIcon.vue'
import TabBar from '../../components/TabBar.vue'

export default defineComponent({
  name: 'Index',
  components: {
    SvgIcon,
    TabBar
  },
  setup() {
    const store = useStore()

    // 徽章相关
    const hasNewBadge = ref(false)
    const latestBadge = ref<IBadge | null>(null)
    const isChallengeBadgeEarned = ref(false)

    // 用户信息
    const userInfo = computed(() => store.getters.userInfo)
    const userAvatarUrl = computed(() => store.getters.userAvatarUrl || getUserAvatarUrl(userInfo.value?.avatar))

    // 问候语
    const greeting = computed(() => {
      const hour = new Date().getHours()
      if (hour < 6) return '凌晨好'
      if (hour < 9) return '早上好'
      if (hour < 12) return '上午好'
      if (hour < 14) return '中午好'
      if (hour < 18) return '下午好'
      if (hour < 22) return '晚上好'
      return '夜深了'
    })

    // 学习天数
    const learningStreak = computed(() => store.getters.learningStreak)

    // 最近7天学习记录
    const recentDays = computed(() => {
      const days = []
      const today = new Date()
      const dayNames = ['日', '一', '二', '三', '四', '五', '六']

      for (let i = 6; i >= 0; i--) {
        const date = new Date()
        date.setDate(today.getDate() - i)
        const dateStr = date.toISOString().split('T')[0]

        // 检查该日期是否有学习记录
        const isStudied = store.state.learningProgress.dailyStats.some(
            (item: any) => item.date === dateStr
        )

        days.push({
          date: dateStr,
          name: dayNames[date.getDay()],
          isStudied,
          isToday: i === 0
        })
      }

      return days
    })

    // 每日目标
    const dailyGoal = computed(() => {
      const completed = store.state.learningProgress.dailyStats.find(
          (item: any) => item.date === new Date().toISOString().split('T')[0]
      )?.wordsLearned || 0

      const total = store.getters.dailyTarget || 20
      const percentage = Math.min(Math.round((completed / total) * 100), 100)

      return {
        completed,
        total,
        percentage
      }
    })

    // 每日挑战状态
    const isDailyChallengeCompleted = ref(false)

    // 每日单词
    const dailyWord = ref<IWordCard>({
      id: '',
      word: '',
      translation: '',
      phonetic: '',
      partOfSpeech: '',
      definition: '',
      example: '',
      difficulty: 'easy',
      categories: []
    })

    // 是否已收藏每日单词
    const isWordFavorite = computed(() => {
      return store.getters.favoriteWords.some((word: IWordCard) => word.id === dailyWord.value.id)
    })

    // 获取每日单词
    const fetchDailyWord = async () => {
      try {
        console.log('开始获取每日单词...');

        // 先检查本地存储是否有今日单词
        const today = new Date().toISOString().split('T')[0];
        const storedWordData = uni.getStorageSync('dailyWord');
        const storedWord = storedWordData ? JSON.parse(storedWordData) : null;

        // 如果本地存储中有今天的单词，直接使用
        if (storedWord && storedWord.date === today) {
          console.log('从本地存储获取到今日单词:', storedWord.word);
          dailyWord.value = storedWord.word;
          return dailyWord.value;
        }

        // 否则从API获取新单词
        console.log('从API获取单词列表...');
        const response = await store.dispatch('fetchWordList', {
          category: '',
          difficulty: '',
          page: 1,
          size: 20
        });

        console.log('获取单词列表响应:', response);

        let words = [];
        if (response && response.content && Array.isArray(response.content)) {
          words = response.content;
        } else if (store.state.vocabulary.wordList.length > 0) {
          words = store.state.vocabulary.wordList;
        }

        console.log(`获取到${words.length}个单词`);

        if (words && words.length > 0) {
          // 根据日期选择一个固定的单词
          const day = new Date().getDate();
          const index = day % words.length;
          console.log(`今天是${day}号，选择第${index}个单词`);

          const selectedWord = words[index];
          console.log('选中的每日单词:', selectedWord);

          if (selectedWord) {
            dailyWord.value = selectedWord;

            // 保存到本地存储
            uni.setStorageSync('dailyWord', JSON.stringify({
              date: today,
              word: selectedWord
            }));
          } else {
            console.error('无法获取每日单词，选中的单词为空');
            // 使用默认单词
            dailyWord.value = {
              id: 'default',
              word: 'Hello',
              translation: '你好',
              phonetic: '/həˈləʊ/',
              partOfSpeech: 'n.',
              definition: 'used as a greeting when you meet someone',
              example: 'Hello, how are you today?',
              difficulty: 'easy',
              categories: ['基础词汇']
            };
          }
        } else {
          console.error('获取单词列表失败，列表为空');
          // 使用默认单词
          dailyWord.value = {
            id: 'default',
            word: 'Hello',
            translation: '你好',
            phonetic: '/həˈləʊ/',
            partOfSpeech: 'n.',
            definition: 'used as a greeting when you meet someone',
            example: 'Hello, how are you today?',
            difficulty: 'easy',
            categories: ['基础词汇']
          };
        }
      } catch (error) {
        console.error('获取每日单词失败:', error);
        // 使用默认单词
        dailyWord.value = {
          id: 'default',
          word: 'Hello',
          translation: '你好',
          phonetic: '/həˈləʊ/',
          partOfSpeech: 'n.',
          definition: 'used as a greeting when you meet someone',
          example: 'Hello, how are you today?',
          difficulty: 'easy',
          categories: ['基础词汇']
        };
      }
    }

    // 刷新每日单词
    const refreshDailyWord = async () => {
      try {
        console.log('刷新每日单词...');

        // 显示加载提示
        uni.showLoading({
          title: '加载中...'
        });

        // 从API获取单词列表
        const response = await store.dispatch('fetchWordList', {
          category: '',
          difficulty: '',
          page: 1,
          size: 20
        });

        let words = [];
        if (response && response.content && Array.isArray(response.content)) {
          words = response.content;
        } else if (store.state.vocabulary.wordList.length > 0) {
          words = store.state.vocabulary.wordList;
        }

        if (words && words.length > 0) {
          // 随机选择一个单词
          const randomIndex = Math.floor(Math.random() * words.length);
          console.log(`随机选择第${randomIndex}个单词`);

          const selectedWord = words[randomIndex];
          console.log('选中的单词:', selectedWord);

          if (selectedWord) {
            dailyWord.value = selectedWord;

            // 显示成功提示
            uni.hideLoading();
            uni.showToast({
              title: '单词已更新',
              icon: 'success'
            });
          } else {
            console.error('无法获取单词，选中的单词为空');
            uni.hideLoading();
            uni.showToast({
              title: '刷新失败',
              icon: 'none'
            });
          }
        } else {
          console.error('获取单词列表失败，列表为空');
          uni.hideLoading();
          uni.showToast({
            title: '刷新失败',
            icon: 'none'
          });
        }
      } catch (error) {
        console.error('刷新每日单词失败:', error);
        uni.hideLoading();
        uni.showToast({
          title: '刷新失败',
          icon: 'none'
        });
      }
    }

    // 播放单词发音
    const playWordPronunciation = () => {
      // 这里模拟播放发音
      uni.showToast({
        title: `正在播放: ${dailyWord.value.word}`,
        icon: 'none'
      })

      // 实际项目中可以使用 uni.createInnerAudioContext 播放音频
      // const audio = uni.createInnerAudioContext()
      // audio.src = `https://dict.youdao.com/dictvoice?audio=${dailyWord.value.word}&type=2`
      // audio.play()
    }

    // 切换收藏状态
    const toggleWordFavorite = () => {
      if (isWordFavorite.value) {
        store.dispatch('removeFromFavorites', dailyWord.value.id)
      } else {
        store.dispatch('addToFavorites', dailyWord.value)
      }
    }

    // 页面跳转
    const navigateTo = (url: string) => {
      // 判断是否为 TabBar 页面
      const tabBarPages = [
        '/pages/index/index',
        '/pages/vocabulary/index',
        '/pages/listening/index',
        '/pages/profile/index'
      ]

      if (tabBarPages.includes(url)) {
        // 使用 switchTab 跳转到 TabBar 页面
        uni.switchTab({
          url
        })
      } else {
        // 使用 navigateTo 跳转到非 TabBar 页面
        uni.navigateTo({
          url
        })
      }
    }

    // 检查徽章
    const checkBadges = async () => {
      // 检查并发放新徽章
      const newBadges = badgeService.checkAndAwardBadges(store)

      // 如果有新徽章，显示提示
      if (newBadges.length > 0) {
        // 保存最新的徽章信息
        latestBadge.value = newBadges[newBadges.length - 1]
        hasNewBadge.value = true

        // 展示徽章获得动画
        await nextTick()
        for (const badge of newBadges) {
          await badgeService.showBadgeEarnedAnimation(badge)

          // 如果是挑战徽章，设置标志
          if (badge.category === 'challenge') {
            isChallengeBadgeEarned.value = true
          }
        }
      }
    }

    // 显示徽章详情
    const showBadgeDetails = () => {
      if (latestBadge.value) {
        uni.showModal({
          title: latestBadge.value.name,
          content: latestBadge.value.description,
          showCancel: true,
          cancelText: '关闭',
          confirmText: '分享',
          success: (res) => {
            if (res.confirm && latestBadge.value) {
              // 分享徽章
              shareBadge(latestBadge.value)
            }
          }
        })
      }
    }

    // 分享徽章
    const shareBadge = async (badge?: IBadge) => {
      const badgeToShare = badge || latestBadge.value

      if (!badgeToShare) return

      try {
        // 模拟微信分享
        uni.showLoading({ title: '准备分享...' })

        setTimeout(() => {
          uni.hideLoading()

          // 调用分享API
          badgeService.shareBadgeToSocial(badgeToShare)
        }, 800)
      } catch (error) {
        console.error('分享失败:', error)
        uni.hideLoading()
        uni.showToast({
          title: '分享失败，请重试',
          icon: 'none'
        })
      }
    }

    onMounted(() => {
      fetchDailyWord()
      checkBadges()
      if (store.getters.isLoggedIn) {
        store.dispatch('fetchUserProfile')
      }
    })

    onShow(() => {
      const token = uni.getStorageSync('token')
      if (!token) {
        uni.redirectTo({ url: '/pages/profile/login' })
        return
      }
      if (store.getters.isLoggedIn) {
        store.dispatch('fetchUserProfile')
      }
    })

    return {
      userInfo,
      userAvatarUrl,
      greeting,
      learningStreak,
      recentDays,
      dailyGoal,
      isDailyChallengeCompleted,
      dailyWord,
      isWordFavorite,
      refreshDailyWord,
      fetchDailyWord,
      playWordPronunciation,
      toggleWordFavorite,
      navigateTo,
      hasNewBadge,
      latestBadge,
      isChallengeBadgeEarned,
      showBadgeDetails,
      shareBadge
    }
  }
})
</script>

<style>
/* 基础样式，无需内联iconfont */

.index-container {
  display: flex;
  flex-direction: column;
  padding: 30rpx;
  box-sizing: border-box;
  min-height: 100vh;
  background-color: #f8f9fa;
  padding-bottom: 110rpx;
}

.header {
  margin-bottom: 30rpx;
  border-radius: 20rpx;
}

.welcome-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
  padding: 20rpx 10rpx;
}

.welcome-text {
  display: flex;
  flex-direction: column;
}

.greeting {
  font-size: 32rpx;
  color: #666;
  margin-bottom: 8rpx;
}

.username {
  font-size: 48rpx;
  font-weight: bold;
  color: #333;
}

.avatar {
  width: 100rpx;
  height: 100rpx;
  border-radius: 50%;
  box-shadow: 0 4rpx 10rpx rgba(0, 0, 0, 0.1);
  border: 3rpx solid #ffffff;
  overflow: hidden;
  background-color: #e8f5e9;
}

.avatar-image {
  width: 100%;
  height: 100%;
  border-radius: 50%;
}

.streak-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
  margin-top: 20rpx;
  position: relative;
}

.streak-info {
  display: flex;
  align-items: center;
}

.streak-count {
  display: flex;
  align-items: baseline;
  margin-right: 15rpx;
}

.streak-number {
  font-size: 52rpx;
  font-weight: bold;
  color: #4caf50;
}

.streak-label {
  font-size: 24rpx;
  color: #666;
  margin-left: 4rpx;
}

.streak-text {
  font-size: 28rpx;
  color: #666;
}

.streak-calendar {
  display: flex;
  gap: 12rpx;
}

.calendar-day {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 36rpx;
}

.day-name {
  font-size: 22rpx;
  color: #666;
  margin-bottom: 8rpx;
}

.day-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
  background-color: #e0e0e0;
}

.calendar-day.active .day-dot {
  background-color: #4caf50;
}

.calendar-day.today .day-name {
  color: #4caf50;
  font-weight: bold;
}

.streak-badge {
  position: absolute;
  top: -10rpx;
  right: -10rpx;
  background: linear-gradient(135deg, #FFC107, #FF9800);
  border-radius: 30rpx;
  padding: 5rpx 15rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 10rpx rgba(255, 152, 0, 0.3);
  z-index: 10;
  animation: pulse 2s infinite;
}

.badge-icon {
  font-size: 24rpx;
  margin-right: 5rpx;
}

.badge-text {
  font-size: 20rpx;
  color: #fff;
  font-weight: bold;
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
  }
}

.daily-goal-section {
  margin-bottom: 30rpx;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.goal-progress {
  font-size: 28rpx;
  color: #666;
}

.progress-bar {
  height: 16rpx;
  background-color: #e0e0e0;
  border-radius: 8rpx;
  overflow: hidden;
}

.progress {
  height: 100%;
  background: linear-gradient(90deg, #4caf50, #8bc34a);
  border-radius: 8rpx;
  transition: width 0.3s ease;
}

.quick-actions {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  margin-bottom: 30rpx;
}

.action-card {
  width: 48%;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx;
  margin-bottom: 20rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.action-card:active {
  transform: translateY(2rpx);
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}

.action-icon {
  width: 80rpx;
  height: 80rpx;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.action-icon svg {
  width: 40rpx;
  height: 40rpx;
}

.action-icon.vocabulary {
  background-color: rgba(156, 39, 176, 0.1);
  color: #9c27b0;
}

.action-icon.listening {
  background-color: rgba(3, 169, 244, 0.1);
  color: #03a9f4;
}

.action-icon.challenge {
  background-color: rgba(255, 152, 0, 0.1);
  color: #ff9800;
}

.action-icon.favorites {
  background-color: rgba(255, 193, 7, 0.1);
  color: #ffc107;
}

.action-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
}

.daily-challenge-section {
  margin-bottom: 30rpx;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
}

.view-all {
  font-size: 24rpx;
  color: #4caf50;
}

.challenge-card {
  display: flex;
  align-items: center;
  margin-top: 15rpx;
  border-radius: 12rpx;
  background-color: #f9f9f9;
  padding: 15rpx;
  transition: background-color 0.2s ease;
}

.challenge-card:active {
  background-color: #f0f0f0;
}

.challenge-image {
  width: 120rpx;
  height: 120rpx;
  border-radius: 12rpx;
  margin-right: 20rpx;
  background: linear-gradient(135deg, #03a9f4, #00bcd4);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 10rpx rgba(3, 169, 244, 0.2);
}

.challenge-content {
  flex: 1;
}

.challenge-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 8rpx;
}

.challenge-description {
  font-size: 24rpx;
  color: #666;
  margin-bottom: 12rpx;
}

.challenge-status {
  display: inline-block;
  font-size: 22rpx;
  color: #4caf50;
  border: 1rpx solid #4caf50;
  border-radius: 100rpx;
  padding: 4rpx 16rpx;
}

.challenge-status.completed {
  background-color: #4caf50;
  color: #fff;
}

.word-of-day-section {
  margin-bottom: 30rpx;
}

.word-card {
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
  margin-top: 20rpx;
}

.word-card.empty {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 300rpx;
  background-color: #f9f9f9;
  border: 2rpx dashed #e0e0e0;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40rpx 0;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
  margin-top: 20rpx;
}

.word-header {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
  flex-wrap: wrap;
}

.word {
  font-size: 48rpx;
  font-weight: bold;
  color: #333;
  margin-right: 16rpx;
}

.phonetic {
  font-size: 28rpx;
  color: #666;
  flex: 1;
}

.word-tools {
  display: flex;
  gap: 16rpx;
}

.word-tool-btn {
  background: none;
  border: none;
  padding: 0;
  margin: 0;
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background-color: #f5f5f5;
}

.word-tool-btn.active {
  background-color: #fff8e1;
}

.word-content {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.part-of-speech {
  font-size: 24rpx;
  color: #999;
  font-style: italic;
}

.translation {
  font-size: 36rpx;
  color: #4caf50;
  font-weight: bold;
  margin-bottom: 8rpx;
}

.definition {
  font-size: 28rpx;
  color: #666;
  line-height: 1.5;
  margin-bottom: 16rpx;
}

.example {
  font-size: 26rpx;
  color: #999;
  line-height: 1.5;
  font-style: italic;
  border-left: 4rpx solid #e0e0e0;
  padding-left: 16rpx;
}

.refresh-btn {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f5f5f5;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.refresh-btn:active {
  transform: rotate(180deg);
  background-color: #e0e0e0;
}
</style>
