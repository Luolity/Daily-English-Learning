<template>
  <view class="achievements-container">
    <view class="header">
      <text class="title">成就徽章</text>
      <view class="badge-completion">
        <text class="completion-text">完成度: {{ badgeCompletion }}%</text>
        <view class="completion-bar">
          <view class="completion-progress" :style="{ width: badgeCompletion + '%' }"></view>
        </view>
      </view>
    </view>
    
    <!-- 错误信息 -->
    <view class="error-container" v-if="errorMessage">
      <text class="error-text">{{ errorMessage }}</text>
      <view class="retry-btn" @click="loadBadges">
        <text>重试</text>
      </view>
    </view>
    
    <!-- 加载状态 -->
    <view class="loading-container" v-else-if="isLoading">
      <view class="loading-spinner"></view>
      <text class="loading-text">加载中...</text>
    </view>
    
    <view class="content" v-else>
      <view class="tabs">
        <view 
          class="tab-item" 
          :class="{ active: activeTab === 'badges' }" 
          @click="activeTab = 'badges'"
        >
          <text>已获得徽章</text>
        </view>
        <view 
          class="tab-item" 
          :class="{ active: activeTab === 'locked' }" 
          @click="activeTab = 'locked'"
        >
          <text>未解锁徽章</text>
        </view>
      </view>
      
      <view class="badges-grid" v-if="activeTab === 'badges'">
        <view v-if="badges.length === 0" class="empty-state">
          <view class="empty-badge-placeholder">
            <text class="badge-symbol">🏆</text>
          </view>
          <text class="empty-text">暂无获得的徽章</text>
          <text class="empty-tip">继续学习，解锁更多成就！</text>
        </view>
        <view v-else class="badge-item" v-for="badge in badges" :key="badge.badgeId" @click="showBadgeDetail(badge)">
          <view class="badge-icon-placeholder" :class="getBadgeClass(badge.level || '')">
            <text class="badge-symbol">{{ getBadgeSymbol(badge.category || '') }}</text>
          </view>
          <text class="badge-name">{{ badge.name }}</text>
          <text class="badge-description">{{ badge.description }}</text>
          <text class="badge-date" v-if="badge.dateEarned">{{ formatDate(badge.dateEarned) }}</text>
        </view>
      </view>
      
      <view class="badges-grid" v-else>
        <view v-if="lockedBadges.length === 0" class="empty-state">
          <view class="empty-badge-placeholder">
            <text class="badge-symbol">⭐</text>
          </view>
          <text class="empty-text">恭喜！您已解锁全部徽章</text>
        </view>
        <view v-else class="badge-item locked" v-for="badge in lockedBadges" :key="badge.id">
          <view class="badge-icon-placeholder locked-badge">
            <text class="badge-symbol">{{ getBadgeSymbol(badge.category) }}</text>
          </view>
          <text class="badge-name">{{ badge.name }}</text>
          <text class="badge-description">{{ badge.description }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'Achievements',
  setup() {
    const store = useStore()
    const activeTab = ref('badges')
    const isLoading = ref(false)
    const errorMessage = ref('')
    
    // 已获得的徽章
    const badges = computed(() => store.state.achievements.badges || [])
    
    // 徽章完成度
    const badgeCompletion = computed(() => store.state.achievements.badgeCompletion || 0)
    
    // 未解锁的徽章
    const allPossibleBadges = [
      {
        id: 'streak_3',
        name: '初学乍练',
        description: '连续学习3天',
        category: 'streak',
        level: 'bronze'
      },
      {
        id: 'streak_7',
        name: '坚持不懈',
        description: '连续学习7天',
        category: 'streak',
        level: 'silver'
      },
      {
        id: 'streak_30',
        name: '习惯养成',
        description: '连续学习30天',
        category: 'streak',
        level: 'gold'
      },
      {
        id: 'streak_100',
        name: '英语大师',
        description: '连续学习100天',
        category: 'streak',
        level: 'platinum'
      },
      {
        id: 'vocabulary_50',
        name: '词汇新手',
        description: '学习50个单词',
        category: 'vocabulary',
        level: 'bronze'
      },
      {
        id: 'vocabulary_200',
        name: '词汇收藏家',
        description: '学习200个单词',
        category: 'vocabulary',
        level: 'silver'
      },
      {
        id: 'vocabulary_500',
        name: '词汇大师',
        description: '学习500个单词',
        category: 'vocabulary',
        level: 'gold'
      },
      {
        id: 'accuracy_80',
        name: '精准学习者',
        description: '正确率达到80%',
        category: 'challenge',
        level: 'silver'
      },
      {
        id: 'accuracy_95',
        name: '学霸',
        description: '正确率达到95%',
        category: 'challenge',
        level: 'gold'
      },
      {
        id: 'challenge_perfect',
        name: '完美挑战',
        description: '在挑战中获得100%正确率',
        category: 'challenge',
        level: 'gold'
      },
      {
        id: 'challenge_master',
        name: '挑战大师',
        description: '完成10次挑战',
        category: 'challenge',
        level: 'silver'
      },
      {
        id: 'special_first_day',
        name: '初来乍到',
        description: '完成第一天的学习',
        category: 'special',
        level: 'bronze'
      }
    ]
    
    const lockedBadges = computed(() => {
      return allPossibleBadges.filter(badge => 
        !badges.value.some((earned: any) => (earned.badgeId || earned.id) === badge.id)
      )
    })
    
    // 检查网络连接
    const checkNetworkConnection = () => {
      return new Promise<void>((resolve, reject) => {
        uni.getNetworkType({
          success: (res) => {
            if (res.networkType === 'none') {
              errorMessage.value = '网络连接不可用，请检查网络设置'
              reject(new Error('网络连接不可用'))
            } else {
              console.log('网络连接正常:', res.networkType)
              resolve()
            }
          },
          fail: () => {
            errorMessage.value = '无法获取网络状态'
            reject(new Error('无法获取网络状态'))
          }
        })
      })
    }
    
    // 加载徽章数据
    const loadBadges = async () => {
      isLoading.value = true
      errorMessage.value = ''
      console.log('开始加载徽章数据...')
      
      try {
        // 检查网络连接
        await checkNetworkConnection()
        
        console.log('检查并解锁徽章...')
        await store.dispatch('checkAndAwardBadges')
        console.log('调用fetchBadges...')
        await store.dispatch('fetchBadges')
        console.log('fetchBadges完成，徽章数据:', store.state.achievements.badges)
        
        console.log('调用getBadgeCompletion...')
        await store.dispatch('getBadgeCompletion')
        console.log('getBadgeCompletion完成，完成度:', store.state.achievements.badgeCompletion)
      } catch (error: any) {
        console.error('加载徽章数据失败:', error)
        errorMessage.value = error.message || '加载徽章失败'
        uni.showToast({
          title: '加载徽章失败',
          icon: 'none'
        })
      } finally {
        isLoading.value = false
        console.log('徽章数据加载完成')
      }
    }
    
    // 显示徽章详情
    const showBadgeDetail = (badge: any) => {
      uni.showModal({
        title: badge.name,
        content: `恭喜您获得"${badge.name}"徽章！\n\n${badge.description}`,
        showCancel: false
      })
    }
    
    const getBadgeSymbol = (category: string) => {
      if (category === 'streak') return '⭐'
      if (category === 'vocabulary') return '📖'
      if (category === 'challenge') return '🏆'
      if (category === 'listening') return '🎧'
      return '🎖️'
    }
    
    // 获取徽章样式类
    const getBadgeClass = (level: string) => {
      if (level === 'bronze') return 'bronze-badge'
      if (level === 'silver') return 'silver-badge'
      if (level === 'gold') return 'gold-badge'
      if (level === 'platinum') return 'platinum-badge'
      return 'normal-badge'
    }
    
    // 格式化日期
    const formatDate = (dateStr: string) => {
      try {
        const date = new Date(dateStr)
        return date.toLocaleDateString('zh-CN', { 
          year: 'numeric', 
          month: '2-digit', 
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit'
        })
      } catch (e) {
        return dateStr
      }
    }
    
    // 组件挂载时加载数据
    onMounted(() => {
      loadBadges()
    })
    
    return {
      activeTab,
      badges,
      lockedBadges,
      badgeCompletion,
      isLoading,
      errorMessage,
      showBadgeDetail,
      getBadgeSymbol,
      getBadgeClass,
      formatDate,
      loadBadges
    }
  }
})
</script>

