<template>
  <view class="page-container">
    <view class="profile-container">
      <view class="user-card">
        <view class="avatar-section">
          <view class="avatar-wrap" @click="changeAvatar">
            <image
              class="avatar-image"
              :src="displayAvatar"
              mode="aspectFill"
            />
            <view class="avatar-edit-badge">
              <svg-icon name="camera" color="#fff" :size="14" />
            </view>
          </view>
          <text class="nickname">{{ userInfo.nickname || '未设置昵称' }}</text>
          <text class="user-id">ID: {{ userInfo.id }}</text>
        </view>
        
        <view class="stats-section">
          <view class="stat-item">
            <text class="stat-value">{{ learningStreak }}</text>
            <text class="stat-label">连续学习</text>
          </view>
          <view class="stat-item">
            <text class="stat-value">{{ wordsLearned }}</text>
            <text class="stat-label">已学单词</text>
          </view>
          <view class="stat-item">
            <text class="stat-value">{{ badgeCompletion }}%</text>
            <text class="stat-label">成就完成</text>
          </view>
        </view>
      </view>
      
      <view class="menu-section">
        <view class="section-header">
          <text class="section-title">个人中心</text>
        </view>
        
        <view class="menu-list">
          <!-- 我的成就 -->
          <view class="menu-item" @click="navigateTo('/pages/profile/achievements')">
            <view class="menu-icon awards">
              <svg-icon name="trophy" color="#ffd700" :size="22" />
            </view>
            <text class="menu-title">我的成就</text>
            <view class="menu-action">
              <text v-if="hasNewBadge" class="badge-dot"></text>
              <svg-icon name="right-arrow" :size="14" color="#bbb" />
            </view>
          </view>
          
          <view class="menu-item" @click="navigateTo('/pages/vocabulary/favorites')">
            <view class="menu-icon favorites">
              <svg-icon name="star" color="#ff5722" :size="22" />
            </view>
            <text class="menu-title">我的收藏</text>
            <view class="menu-action">
              <svg-icon name="right-arrow" :size="14" color="#bbb" />
            </view>
          </view>
          
          <view class="menu-item" @click="navigateTo('/pages/profile/settings')">
            <view class="menu-icon settings">
              <svg-icon name="settings" color="#03a9f4" :size="22" />
            </view>
            <text class="menu-title">应用设置</text>
            <view class="menu-action">
              <svg-icon name="right-arrow" :size="14" color="#bbb" />
            </view>
          </view>

          <!-- 词汇管理 (仅管理员) -->
          <view class="menu-item" v-if="isAdmin" @click="navigateTo('/pages/admin/word-manage')">
            <view class="menu-icon test">
              <svg-icon name="settings" color="#9c27b0" :size="22" />
            </view>
            <text class="menu-title">词汇管理</text>
            <view class="menu-action">
              <svg-icon name="right-arrow" :size="14" color="#bbb" />
            </view>
          </view>
        </view>
      </view>
      
      <view class="learning-section">
        <view class="section-header">
          <text class="section-title">学习数据</text>
        </view>
        
        <view class="stats-card">
          <view class="card-header">
            <text class="card-title">本周学习情况</text>
          </view>
          
          <view class="calendar">
            <view 
              v-for="(day, index) in recentDays" 
              :key="index" 
              class="calendar-day"
              :class="{ active: day.isStudied, today: day.isToday }"
            >
              <text class="day-name">{{ day.name }}</text>
              <view class="day-dot"></view>
              <text class="day-count" v-if="day.isStudied">{{ day.count }}</text>
            </view>
          </view>
        </view>
      </view>
      
      <view class="about-section">
        <text class="app-version">英语学习 v1.0.0</text>
        <text class="copyright">© 2023 英语学习团队</text>
      </view>
    </view>
    <tab-bar :current="3"></tab-bar>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import badgeService from '../../services/badge'
import type { IBadge } from '../../services/badge'
import SvgIcon from '../../components/SvgIcon.vue'
import TabBar from '../../components/TabBar.vue'
import { getUserAvatarUrl } from '../../utils/avatar'

