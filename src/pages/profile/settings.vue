<template>
  <view class="settings-container">
    <view class="header">
      <text class="title">鎼存梻鏁ょ拋鍓х枂</text>
    </view>
    
    <view class="settings-section">
      <view class="section-header">
        <text class="section-title">閸╃儤婀扮拋鍓х枂</text>
      </view>
      
      <view class="settings-list">
        <view class="settings-item">
          <view class="settings-icon theme">
            <svg-icon name="theme" color="#673ab7" :size="22" />
          </view>
          <text class="settings-title">娑撳顣界拋鍓х枂</text>
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
          <text class="settings-title">闂婅櫕鏅ュ鈧崗锟?</text>
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
          <text class="settings-title">閫氱煡鎻愰啋</text>
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
        <text class="section-title">鐎涳缚绡勭拋鍓х枂</text>
      </view>
      
      <view class="settings-list">
        <view class="settings-item">
          <view class="settings-icon target">
            <svg-icon name="target" color="#e91e63" :size="22" />
          </view>
          <text class="settings-title">濮ｅ繑妫╃€涳缚绡勯惄顔界垼</text>
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
          <text class="settings-title">姒涙ǹ顓婚梾鎯у</text>
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
        <text class="section-title">閺佺増宓佹稉搴ゅ閸欙拷</text>
      </view>
      
      <view class="settings-list">
        <view class="settings-item" @click="handleClearData">
          <view class="settings-icon clear">
            <svg-icon name="clear" color="#f44336" :size="22" />
          </view>
          <text class="settings-title">濞撳懘娅庣紓鎾崇摠</text>
          <view class="settings-action">
            <text class="action-text">{{ cacheSize }}</text>
          </view>
        </view>
        
        <view class="settings-item menu-item logout" @click="handleLogout">
          <view class="menu-icon">
            <svg-icon name="logout" color="#ff5252" :size="22" />
          </view>
          <text class="menu-title">闁偓閸戣櫣娅ヨぐ锟?</text>
        </view>
      </view>
    </view>
    
    <view class="about-section">
      <text class="app-version">閼昏精顕㈢€涳缚绡? v1.0.0</text>
      <text class="copyright">婕? 2023 閼昏精顕㈢€涳缚绡勯崶銏ゆЕ</text>
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
    
    // 娑撳顣界拋鍓х枂
    const themeOptions = ['濞村懓澹婂Ο鈥崇础', '濞ｈ精澹婂Ο鈥崇础', '鐠虹喖娈㈢化鑽ょ埠']
    const themeIndex = ref(0)
    
    // 鐎涳缚绡勯惄顔界垼鐠佸墽鐤?
    const targetOptions = ['10娑擃亜宕熺拠锟?/婢讹拷', '20娑擃亜宕熺拠锟?/婢讹拷', '30娑擃亜宕熺拠锟?/婢讹拷', '50娑擃亜宕熺拠锟?/婢讹拷']
    const targetIndex = ref(1) // 默认每天学习 20 个单词
    
    // 闂呮儳瀹崇拋鍓х枂
    const difficultyOptions = ['缁犫偓閸楋拷', '娑擃厾鐡?', '閸ヤ即姣?']
    const difficultyIndex = ref(1) // 姒涙ǹ顓绘稉顓犵搼闂呮儳瀹?
    
    // 瀵偓閸忓磭濮搁幀锟?
    const soundEnabled = ref(true)
    const notificationEnabled = ref(true)
    
    // 缂傛挸鐡ㄦ径褍鐨?
    const cacheSize = ref('2.5MB')
    
    // 閸掓繂顫愰崠鏍啎缂冿拷
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
    
    // 娑撳顣介弴瀛樻暭
    const handleThemeChange = (e: any) => {
      const index = e.detail.value
      themeIndex.value = index
      
      let theme = 'light'
      if (index === 1) theme = 'dark'
      else if (index === 2) theme = 'system'
      
      store.dispatch('updateUserSetting', { key: 'theme', value: theme })
    }
    
    // 闂婅櫕鏅ュ鈧崗铏纯閺€锟?
    const handleSoundChange = (e: any) => {
      const enabled = e.detail.value
      soundEnabled.value = enabled
      store.dispatch('updateUserSetting', { key: 'soundEnabled', value: enabled })
    }
    
    // 闁氨鐓″鈧崗铏纯閺€锟?
    const handleNotificationChange = (e: any) => {
      const enabled = e.detail.value
      notificationEnabled.value = enabled
      store.dispatch('updateUserSetting', { key: 'notificationEnabled', value: enabled })
    }
    
    // 鐎涳缚绡勯惄顔界垼閺囧瓨鏁?
    const handleTargetChange = (e: any) => {
      const index = e.detail.value
      targetIndex.value = index
      
      // 閺嶈宓佺槐銏犵穿閼惧嘲褰囬惄顔界垼閺侊拷
      const targetMap = [10, 20, 30, 50]
      const target = targetMap[index]
      
      store.dispatch('updateUserSetting', { key: 'dailyTarget', value: target })
    }
    
    // 闂呮儳瀹抽弴瀛樻暭
    const handleDifficultyChange = (e: any) => {
      const index = e.detail.value
      difficultyIndex.value = index
      
      // 鏍规嵁绱㈠紩鑾峰彇闅惧害
      const difficultyMap = ['easy', 'medium', 'hard']
      const difficulty = difficultyMap[index]
      
      store.dispatch('updateUserSetting', { key: 'defaultDifficulty', value: difficulty })
    }
    
    // 濞撳懘娅庣紓鎾崇摠
    const handleClearData = () => {
      uni.showModal({
        title: '濞撳懘娅庣紓鎾崇摠',
        content: '绾喖鐣剧憰浣圭闂勩倗绱︾€涙ɑ鏆熼幑顔兼偋閿涚喕绻栨稉宥勭窗瑜板崬鎼烽幃銊ф畱鐎涳缚绡勭拋鏉跨秿閵嗭拷',
        success: (res) => {
          if (res.confirm) {
            // 濡剝瀚欏〒鍛存珟缂傛挸鐡?
            uni.showLoading({
              title: '濞撳懘娅庢稉锟?...'
            })
            
            setTimeout(() => {
              uni.hideLoading()
              cacheSize.value = '0KB'
              uni.showToast({
                title: '缂傛挸鐡ㄥ鍙夌闂勶拷',
                icon: 'success'
              })
            }, 1000)
          }
        }
      })
    }
    
    // 闁偓閸戣櫣娅ヨぐ锟?
    const handleLogout = () => {
      uni.showModal({
        title: '闁偓閸戣櫣娅ヨぐ锟?',
        content: '绾喖鐣剧憰渚€鈧偓閸戝搫缍嬮崜宥堝閸欏嘲鎮ч敍锟?',
        success: async (res) => {
          if (res.confirm) {
            uni.showLoading({
              title: '闁偓閸戣桨鑵?...'
            });
            
            try {
              // 璋冪敤閫€鍑虹櫥褰昦ction
              await store.dispatch('logout');
              
              uni.hideLoading();
              uni.showToast({
                title: '瀹告煡鈧偓閸戣櫣娅ヨぐ锟?',
                icon: 'success'
              });
              
              // 鏉╂柨娲栭惂璇茬秿妞わ拷
              setTimeout(() => {
                uni.redirectTo({
                  url: '/pages/profile/login'
                });
              }, 1000);
            } catch (error) {
              uni.hideLoading();
              uni.showToast({
                title: '闁偓閸戝搫銇戠拹銉礉鐠囩兘鍣哥拠锟?',
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