<style>
.achievements-container {
  padding: 30rpx;
}

.header {
  margin-bottom: 30rpx;
  display: flex;
  flex-direction: column;
  position: relative;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
}

.badge-completion {
  margin-bottom: 20rpx;
}

.completion-text {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 10rpx;
  display: block;
}

.completion-bar {
  height: 16rpx;
  background-color: #f0f0f0;
  border-radius: 8rpx;
  overflow: hidden;
  box-shadow: inset 0 1rpx 3rpx rgba(0, 0, 0, 0.1);
}

.completion-progress {
  height: 100%;
  background: linear-gradient(90deg, #4caf50, #8bc34a);
  border-radius: 8rpx;
  transition: width 0.3s ease;
}

.content {
  padding-bottom: 30rpx;
}

/* 加载状态样式 */
.loading-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 300rpx;
}

.loading-spinner {
  width: 60rpx;
  height: 60rpx;
  border: 4rpx solid #4caf50;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  margin-top: 20rpx;
  font-size: 28rpx;
  color: #666;
}

.badge-date {
  font-size: 22rpx;
  color: #999;
  margin-top: 10rpx;
}

.tabs {
  display: flex;
  background-color: #ffffff;
  border-radius: 15rpx;
  margin-bottom: 30rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.tab-item {
  flex: 1;
  height: 80rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 28rpx;
  color: #666;
  position: relative;
}

.tab-item.active {
  color: #3cc51f;
  font-weight: bold;
}

.tab-item.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20%;
  width: 60%;
  height: 6rpx;
  background-color: #3cc51f;
  border-radius: 3rpx;
}