export default defineComponent({
  name: 'ProfilePage',
  components: {
    SvgIcon,
    TabBar
  },
  setup() {
    const store = useStore()
    
    // 用户信息
    const userInfo = computed(() => store.getters.userInfo)
    const uploadingAvatar = ref(false)

    const displayAvatar = computed(() => getUserAvatarUrl(userInfo.value?.avatar))
    
    // 是否管理员
    const isAdmin = computed(() => {
      const user = store.getters.userInfo;
      return user && user.roles && user.roles.includes('ROLE_ADMIN');
    })
    
    // 学习天数
    const learningStreak = computed(() => store.getters.learningStreak)
    
    // 已学单词数
    const wordsLearned = computed(() => {
      return store.state.learningProgress.dailyStats.reduce(
        (sum: number, day: any) => sum + day.wordsLearned, 0
      )
    })
    
    // 成就完成度
    const badgeCompletion = computed(() => badgeService.calculateBadgeCompletion(store))
    
    // 是否有新徽章
    const hasNewBadge = computed(() => {
      const badges = store.getters.userBadges || []
      if (badges.length === 0) return false
      
      // 检查是否有最近24小时内获得的徽章
      const now = new Date().getTime()
      return badges.some((badge: IBadge) => {
        if (!badge.dateEarned) return false
        const earnedTime = new Date(badge.dateEarned).getTime()
        return (now - earnedTime) < 24 * 60 * 60 * 1000
      })
    })
    
    // 最近7天学习记录
    const recentDays = computed(() => {
      const days = []
      const today = new Date()
      const dayNames = ['日', '一', '二', '三', '四', '五', '六']
      
      for (let i = 6; i >= 0; i--) {
        const date = new Date()
        date.setDate(today.getDate() - i)
        const dateStr = date.toISOString().split('T')[0]
        
        // 查找该日期的学习记录
        const dayRecord = store.state.learningProgress.dailyStats.find(
          (item: any) => item.date === dateStr
        )
        
        days.push({
          date: dateStr,
          name: dayNames[date.getDay()],
          isStudied: !!dayRecord,
          count: dayRecord ? dayRecord.wordsLearned : 0,
          isToday: i === 0
        })
      }
      
      return days
    })
    
    // 页面跳转
    const navigateTo = (url: string) => {
      uni.navigateTo({
        url
      })
    }
    
    // 修改头像
    const changeAvatar = () => {
      if (!store.getters.isLoggedIn) {
        uni.showToast({ title: '请先登录', icon: 'none' })
        return
      }
      uni.showActionSheet({
        itemList: ['从相册选择', '拍照'],
        success: (res) => {
          const sourceType = res.tapIndex === 0 ? ['album'] : ['camera'] as ('album' | 'camera')[]
          uni.chooseImage({
            count: 1,
            sizeType: ['compressed'],
            sourceType,
            success: async (chooseRes) => {
              const tempFilePath = chooseRes.tempFilePaths[0]
              uploadingAvatar.value = true
              uni.showLoading({ title: '上传中...' })
              try {
                await store.dispatch('uploadAvatar', tempFilePath)
                uni.showToast({ title: '头像已更新', icon: 'success' })
              } catch (error) {
                console.error('上传头像失败', error)
                uni.showToast({ title: '上传失败，请重试', icon: 'none' })
              } finally {
                uploadingAvatar.value = false
                uni.hideLoading()
              }
            }
          })
        }
      })
    }
    
    // 获取头像文本
    const getAvatarText = (nickname: string) => {
      if (!nickname || nickname.length === 0) return '未设置昵称'
      return nickname.slice(0, 2).toUpperCase()
    }
    
    return {
      userInfo,
      displayAvatar,
      uploadingAvatar,
      isAdmin,
      learningStreak,
      wordsLearned,
      badgeCompletion,
      hasNewBadge,
      recentDays,
      navigateTo,
      changeAvatar,
      getAvatarText
    }
  }
})
</script>

<style>
.page-container {
  min-height: 100vh;
  background-color: #f4f6f9;
}

.profile-container {
  padding: 30rpx 30rpx 110rpx 30rpx;
}

.user-card {
  background: linear-gradient(135deg, #ffffff, #fdfdfd);
  border-radius: 24rpx;
  padding: 40rpx 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.04);
  position: relative;
  overflow: hidden;
}

.user-card::before {
  content: '';
  position: absolute;
  top: -50rpx;
  right: -50rpx;
  width: 200rpx;
  height: 200rpx;
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.1), rgba(139, 195, 74, 0.05));
  border-radius: 50%;
  z-index: 0;
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 40rpx;
  position: relative;
  z-index: 1;
}

.avatar-wrap {
  position: relative;
  width: 160rpx;
  height: 160rpx;
  margin-bottom: 24rpx;
}

.avatar-image,
.avatar-placeholder {
  width: 160rpx;
  height: 160rpx;
  border-radius: 50%;
  border: 6rpx solid #ffffff;
  box-shadow: 0 8rpx 24rpx rgba(76, 175, 80, 0.2);
}

.avatar-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #4caf50, #8bc34a);
  color: white;
}

.avatar-wrap:active {
  opacity: 0.9;
}

