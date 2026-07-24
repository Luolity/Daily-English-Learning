<template>
  <view class="statistics-container">
    <view class="header">
      <text class="title">学习统计</text>
    </view>
    
    <view class="summary-card">
      <view class="summary-item">
        <text class="summary-value">{{ totalDays }}</text>
        <text class="summary-label">总学习天数</text>
      </view>
      <view class="summary-item">
        <text class="summary-value">{{ wordsLearned }}</text>
        <text class="summary-label">已学单词</text>
      </view>
      <view class="summary-item">
        <text class="summary-value">{{ challengesCompleted }}</text>
        <text class="summary-label">挑战完成</text>
      </view>
    </view>
    
    <view class="chart-section">
      <view class="section-header">
        <text class="section-title">单词学习趋势</text>
        <view class="time-range">
          <text 
            v-for="(range, index) in timeRanges" 
            :key="index"
            class="range-item"
            :class="{ active: currentRange === index }"
            @click="setTimeRange(index)"
          >{{ range }}</text>
        </view>
      </view>
      
      <view class="chart-container">
        <view class="chart-placeholder">
          <view class="chart-bars">
            <view v-for="(value, index) in chartData" :key="index" class="chart-bar-wrapper">
              <view class="chart-bar" :style="{ height: value + '%' }"></view>
              <text class="chart-label">{{ chartLabels[index] }}</text>
            </view>
          </view>
        </view>
      </view>
    </view>
    
    <view class="stats-section">
      <view class="section-header">
        <text class="section-title">学习分析</text>
      </view>
      
      <view class="stats-list">
        <view class="stats-item">
          <view class="stats-info">
            <text class="stats-title">单词掌握率</text>
            <text class="stats-desc">根据挑战正确率计算</text>
          </view>
          <view class="stats-value">
            <view class="progress-bar">
              <view class="progress" :style="{ width: masteryRate + '%' }"></view>
            </view>
            <text class="percentage">{{ masteryRate }}%</text>
          </view>
        </view>
        
        <view class="stats-item">
          <view class="stats-info">
            <text class="stats-title">学习连续性</text>
            <text class="stats-desc">近30天内的学习频率</text>
          </view>
          <view class="stats-value">
            <view class="progress-bar">
              <view class="progress" :style="{ width: continuityRate + '%' }"></view>
            </view>
            <text class="percentage">{{ continuityRate }}%</text>
          </view>
        </view>
        
        <view class="stats-item">
          <view class="stats-info">
            <text class="stats-title">听力训练频率</text>
            <text class="stats-desc">相对于单词学习的比例</text>
          </view>
          <view class="stats-value">
            <view class="progress-bar">
              <view class="progress" :style="{ width: listeningRate + '%' }"></view>
            </view>
            <text class="percentage">{{ listeningRate }}%</text>
          </view>
        </view>
      </view>
    </view>
    
    <view class="ranking-section">
      <view class="section-header">
        <text class="section-title">排行榜</text>
        <text class="view-all" @click="viewRanking">查看完整榜单</text>
      </view>
      
      <view class="ranking-list">
        <view 
          v-for="(user, index) in topUsers" 
          :key="index"
          class="ranking-item"
          :class="{ 'current-user': user.isCurrentUser }"
        >
          <text class="ranking-number">{{ index + 1 }}</text>
          <view class="ranking-avatar-placeholder">
            <text class="ranking-avatar-text">{{ getUserInitial(user.nickname) }}</text>
          </view>
          <text class="ranking-name">{{ user.nickname }}</text>
          <text class="ranking-score">{{ user.score }}</text>
        </view>
        
        <view class="current-user-rank" v-if="!isInTopRanking">
          <text class="ranking-number">{{ currentUserRank }}</text>
          <view class="ranking-avatar-placeholder current-user-avatar">
            <text class="ranking-avatar-text">{{ getUserInitial(userInfo.nickname) }}</text>
          </view>
          <text class="ranking-name">{{ userInfo.nickname }}</text>
          <text class="ranking-score">{{ userScore }}</text>
        </view>
      </view>
    </view>
    
    <view class="about-section">
      <text class="statistics-note">统计数据每日更新</text>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import api from '../../services/api'

