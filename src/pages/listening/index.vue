<template>
  <view class="page-container">
    <view class="listening-container">
      <view class="header">
        <text class="title">听力练习</text>
      </view>
      
      <view class="content">
        <view class="section">
          <view class="section-header">
            <text class="section-title">每日挑战</text>
          </view>
          <view class="daily-challenge" @click="navigateTo('/pages/listening/challenge')">
            <view class="daily-image-placeholder">
              <text class="daily-placeholder-text">今日听力挑战</text>
            </view>
            <view class="daily-overlay">
              <text class="daily-title">今日听力挑战</text>
              <text class="daily-subtitle">完成测验获得成就</text>
              <button class="daily-btn">开始挑战</button>
            </view>
          </view>
        </view>
        
        <view class="section">
          <view class="section-header">
            <text class="section-title">练习模式</text>
          </view>
          <view class="card-container">
            <view class="card" @click="navigateTo('/pages/listening/sentence')">
              <view class="card-image-placeholder sentence-bg">
                <text class="mode-icon">听</text>
              </view>
              <view class="card-content">
                <text class="card-title">单句精听</text>
                <text class="card-description">逐句练习，调节语速</text>
              </view>
            </view>
            <view class="card" @click="showScenarioNotice">
              <view class="card-image-placeholder scenario-bg">
                <text class="mode-icon">场</text>
              </view>
              <view class="card-content">
                <text class="card-title">场景听力</text>
                <text class="card-description">真实场景对话练习</text>
              </view>
            </view>
          </view>
        </view>
        
        <view class="section">
          <view class="section-header">
            <text class="section-title">热门场景</text>
          </view>
          <scroll-view scroll-x class="scenario-list">
            <view 
              class="scenario-item" 
              v-for="(scenario, index) in scenarios" 
              :key="index"
              @click="navigateToScenario(scenario)"
            >
              <view class="scenario-image-placeholder" :class="`scenario-bg-${index}`">
                <text class="scenario-icon" :style="{ color: getScenarioColor(index) }">听</text>
              </view>
              <view class="scenario-info">
                <text class="scenario-title">{{ scenario.title }}</text>
                <view class="scenario-meta">
                  <text class="scenario-level">{{ scenario.level }}</text>
                  <text class="scenario-duration">{{ scenario.duration }}</text>
                </view>
              </view>
            </view>
          </scroll-view>
        </view>
        
        <view class="section">
          <view class="section-header">
            <text class="section-title">下载管理</text>
            <text class="view-all">查看全部</text>
          </view>
          <view class="download-list">
            <view v-if="downloadedAudios.length === 0" class="empty-downloads">
              <text>暂无下载内容</text>
            </view>
            <view v-else class="download-item" v-for="(audio, index) in downloadedAudios" :key="index">
              <view class="download-info">
                <text class="download-title">{{ audio.title }}</text>
                <text class="download-size">{{ audio.size }}</text>
              </view>
              <button class="download-action">
                <text>播放</text>
              </button>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, reactive } from 'vue'

export default defineComponent({
  name: 'ListeningIndex',
  setup() {
    // 图片加载状态
    const imageLoaded = reactive({
      daily: false,
      sentence: false,
      scenario: false
    })
    
    // 场景图片加载状态
    const scenarioImagesLoaded = ref(Array(4).fill(false))
    
    // 处理图片加载错误
    const handleImageError = (e: any) => {
      console.error('图片加载失败:', e)
      // 图片加载失败时可以做一些处理，如显示默认图片
    }
    
    // 模拟场景数据
    const scenarios = reactive([
      {
        id: '1',
        title: '咖啡店点餐',
        level: '初级',
        duration: '3分钟',
        image: '/static/images/listening/scenario_cafe.png'
      },
      {
        id: '2',
        title: '机场对话',
        level: '中级',
        duration: '5分钟',
        image: '/static/images/listening/scenario_airport.png'
      },
      {
        id: '3',
        title: '商务会议',
        level: '高级',
        duration: '8分钟',
        image: '/static/images/listening/scenario_business.png'
      },
      {
        id: '4',
        title: '医院就诊',
        level: '中级',
        duration: '4分钟',
        image: '/static/images/listening/scenario_hospital.png'
      }
    ])
    
    // 模拟下载数据
    const downloadedAudios = ref([
      {
        id: '1',
        title: '旅游英语对话合集',
        size: '15MB'
      },
      {
        id: '2',
        title: '美式英语发音练习',
        size: '8MB'
      }
    ])
    
    // 页面跳转
    const navigateTo = (url: string) => {
      uni.navigateTo({
        url
      })
    }
    
    // 跳转到特定场景
    const navigateToScenario = (scenario: any) => {
      uni.showToast({
        title: `${scenario.title}正在准备中`,
        icon: 'none'
      })
    }

    const showScenarioNotice = () => {
      uni.showToast({
        title: '场景听力正在准备中',
        icon: 'none'
      })
    }
    
    // 为每个场景生成对应的emoji
    const getScenarioColor = (index: number) => {
      const colors = ['#795548', '#03a9f4', '#607d8b', '#4caf50'];
      return colors[index % colors.length];
    }
    
    return {
      scenarios,
      downloadedAudios,
      navigateTo,
      navigateToScenario,
      showScenarioNotice,
      imageLoaded,
      scenarioImagesLoaded,
      handleImageError,
      getScenarioColor
    }
  }
})
</script>