.avatar-edit-badge {
  position: absolute;
  right: 4rpx;
  bottom: 4rpx;
  width: 40rpx;
  height: 40rpx;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2rpx solid #fff;
}

.avatar-text {
  font-size: 56rpx;
  font-weight: bold;
  color: white;
  text-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.2);
}

.nickname {
  font-size: 40rpx;
  font-weight: 800;
  color: #2c3e50;
  margin-bottom: 12rpx;
  letter-spacing: 2rpx;
}

.user-id {
  font-size: 26rpx;
  color: #7f8c8d;
  background-color: #f0f3f6;
  padding: 6rpx 20rpx;
  border-radius: 20rpx;
}

.stats-section {
  display: flex;
  justify-content: space-around;
  padding-top: 30rpx;
  border-top: 2rpx dashed #edf2f7;
  position: relative;
  z-index: 1;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.stat-value {
  font-size: 44rpx;
  font-weight: 900;
  color: #4caf50;
  margin-bottom: 10rpx;
  font-family: 'DIN Alternate', sans-serif;
}

.stat-label {
  font-size: 26rpx;
  color: #7f8c8d;
  font-weight: 500;
}

.menu-section, .learning-section {
  background-color: #ffffff;
  border-radius: 24rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.03);
}

.section-header {
  margin-bottom: 30rpx;
  display: flex;
  align-items: center;
}

.section-title {
  font-size: 34rpx;
  font-weight: 800;
  color: #2c3e50;
  position: relative;
  padding-left: 24rpx;
}

.section-title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  height: 28rpx;
  width: 8rpx;
  background: linear-gradient(to bottom, #4caf50, #8bc34a);
  border-radius: 6rpx;
}

.menu-list {
  display: flex;
  flex-direction: column;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 28rpx 0;
  border-bottom: 2rpx solid #f8f9fa;
  transition: background-color 0.2s;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-item:active {
  background-color: #fcfcfc;
}

.menu-icon {
  width: 52rpx;
  height: 52rpx;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 30rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.06);
}

.menu-icon.awards {
  background: linear-gradient(135deg, rgba(255, 215, 0, 0.15), rgba(255, 193, 7, 0.1));
  color: #ffc107;
}

.menu-icon.favorites {
  background: linear-gradient(135deg, rgba(255, 87, 34, 0.15), rgba(244, 67, 54, 0.1));
  color: #ff5722;
}

.menu-icon.settings {
  background: linear-gradient(135deg, rgba(3, 169, 244, 0.15), rgba(0, 188, 212, 0.1));
  color: #03a9f4;
}

.menu-icon.test {
  background: linear-gradient(135deg, rgba(156, 39, 176, 0.15), rgba(103, 58, 183, 0.1));
  color: #9c27b0;
}

.menu-title {
  flex: 1;
  font-size: 30rpx;
  color: #34495e;
  font-weight: 600;
}

.menu-action {
  display: flex;
  align-items: center;
  position: relative;
}

.badge-dot {
  width: 16rpx;
  height: 16rpx;
  background-color: #ff4757;
  border-radius: 50%;
  position: absolute;
  right: 40rpx;
  top: 50%;
  transform: translateY(-50%);
  box-shadow: 0 0 8rpx rgba(255, 71, 87, 0.5);
}

.stats-card {
  background-color: #fcfdfe;
  border-radius: 20rpx;
  padding: 30rpx;
  border: 2rpx solid #f0f3f6;
}

.card-header {
  margin-bottom: 24rpx;
}

.card-title {
  font-size: 28rpx;
  color: #7f8c8d;
  font-weight: 500;
}

.calendar {
  display: flex;
  justify-content: space-between;
}

.calendar-day {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

.day-name {
  font-size: 26rpx;
  color: #95a5a6;
  margin-bottom: 16rpx;
}

.day-dot {
  width: 20rpx;
  height: 20rpx;
  border-radius: 50%;
  background-color: #ecf0f1;
  transition: all 0.3s ease;
}

.calendar-day.active .day-dot {
  background-color: #4caf50;
  box-shadow: 0 0 10rpx rgba(76, 175, 80, 0.4);
}

.calendar-day.today .day-name {
  color: #4caf50;
  font-weight: bold;
}

.day-count {
  font-size: 22rpx;
  color: #4caf50;
  margin-top: 10rpx;
  font-weight: bold;
}

.about-section {
  text-align: center;
  padding: 40rpx 0 20rpx;
}

.app-version {
  font-size: 26rpx;
  color: #bdc3c7;
  margin-bottom: 12rpx;
  display: block;
  font-weight: 500;
}

.copyright {
  font-size: 24rpx;
  color: #bdc3c7;
}
</style> 