export default defineComponent({
  name: 'StatisticsPage',
  setup() {
    const store = useStore()
    
    // 用户信息
    const userInfo = computed(() => store.getters.userInfo)
    
    const progressHistory = ref<any[]>([])
    const totalDays = computed(() => progressHistory.value.length)
    const wordsLearned = ref(0)
    const challengesCompleted = ref(0)
    const masteryRate = ref(0)
    const continuityRate = ref(0)
    const listeningRate = ref(0)
    
    // 时间范围选择
    const timeRanges = ['周', '月', '年', '全部']
    const currentRange = ref(1) // 默认选择"月"
    
    const chartData = ref<number[]>([])
    const chartLabels = ref<string[]>([])
    
    const topUsers = ref<any[]>([])
    const currentUserRank = ref(0)
    const userScore = ref(0)
    const isInTopRanking = computed(() => {
      return topUsers.value.some(user => user.isCurrentUser)
    })
    
    const setTimeRange = (index: number) => {
      currentRange.value = index
      updateChartData()
    }
    
    const viewRanking = () => {
      uni.navigateTo({ url: '/pages/vocabulary/leaderboard' })
    }
    
    // 获取用户名首字母
    const getUserInitial = (nickname: string) => {
      if (!nickname || nickname.length === 0) return '未'
      return nickname.charAt(0)
    }
    
    const updateChartData = () => {
      const now = new Date()
      const days = currentRange.value === 0 ? 7 : currentRange.value === 1 ? 30 : currentRange.value === 2 ? 365 : Infinity
      const records = progressHistory.value
        .filter(item => days === Infinity || (now.getTime() - new Date(item.date).getTime()) / 86400000 < days)
        .sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime())

      const maximum = Math.max(...records.map(item => item.wordsLearned || 0), 1)
      chartData.value = records.map(item => Math.round(((item.wordsLearned || 0) / maximum) * 100))
      chartLabels.value = records.map(item => item.date.slice(5))
    }

    const loadStatistics = async () => {
      try {
        const [history, stats, challenges, leaderboard] = await Promise.all([
          api.progress.getProgress(),
          api.progress.getStats(),
          api.challenge.getHistory(),
          api.challenge.getLeaderboard(10)
        ])

        progressHistory.value = Array.isArray(history) ? history : []
        const statistics = (stats as any)?.data || stats || {}
        wordsLearned.value = Number(statistics.totalWordsLearned || 0)
        masteryRate.value = Math.round(Number(statistics.correctRate || 0) * 100)
        continuityRate.value = Math.min(100, Math.round((Number(statistics.learningStreak || 0) / 30) * 100))
        challengesCompleted.value = Array.isArray(challenges) ? challenges.length : 0
        listeningRate.value = 0
        userScore.value = challengesCompleted.value

        topUsers.value = (Array.isArray(leaderboard) ? leaderboard : []).map((item: any) => ({
          nickname: item.nickname || '学习用户',
          score: item.score || 0,
          isCurrentUser: String(item.userId) === String(userInfo.value.id)
        }))
        const rank = topUsers.value.findIndex(item => item.isCurrentUser)
        currentUserRank.value = rank >= 0 ? rank + 1 : 0
        updateChartData()
      } catch (error) {
        console.error('加载学习统计失败:', error)
        uni.showToast({ title: '加载学习统计失败', icon: 'none' })
      }
    }
    
    onMounted(() => {
      loadStatistics()
    })
    
    return {
      userInfo,
      totalDays,
      wordsLearned,
      challengesCompleted,
      masteryRate,
      continuityRate,
      listeningRate,
      timeRanges,
      currentRange,
      topUsers,
      currentUserRank,
      userScore,
      isInTopRanking,
      setTimeRange,
      viewRanking,
      getUserInitial,
      chartData,
      chartLabels
    }
  }
})
</script>

