<template>
  <view class="settings-container">
    <view class="header">
      <text class="title">应用设置</text>
    </view>
    
    <view class="settings-section">
      <view class="section-header">
        <text class="section-title">基本设置</text>
      </view>
      
      <view class="settings-list">
        <view class="settings-item">
          <view class="settings-icon theme">
            <svg-icon name="theme" color="#673ab7" :size="22" />
          </view>
          <text class="settings-title">主题设置</text>
          <view class="settings-action">
            <picker 
              :value="themeIndex" 
              :range="themeOptions" 
              @change="handleThemeChange"
              class="settings-picker"
            >
              <text class="picker-text">{{ themeOptions[themeIndex] }}</text>
            </picker>
          </view>
        </view>
        
        <view class="settings-item">
          <view class="settings-icon sound">
            <svg-icon name="sound" color="#2196f3" :size="22" />
          </view>
          <text class="settings-title">音效开关</text>
          <view class="settings-action">
            <switch 
              :checked="soundEnabled" 
              @change="handleSoundChange"
              color="#4caf50"
            />
          </view>
        </view>
        
        <view class="settings-item">
          <view class="settings-icon notification">
            <svg-icon name="notification" color="#ff9800" :size="22" />
          </view>
          <text class="settings-title">通知提醒</text>
          <view class="settings-action">
            <switch 
              :checked="notificationEnabled" 
              @change="handleNotificationChange"
              color="#4caf50"
            />
          </view>
        </view>
      </view>
    </view>
    
    <view class="settings-section">
      <view class="section-header">
        <text class="section-title">学习设置</text>
      </view>
      
      <view class="settings-list">
        <view class="settings-item">
          <view class="settings-icon target">
            <svg-icon name="target" color="#e91e63" :size="22" />
          </view>
          <text class="settings-title">每日学习目标</text>
          <view class="settings-action">
            <picker 
              :value="targetIndex" 
              :range="targetOptions" 
              @change="handleTargetChange"
              class="settings-picker"
            >
              <text class="picker-text">{{ targetOptions[targetIndex] }}</text>
            </picker>
          </view>
        </view>
        
        <view class="settings-item">
          <view class="settings-icon difficulty">
            <svg-icon name="settings" color="#009688" :size="22" />
          </view>
          <text class="settings-title">默认难度</text>
          <view class="settings-action">
            <picker 
              :value="difficultyIndex" 
              :range="difficultyOptions" 
              @change="handleDifficultyChange"
              class="settings-picker"
            >
              <text class="picker-text">{{ difficultyOptions[difficultyIndex] }}</text>
            </picker>
          </view>
        </view>
      </view>
    </view>
    
    <view class="settings-section">
      <view class="section-header">
        <text class="section-title">数据与账号</text>
      </view>
      
      <view class="settings-list">
        <view class="settings-item" @click="handleClearData">
          <view class="settings-icon clear">
            <svg-icon name="clear" color="#f44336" :size="22" />
          </view>
          <text class="settings-title">清除缓存</text>
          <view class="settings-action">
            <text class="action-text">{{ cacheSize }}</text>
          </view>
        </view>
        
        <view class="settings-item menu-item logout" @click="handleLogout">
          <view class="menu-icon">
            <svg-icon name="logout" color="#ff5252" :size="22" />
          </view>
          <text class="menu-title">退出登录</text>
        </view>
      </view>
    </view>
    
    <view class="about-section">
      <text class="app-version">英语学习 v1.0.0</text>
      <text class="copyright">© 2023 英语学习团队</text>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import SvgIcon from '../../components/SvgIcon.vue'