.badges-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

.badge-item {
  width: 48%;
  background-color: #ffffff;
  border-radius: 15rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  align-items: center;
}

.badge-item.locked {
  opacity: 0.6;
}

.badge-icon-placeholder {
  width: 128rpx;
  height: 128rpx;
  margin-bottom: 16rpx;
  border-radius: 50%;
  background-color: #f0f0f0;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.12);
  transition: all 0.3s ease;
}

.badge-emoji {
  font-size: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  color: #fff;
  text-shadow: 0 2rpx 5rpx rgba(0, 0, 0, 0.2);
}

.badge-name {
  font-size: 30rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
  text-align: center;
}

.badge-description {
  font-size: 24rpx;
  color: #666;
  text-align: center;
}

.empty-state {
  width: 100%;
  padding: 60rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.empty-badge-placeholder {
  width: 128rpx;
  height: 128rpx;
  border-radius: 50%;
  background-color: #f0f0f0;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.12);
}

.empty-badge-emoji {
  font-size: 64rpx;
  color: #ccc;
}

.empty-text {
  font-size: 32rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.empty-tip {
  font-size: 26rpx;
  color: #999;
}

.badge-item.locked .badge-icon-placeholder {
  opacity: 0.3;
  filter: grayscale(100%);
  background: #ccc;
  box-shadow: none;
}

.badge-item.locked .badge-emoji {
  opacity: 0.5;
}

.locked-badge {
  background: #ccc;
  opacity: 0.3;
  filter: grayscale(100%);
  box-shadow: none;
}

/* 徽章等级样式 */
.bronze-badge {
  background: linear-gradient(135deg, #cd7f32, #e6b17e, #cd7f32);
  box-shadow: 0 4rpx 12rpx rgba(205, 127, 50, 0.5);
}

.silver-badge {
  background: linear-gradient(135deg, #c0c0c0, #e6e6e6, #c0c0c0);
  box-shadow: 0 4rpx 12rpx rgba(192, 192, 192, 0.5);
}

.gold-badge {
  background: linear-gradient(135deg, #ffd700, #ffecb3, #ffd700);
  box-shadow: 0 4rpx 12rpx rgba(255, 215, 0, 0.5);
}

.platinum-badge {
  background: linear-gradient(135deg, #e5e4e2, #ffffff, #e5e4e2);
  box-shadow: 0 4rpx 12rpx rgba(229, 228, 226, 0.5);
}

.normal-badge {
  background: linear-gradient(135deg, #3498db, #9b59b6, #3498db);
  box-shadow: 0 4rpx 12rpx rgba(52, 152, 219, 0.5);
}

.error-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 40rpx;
  background-color: #fff5f5;
  border-radius: 15rpx;
  margin-bottom: 30rpx;
}

.error-text {
  color: #e53935;
  font-size: 28rpx;
  margin-bottom: 20rpx;
  text-align: center;
}

.retry-btn {
  background-color: #e53935;
  color: white;
  padding: 10rpx 30rpx;
  border-radius: 30rpx;
  font-size: 24rpx;
}
</style> 
