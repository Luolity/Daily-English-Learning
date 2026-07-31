<template>
  <view class="badges-container">
    <view class="header">
      <text class="title">鎴戠殑鎴愬氨</text>
      <view class="badge-progress">
        <text class="progress-text">{{ badgeCompletion }}%</text>
        <view class="progress-bar">
          <view class="progress" :style="{ width: badgeCompletion + '%' }"></view>
        </view>
      </view>
    </view>
    
    <view class="badges-section" v-for="(section, index) in badgeSections" :key="index">
      <view class="section-header">
        <text class="section-title">{{ section.title }}</text>
        <text class="section-count">{{ section.badges.length }}/{{ section.total }}</text>
      </view>
      
      <view class="badges-grid">
        <view 
          v-for="(badge, badgeIndex) in section.badges" 
          :key="badgeIndex"
          class="badge-item"
          :class="{ earned: badge.dateEarned }"
          @click="showBadgeDetails(badge)"
        >
          <view class="badge-icon-placeholder" :class="getBadgeClassByLevel(badge.level)">
            <text class="badge-emoji">{{ getBadgeEmoji(badge.category) }}</text>
          </view>
          <text class="badge-name">{{ badge.name }}</text>
          <text class="badge-date" v-if="badge.dateEarned">
            {{ formatDate(badge.dateEarned) }}
          </text>
          <text class="badge-locked-text" v-else>鏈В閿?</text>
        </view>
      </view>
    </view>
    
    <!-- 寰界珷璇︽儏寮圭獥 -->
    <view v-if="showModal" class="badge-modal" @click.stop="showModal = false">
      <view class="modal-content" @click.stop>
        <view class="modal-header">
          <text class="modal-title">{{ selectedBadge.name }}</text>
          <text class="modal-close" @click="showModal = false">脳</text>
        </view>
        
        <view class="modal-body">
          <view 
            class="modal-badge-icon-placeholder" 
            :class="getBadgeClassByLevel(selectedBadge.level)"
          >
            <text class="modal-badge-emoji">{{ getBadgeEmoji(selectedBadge.category) }}</text>
          </view>
          
          <text class="modal-badge-description">{{ selectedBadge.description }}</text>
          
          <view class="modal-badge-info" v-if="selectedBadge.dateEarned">
            <text class="info-label">鑾峰緱鏃堕棿</text>
            <text class="info-value">{{ formatDate(selectedBadge.dateEarned, true) }}</text>
          </view>
          
          <view class="modal-badge-level">
            <text class="level-label">绛夌骇</text>
            <text :class="'level-' + selectedBadge.level">{{ getBadgeLevel(selectedBadge.level) }}</text>
          </view>
        </view>
        
        <view class="modal-footer">
          <button 
            class="modal-btn"
            :disabled="!selectedBadge.dateEarned"
            :class="{ disabled: !selectedBadge.dateEarned }"
            @click="shareBadge(selectedBadge)"
          >
            鍒嗕韩
          </button>
        </view>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import badgeService, { type IBadge } from '../../services/badge'