<style>
.listening-container {
  padding: 30rpx;
  padding-bottom: 110rpx;
}

.header {
  margin-bottom: 30rpx;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
}

.content {
  padding-bottom: 30rpx;
}

.section {
  margin-bottom: 40rpx;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
  padding-bottom: 10rpx;
  border-bottom: 1rpx solid #f8f8f8;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  position: relative;
  padding-left: 16rpx;
}

.section-title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 10%;
  height: 80%;
  width: 6rpx;
  background-color: #3cc51f;
  border-radius: 3rpx;
}

.view-all {
  font-size: 26rpx;
  color: #3cc51f;
}

.daily-challenge {
  position: relative;
  height: 300rpx;
  border-radius: 15rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.1);
  background-color: #f0f0f0;
  transition: transform 0.3s ease;
}

.daily-challenge:active {
  transform: scale(0.98);
}

.daily-image-placeholder {
  width: 100%;
  height: 300rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(60, 197, 31, 0.1);
}

.placeholder-icon {
  font-size: 100rpx;
  color: #999;
}

.daily-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.7));
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 30rpx;
}

.daily-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #ffffff;
  margin-bottom: 10rpx;
}

.daily-subtitle {
  font-size: 28rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 20rpx;
}

.daily-btn {
  width: 200rpx;
  height: 70rpx;
  line-height: 70rpx;
  background-color: #3cc51f;
  color: #ffffff;
  font-size: 28rpx;
  border-radius: 35rpx;
  text-align: center;
  margin: 0;
}

.card-container {
  display: flex;
  justify-content: space-between;
}

.card {
  width: 48%;
  background-color: #ffffff;
  border-radius: 15rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
  position: relative;
}

.card:active {
  transform: scale(0.98);
}

.card-image-placeholder {
  width: 100%;
  height: 200rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f0f0;
}

.mode-icon,
.scenario-icon {
  font-size: 48rpx;
  font-weight: bold;
  color: #4caf50;
}

.sentence-bg {
  background-color: #f9f9f9;
}

.scenario-bg {
  background-color: #f5f5f5;
}

.card-content {
  padding: 20rpx;
}

.card-title {
  font-size: 30rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.card-description {
  font-size: 24rpx;
  color: #666;
}

.scenario-list {
  white-space: nowrap;
}

.scenario-item {
  display: inline-block;
  width: 400rpx;
  margin-right: 20rpx;
  background-color: #ffffff;
  border-radius: 15rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
  position: relative;
}

.scenario-item:active {
  transform: scale(0.98);
}

.scenario-image-placeholder {
  width: 100%;
  height: 220rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f0f0;
}

.scenario-info {
  padding: 20rpx;
}

.scenario-title {
  font-size: 30rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
  white-space: normal;
}

.scenario-meta {
  display: flex;
  justify-content: space-between;
}

.scenario-level {
  font-size: 24rpx;
  color: #3cc51f;
  background-color: rgba(60, 197, 31, 0.1);
  padding: 4rpx 10rpx;
  border-radius: 6rpx;
}

.scenario-duration {
  font-size: 24rpx;
  color: #666;
}

.download-list {
  background-color: #ffffff;
  border-radius: 15rpx;
  padding: 20rpx;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.download-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.download-item:last-child {
  border-bottom: none;
}

.download-title {
  font-size: 30rpx;
  margin-bottom: 10rpx;
}

.download-size {
  font-size: 24rpx;
  color: #999;
}

.download-action {
  background: none;
  border: none;
  font-size: 40rpx;
  color: #3cc51f;
  padding: 0;
  line-height: 1;
  margin: 0;
  font-size: 24rpx;
}

.empty-downloads {
  text-align: center;
  padding: 40rpx 0;
  color: #999;
}

/* 图片加载动画 */
.image-loading {
  animation: pulse 1.5s infinite ease-in-out;
}

@keyframes pulse {
  0% {
    opacity: 0.6;
  }
  50% {
    opacity: 0.9;
  }
  100% {
    opacity: 0.6;
  }
}

/* 图片占位符样式 */
.image-placeholder {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f0f0;
  z-index: 1;
}

.placeholder-text {
  font-size: 28rpx;
  color: #999;
  text-align: center;
}

.scenario-bg-0 {
  background-color: rgba(255, 193, 7, 0.1);
}

.scenario-bg-1 {
  background-color: rgba(3, 169, 244, 0.1);
}

.scenario-bg-2 {
  background-color: rgba(156, 39, 176, 0.1);
}

.scenario-bg-3 {
  background-color: rgba(76, 175, 80, 0.1);
}

.placeholder-icon {
  font-size: 80rpx;
  color: #999;
  text-align: center;
}

.daily-placeholder-text {
  font-size: 36rpx;
  font-weight: bold;
  color: #999;
  text-align: center;
}
</style> 
