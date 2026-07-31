<template>
  <view class="achievements-container">
    <view class="header">
      <text class="title">鎴愬氨寰界珷</text>
      <view class="badge-completion">
        <text class="completion-text">瀹屾垚搴?: {{ badgeCompletion }}%</text>
        <view class="completion-bar">
          <view class="completion-progress" :style="{ width: badgeCompletion + '%' }"></view>
        </view>
      </view>
    </view>
    
    <!-- 错误信息 -->
    <view class="error-container" v-if="errorMessage">
      <text class="error-text">{{ errorMessage }}</text>
      <view class="retry-btn" @click="loadBadges">
        <text>閲嶈瘯</text>
      </view>
    </view>
    
    <!-- 鍔犺浇鐘舵€? -->
    <view class="loading-container" v-else-if="isLoading">
      <view class="loading-spinner"></view>
      <text class="loading-text">鍔犺浇涓?...</text>
    </view>
    
    <view class="content" v-else>
      <view class="tabs">
        <view 
          class="tab-item" 
          :class="{ active: activeTab === 'badges' }" 
          @click="activeTab = 'badges'"
        >
          <text>宸茶幏寰楀窘绔?</text>
        </view>
        <view 
          class="tab-item" 
          :class="{ active: activeTab === 'locked' }" 
          @click="activeTab = 'locked'"
        >
          <text>鏈В閿佸窘绔?</text>
        </view>
      </view>
      
      <view class="badges-grid" v-if="activeTab === 'badges'">
        <view v-if="badges.length === 0" class="empty-state">
          <view class="empty-badge-placeholder">
            <text class="badge-symbol">馃弳</text>
          </view>
          <text class="empty-text">鏆傛棤鑾峰緱鐨勫窘绔?</text>
          <text class="empty-tip">缁х画瀛︿範锛岃В閿佹洿澶氭垚灏憋紒</text>
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
            <text class="badge-symbol">猸?</text>
          </view>
          <text class="empty-text">鎭枩锛佹偍宸茶В閿佸叏閮ㄥ窘绔?</text>
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
    
    // 宸茶幏寰楃殑寰界珷
    const badges = computed(() => store.state.achievements.badges || [])
    
    // 寰界珷瀹屾垚搴?
    const badgeCompletion = computed(() => store.state.achievements.badgeCompletion || 0)
    
    // 未解锁的徽章
    const allPossibleBadges = [
      {
        id: 'streak_3',
        name: '初学乍练',
        description: '杩炵画瀛︿範3澶?',
        category: 'streak',
        level: 'bronze'
      },
      {
        id: 'streak_7',
        name: '鍧氭寔涓嶆噲',
        description: '杩炵画瀛︿範7澶?',
        category: 'streak',
        level: 'silver'
      },
      {
        id: 'streak_30',
        name: '涔犳儻鍏绘垚',
        description: '杩炵画瀛︿範30澶?',
        category: 'streak',
        level: 'gold'
      },
      {
        id: 'streak_100',
        name: '英语大师',
        description: '杩炵画瀛︿範100澶?',
        category: 'streak',
        level: 'platinum'
      },
      {
        id: 'vocabulary_50',
        name: '璇嶆眹鏂版墜',
        description: '瀛︿範50涓崟璇?',
        category: 'vocabulary',
        level: 'bronze'
      },
      {
        id: 'vocabulary_200',
        name: '璇嶆眹鏀惰棌瀹?',
        description: '瀛︿範200涓崟璇?',
        category: 'vocabulary',
        level: 'silver'
      },
      {
        id: 'vocabulary_500',
        name: '璇嶆眹澶у笀',
        description: '瀛︿範500涓崟璇?',
        category: 'vocabulary',
        level: 'gold'
      },
      {
        id: 'accuracy_80',
        name: '绮惧噯瀛︿範鑰?',
        description: '姝ｇ‘鐜囪揪鍒?80%',
        category: 'challenge',
        level: 'silver'
      },
      {
        id: 'accuracy_95',
        name: '瀛﹂湼',
        description: '姝ｇ‘鐜囪揪鍒?95%',
        category: 'challenge',
        level: 'gold'
      },
      {
        id: 'challenge_perfect',
        name: '瀹岀編鎸戞垬',
        description: '鍦ㄦ寫鎴樹腑鑾峰緱100%姝ｇ‘鐜?',
        category: 'challenge',
        level: 'gold'
      },
      {
        id: 'challenge_master',
        name: '鎸戞垬澶у笀',
        description: '瀹屾垚10娆℃寫鎴?',
        category: 'challenge',
        level: 'silver'
      },
      {
        id: 'special_first_day',
        name: '鍒濇潵涔嶅埌',
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
    
    // 妫€鏌ョ綉缁滆繛鎺?
    const checkNetworkConnection = () => {
      return new Promise<void>((resolve, reject) => {
        uni.getNetworkType({
          success: (res) => {
            if (res.networkType === 'none') {
              errorMessage.value = '缃戠粶杩炴帴涓嶅彲鐢紝璇锋鏌ョ綉缁滆缃?'
              reject(new Error('缃戠粶杩炴帴涓嶅彲鐢?'))
            } else {
              console.log('缃戠粶杩炴帴姝ｅ父:', res.networkType)
              resolve()
            }
          },
          fail: () => {
            errorMessage.value = '鏃犳硶鑾峰彇缃戠粶鐘舵€?'
            reject(new Error('鏃犳硶鑾峰彇缃戠粶鐘舵€?'))
          }
        })
      })
    }
    
    // 鍔犺浇寰界珷鏁版嵁
    const loadBadges = async () => {
      isLoading.value = true
      errorMessage.value = ''
      console.log('寮€濮嬪姞杞藉窘绔犳暟鎹?...')
      
      try {
        // 妫€鏌ョ綉缁滆繛鎺?
        await checkNetworkConnection()
        
        console.log('妫€鏌ュ苟瑙ｉ攣寰界珷...')
        await store.dispatch('checkAndAwardBadges')
        console.log('璋冪敤fetchBadges...')
        await store.dispatch('fetchBadges')
        console.log('fetchBadges瀹屾垚锛屽窘绔犳暟鎹?:', store.state.achievements.badges)
        
        console.log('璋冪敤getBadgeCompletion...')
        await store.dispatch('getBadgeCompletion')
        console.log('getBadgeCompletion瀹屾垚锛屽畬鎴愬害:', store.state.achievements.badgeCompletion)
      } catch (error: any) {
        console.error('鍔犺浇寰界珷鏁版嵁澶辫触:', error)
        errorMessage.value = error.message || '鍔犺浇寰界珷澶辫触'
        uni.showToast({
          title: '鍔犺浇寰界珷澶辫触',
          icon: 'none'
        })
      } finally {
        isLoading.value = false
        console.log('寰界珷鏁版嵁鍔犺浇瀹屾垚')
      }
    }
    
    // 鏄剧ず寰界珷璇︽儏
    const showBadgeDetail = (badge: any) => {
      uni.showModal({
        title: badge.name,
        content: `鎭枩鎮ㄨ幏寰?"${badge.name}"寰界珷锛乗n\n${badge.description}`,
        showCancel: false
      })
    }
    
    const getBadgeSymbol = (category: string) => {
      if (category === 'streak') return '猸?'
      if (category === 'vocabulary') return '馃摉'
      if (category === 'challenge') return '馃弳'
      if (category === 'listening') return '馃帶'
      return '馃帠锔?'
    }
    
    // 鑾峰彇寰界珷鏍峰紡绫?
    const getBadgeClass = (level: string) => {
      if (level === 'bronze') return 'bronze-badge'
      if (level === 'silver') return 'silver-badge'
      if (level === 'gold') return 'gold-badge'
      if (level === 'platinum') return 'platinum-badge'
      return 'normal-badge'
    }
    
    // 鏍煎紡鍖栨棩鏈?
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
    
    // 缁勪欢鎸傝浇鏃跺姞杞芥暟鎹?
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

/* 鍔犺浇鐘舵€佹牱寮? */
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

/* 寰界珷绛夌骇鏍峰紡 */
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