export default defineComponent({
  name: 'BadgesPage',
  setup() {
    const store = useStore()
    
    // 寰界珷鏁版嵁
    const allBadges = computed(() => badgeService.badges.map(badge => {
      const userBadge = userBadges.value.find((item: any) => (item.badgeId || item.id) === badge.id)
      return userBadge ? { ...badge, dateEarned: userBadge.dateEarned } : badge
    }))
    const userBadges = computed(() => store.state.achievements.badges || [])
    const badgeCompletion = computed(() => {
      const totalBadges = badgeService.badges.length;
      const earnedBadges = userBadges.value.length;
      return Math.round((earnedBadges / totalBadges) * 100);
    })
    
    // 妯℃€佹鐘舵€?
    const showModal = ref(false)
    const selectedBadge = ref<IBadge>({
      id: '',
      name: '',
      description: '',
      icon: '',
      condition: () => false,
      category: 'special'
    })
    
    // 寰界珷鍒嗙被
    const badgeSections = computed(() => {
      const streakBadges = allBadges.value.filter(badge => badge.category === 'streak')
      const vocabBadges = allBadges.value.filter(badge => badge.category === 'vocabulary')
      const challengeBadges = allBadges.value.filter(badge => badge.category === 'challenge')
      const specialBadges = allBadges.value.filter(badge => badge.category === 'special')
      
      return [
        {
          title: '杩炵画瀛︿範',
          badges: streakBadges,
          total: streakBadges.length
        },
        {
          title: '璇嶆眹鎴愬氨',
          badges: vocabBadges,
          total: vocabBadges.length
        },
        {
          title: '鎸戞垬鎴愬氨',
          badges: challengeBadges,
          total: challengeBadges.length
        },
        {
          title: '鐗规畩鎴愬氨',
          badges: specialBadges,
          total: specialBadges.length
        }
      ]
    })
    
    // 获取徽章图标路径
    const getBadgeIconPath = (iconName: string) => {
      return badgeService.getBadgeIconPath(iconName)
    }
    
    // 鏄剧ず寰界珷璇︽儏
    const showBadgeDetails = (badge: IBadge) => {
      selectedBadge.value = badge
      showModal.value = true
    }
    
    // 鏍煎紡鍖栨棩鏈?
    const formatDate = (dateString: string, detailed = false) => {
      const date = new Date(dateString)
      if (detailed) {
        return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日 ${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`
      }
      return `${date.getMonth() + 1}鏈?${date.getDate()}鏃
    }
    
    // 鑾峰彇寰界珷绛夌骇鏂囨湰
    const getBadgeLevel = (level?: string) => {
      switch (level) {
        case 'bronze': return '閾滅墝'
        case 'silver': return '閾剁墝'
        case 'gold': return '閲戠墝'
        case 'platinum': return '鐧介噾'
        default: return '鏅€?'
      }
    }
    
    // 鍒嗕韩寰界珷
    const shareBadge = async (badge: IBadge) => {
      if (!badge.dateEarned) return
      
      try {
        await badgeService.shareBadgeToSocial(badge)
      } catch (error) {
        console.error('鍒嗕韩澶辫触:', error)
        uni.showToast({
          title: '分享失败，请重试',
          icon: 'none'
        })
      }
    }
    
    // 鑾峰彇寰界珷绫诲埆琛ㄦ儏
    const getBadgeEmoji = (category: string) => {
      switch (category) {
        case 'streak': return '猸?'
        case 'vocabulary': return '馃摉'
        case 'challenge': return '馃弳'
        case 'special': return '馃帠锔?'
        default: return '馃敯'
      }
    }
    
    // 鑾峰彇寰界珷绫诲埆棰滆壊
    const getBadgeClassByLevel = (level?: string) => {
      switch (level) {
        case 'bronze': return 'bronze-badge'
        case 'silver': return 'silver-badge'
        case 'gold': return 'gold-badge'
        case 'platinum': return 'platinum-badge'
        default: return 'normal-badge'
      }
    }
    
    onMounted(async () => {
      await store.dispatch('fetchBadges')
      await store.dispatch('getBadgeCompletion')
    })
    
    return {
      badgeCompletion,
      badgeSections,
      showModal,
      selectedBadge,
      getBadgeIconPath,
      showBadgeDetails,
      formatDate,
      getBadgeLevel,
      shareBadge,
      getBadgeEmoji,
      getBadgeClassByLevel
    }
  }
})
</script>

<style>
.badges-container {
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

.badge-progress {
  background-color: #fff;
  border-radius: 15rpx;
  padding: 20rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}

.progress-text {
  font-size: 32rpx;
  font-weight: bold;
  color: #4caf50;
  margin-bottom: 10rpx;
  display: block;
}

.progress-bar {
  height: 12rpx;
  background-color: #f0f0f0;
  border-radius: 6rpx;
  overflow: hidden;
}

.progress {
  height: 100%;
  background: linear-gradient(90deg, #4caf50, #8bc34a);
  transition: width 0.3s;
}

.badges-section {
  margin-bottom: 30rpx;
  background-color: #fff;
  border-radius: 15rpx;
  padding: 20rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 15rpx;
  border-bottom: 1rpx solid #f0f0f0;
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.section-count {
  font-size: 28rpx;
  color: #999;
}

.badges-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-around;
  padding: 10rpx 0;
  gap: 10rpx;
}

.badge-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 160rpx;
  margin-bottom: 20rpx;
  transition: all 0.3s ease;
}

.badge-item:active {
  transform: scale(0.95);
}

.badge-item:hover .badge-icon-placeholder {
  transform: translateY(-5rpx);
  box-shadow: 0 10rpx 15rpx rgba(0, 0, 0, 0.1);
}

.earned .badge-icon-placeholder {
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(255, 215, 0, 0.4);
  }
  70% {
    box-shadow: 0 0 0 10rpx rgba(255, 215, 0, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(255, 215, 0, 0);
  }
}

.badge-icon-placeholder {
  width: 128rpx;
  height: 128rpx;
  margin-bottom: 16rpx;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: all 0.3s ease;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.12);
}

.badge-item:not(.earned) .badge-icon-placeholder {
  opacity: 0.3;
  filter: grayscale(100%);
  background: #ccc;
  box-shadow: none;
}

.badge-item:not(.earned) .badge-emoji {
  opacity: 0.5;
}

.badge-emoji {
  font-size: 64rpx;
  color: #fff;
  text-shadow: 0 2rpx 5rpx rgba(0, 0, 0, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.badge-name {
  font-size: 24rpx;
  color: #333;
  text-align: center;
  margin-bottom: 5rpx;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: 100%;
}

.badge-date {
  font-size: 20rpx;
  color: #4caf50;
}

.badge-locked-text {
  font-size: 24rpx;
  color: #999;
}

.badge-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 100;
}

.modal-content {
  width: 80%;
  background-color: #fff;
  border-radius: 15rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.15);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.modal-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.modal-close {
  font-size: 40rpx;
  color: #999;
  padding: 0 10rpx;
}

.modal-body {
  padding: 30rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.modal-badge-icon-placeholder {
  width: 220rpx;
  height: 220rpx;
  margin-bottom: 24rpx;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: all 0.3s ease;
  box-shadow: 0 6rpx 18rpx rgba(0, 0, 0, 0.15);
}

.modal-badge-emoji {
  font-size: 96rpx;
  color: #fff;
  text-shadow: 0 2rpx 5rpx rgba(0, 0, 0, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.modal-badge-description {
  font-size: 28rpx;
  color: #666;
  text-align: center;
  margin-bottom: 30rpx;
  line-height: 1.5;
}

.modal-badge-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20rpx;
}

.info-label {
  font-size: 24rpx;
  color: #999;
  margin-bottom: 5rpx;
}

.info-value {
  font-size: 28rpx;
  color: #333;
}

.modal-badge-level {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20rpx;
}

.level-label {
  font-size: 24rpx;
  color: #999;
  margin-bottom: 5rpx;
}

.level-bronze {
  color: #cd7f32;
  font-weight: bold;
  font-size: 28rpx;
}

.level-silver {
  color: #c0c0c0;
  font-weight: bold;
  font-size: 28rpx;
}

.level-gold {
  color: #ffd700;
  font-weight: bold;
  font-size: 28rpx;
}

.level-platinum {
  color: #e5e4e2;
  font-weight: bold;
  font-size: 28rpx;
  text-shadow: 0 0 2rpx rgba(0, 0, 0, 0.2);
}

.modal-footer {
  padding: 20rpx 30rpx;
  border-top: 1rpx solid #f0f0f0;
  display: flex;
  justify-content: center;
}

.modal-btn {
  background: linear-gradient(135deg, #4caf50, #8bc34a);
  color: #fff;
  font-size: 28rpx;
  padding: 15rpx 40rpx;
  border-radius: 50rpx;
  border: none;
}

.modal-btn.disabled {
  background: #cccccc;
  color: #ffffff;
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
</style> 