export default defineComponent({
  name: 'SettingsPage',
  components: {
    SvgIcon
  },
  setup() {
    const store = useStore()
    
    // 主题设置
    const themeOptions = ['浅色模式', '深色模式', '跟随系统']
    const themeIndex = ref(0)
    
    // 学习目标设置
    const targetOptions = ['10个单词/天', '20个单词/天', '30个单词/天', '50个单词/天']
    const targetIndex = ref(1) // 默认20个单词/天
    
    // 难度设置
    const difficultyOptions = ['简单', '中等', '困难']
    const difficultyIndex = ref(1) // 默认中等难度
    
    // 开关状态
    const soundEnabled = ref(true)
    const notificationEnabled = ref(true)
    
    // 缓存大小
    const cacheSize = ref('2.5MB')
    
    // 初始化设置
    const initSettings = () => {
      const settings = store.getters.userSettings
      if (!settings) return

      if (settings.theme === 'light') themeIndex.value = 0
      else if (settings.theme === 'dark') themeIndex.value = 1
      else themeIndex.value = 2

      soundEnabled.value = settings.soundEnabled
      notificationEnabled.value = settings.notificationEnabled

      const targetMap = [10, 20, 30, 50]
      const targetIdx = targetMap.indexOf(settings.dailyTarget)
      if (targetIdx >= 0) targetIndex.value = targetIdx

      const difficultyMap = ['easy', 'medium', 'hard']
      const diffIdx = difficultyMap.indexOf(settings.defaultDifficulty)
      if (diffIdx >= 0) difficultyIndex.value = diffIdx
    }
    
    // 主题更改
    const handleThemeChange = (e: any) => {
      const index = e.detail.value
      themeIndex.value = index
      
      let theme = 'light'
      if (index === 1) theme = 'dark'
      else if (index === 2) theme = 'system'
      
      store.dispatch('updateUserSetting', { key: 'theme', value: theme })
    }
    
    // 音效开关更改
    const handleSoundChange = (e: any) => {
      const enabled = e.detail.value
      soundEnabled.value = enabled
      store.dispatch('updateUserSetting', { key: 'soundEnabled', value: enabled })
    }
    
    // 通知开关更改
    const handleNotificationChange = (e: any) => {
      const enabled = e.detail.value
      notificationEnabled.value = enabled
      store.dispatch('updateUserSetting', { key: 'notificationEnabled', value: enabled })
    }
    
    // 学习目标更改
    const handleTargetChange = (e: any) => {
      const index = e.detail.value
      targetIndex.value = index
      
      // 根据索引获取目标数
      const targetMap = [10, 20, 30, 50]
      const target = targetMap[index]
      
      store.dispatch('updateUserSetting', { key: 'dailyTarget', value: target })
    }
    
    // 难度更改
    const handleDifficultyChange = (e: any) => {
      const index = e.detail.value
      difficultyIndex.value = index
      
      // 根据索引获取难度
      const difficultyMap = ['easy', 'medium', 'hard']
      const difficulty = difficultyMap[index]
      
      store.dispatch('updateUserSetting', { key: 'defaultDifficulty', value: difficulty })
    }
    
    // 清除缓存
    const handleClearData = () => {
      uni.showModal({
        title: '清除缓存',
        content: '确定要清除缓存数据吗？这不会影响您的学习记录。',
        success: (res) => {
          if (res.confirm) {
            // 模拟清除缓存
            uni.showLoading({
              title: '清除中...'
            })
            
            setTimeout(() => {
              uni.hideLoading()
              cacheSize.value = '0KB'
              uni.showToast({
                title: '缓存已清除',
                icon: 'success'
              })
            }, 1000)
          }
        }
      })
    }
    
    // 退出登录
    const handleLogout = () => {
      uni.showModal({
        title: '退出登录',
        content: '确定要退出当前账号吗？',
        success: async (res) => {
          if (res.confirm) {
            uni.showLoading({
              title: '退出中...'
            });
            
            try {
              // 调用退出登录action
              await store.dispatch('logout');
              
              uni.hideLoading();
              uni.showToast({
                title: '已退出登录',
                icon: 'success'
              });
              
              // 返回登录页
              setTimeout(() => {
                uni.redirectTo({
                  url: '/pages/profile/login'
                });
              }, 1000);
            } catch (error) {
              uni.hideLoading();
              uni.showToast({
                title: '退出失败，请重试',
                icon: 'none'
              });
            }
          }
        }
      });
    }
    
    onMounted(() => {
      initSettings()
    })
    
    return {
      themeOptions,
      themeIndex,
      targetOptions,
      targetIndex,
      difficultyOptions,
      difficultyIndex,
      soundEnabled,
      notificationEnabled,
      cacheSize,
      handleThemeChange,
      handleSoundChange,
      handleNotificationChange,
      handleTargetChange,
      handleDifficultyChange,
      handleClearData,
      handleLogout
    }
  }
})
</script>

<style>
.settings-container {
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

.settings-section {
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.05);
}

.section-header {
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.settings-list {
  display: flex;
  flex-direction: column;
}

.settings-item {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.settings-item:last-child {
  border-bottom: none;
}

.settings-icon {
  width: 52rpx;
  height: 52rpx;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.settings-icon.theme {
  background-color: rgba(103, 58, 183, 0.1);
}

.settings-icon.sound {
  background-color: rgba(33, 150, 243, 0.1);
}

.settings-icon.notification {
  background-color: rgba(255, 152, 0, 0.1);
}

.settings-icon.target {
  background-color: rgba(233, 30, 99, 0.1);
}

.settings-icon.difficulty {
  background-color: rgba(0, 150, 136, 0.1);
}

.settings-icon.clear {
  background-color: rgba(244, 67, 54, 0.1);
}

.settings-icon.logout {
  background-color: rgba(96, 125, 139, 0.1);
}

.settings-title {
  flex: 1;
  font-size: 28rpx;
  color: #333;
}

.settings-action {
  display: flex;
  align-items: center;
}

.settings-picker {
  min-width: 180rpx;
}

.picker-text {
  font-size: 28rpx;
  color: #666;
  text-align: right;
}

.action-text {
  font-size: 28rpx;
  color: #999;
}

.about-section {
  text-align: center;
  padding: 30rpx 0;
}

.app-version {
  font-size: 24rpx;
  color: #999;
  margin-bottom: 10rpx;
  display: block;
}

.copyright {
  font-size: 22rpx;
  color: #999;
}
</style> 