<style>
.statistics-container {
  padding: 30rpx;
  min-height: 100vh;
  background-color: #f8f9fa;
}

.header {
  margin-bottom: 30rpx;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.summary-card {
  display: flex;
  justify-content: space-between;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
}

.summary-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.summary-value {
  font-size: 48rpx;
  font-weight: bold;
  color: #4caf50;
  margin-bottom: 10rpx;
}

.summary-label {
  font-size: 24rpx;
  color: #666;
}

.chart-section {
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.time-range {
  display: flex;
}

.range-item {
  font-size: 24rpx;
  color: #666;
  padding: 8rpx 16rpx;
  margin-left: 10rpx;
  border-radius: 100rpx;
}

.range-item.active {
  background-color: rgba(76, 175, 80, 0.1);
  color: #4caf50;
  font-weight: bold;
}

.chart-container {
  margin-top: 20rpx;
  padding: 20rpx;
  background-color: #fff;
  border-radius: 12rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}

.chart-placeholder {
  width: 100%;
  height: 400rpx;
  display: flex;
  justify-content: center;
  align-items: flex-end;
  padding: 20rpx 0;
}

.chart-bars {
  display: flex;
  justify-content: space-around;
  align-items: flex-end;
  width: 100%;
  height: 100%;
}

.chart-bar-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-end;
  height: 300rpx;
  width: 8%;
}

.chart-bar {
  width: 100%;
  background: linear-gradient(to top, #4caf50, #8bc34a);
  border-radius: 6rpx;
  transition: height 0.3s ease;
}

.chart-label {
  font-size: 22rpx;
  color: #999;
  margin-top: 10rpx;
  white-space: nowrap;
}

.stats-section {
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
}

.stats-list {
  display: flex;
  flex-direction: column;
}

.stats-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.stats-item:last-child {
  border-bottom: none;
}

.stats-info {
  flex: 1;
}

.stats-title {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 6rpx;
}

.stats-desc {
  font-size: 22rpx;
  color: #999;
}

.stats-value {
  display: flex;
  align-items: center;
  width: 260rpx;
}

.progress-bar {
  height: 12rpx;
  background-color: #f0f0f0;
  border-radius: 6rpx;
  overflow: hidden;
  flex: 1;
  margin-right: 15rpx;
}

.progress {
  height: 100%;
  background: linear-gradient(90deg, #4caf50, #8bc34a);
  border-radius: 6rpx;
}

.percentage {
  font-size: 24rpx;
  color: #4caf50;
  width: 60rpx;
  text-align: right;
}

.ranking-section {
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
}

.view-all {
  font-size: 24rpx;
  color: #4caf50;
}

.ranking-list {
  display: flex;
  flex-direction: column;
}

.ranking-item {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.ranking-item.current-user {
  background-color: rgba(76, 175, 80, 0.05);
  border-radius: 8rpx;
  padding: 20rpx 10rpx;
}

.current-user-rank {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  margin-top: 20rpx;
  border-top: 1rpx dashed #e0e0e0;
}

.ranking-number {
  width: 60rpx;
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  text-align: center;
}

.ranking-avatar-placeholder {
  width: 60rpx;
  height: 60rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, #8bc34a, #4caf50);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 20rpx;
  box-shadow: 0 2rpx 5rpx rgba(0, 0, 0, 0.1);
}

.ranking-avatar-text {
  font-size: 28rpx;
  font-weight: bold;
  color: white;
}

.current-user-avatar {
  background: linear-gradient(135deg, #3cc51f, #8bc34a);
  box-shadow: 0 2rpx 5rpx rgba(76, 175, 80, 0.3);
}

.ranking-name {
  flex: 1;
  font-size: 28rpx;
  color: #333;
}

.ranking-score {
  font-size: 28rpx;
  font-weight: bold;
  color: #ff9800;
}

.about-section {
  text-align: center;
  padding: 30rpx 0;
}

.statistics-note {
  font-size: 24rpx;
  color: #999;
}
</style> 
