<template>
  <view class="custom-tab-bar">
    <view 
      class="tab-item" 
      v-for="(item, index) in tabList" 
      :key="index"
      :class="{ active: current === index }"
      @click="switchTab(index, item.pagePath)"
    >
      <view class="icon-wrapper">
        <svg-icon :name="current === index ? item.activeIcon : item.icon" :color="current === index ? activeColor : color" :size="22" />
      </view>
      <text class="tab-text" :class="{ 'active-text': current === index }">{{ item.text }}</text>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue'
import SvgIcon from './SvgIcon.vue'

export default defineComponent({
  name: 'TabBar',
  components: {
    SvgIcon
  },
  props: {
    current: {
      type: Number,
      default: 0
    }
  },
  setup(props, { emit }) {
    const color = '#7A7E83'
    const activeColor = '#3cc51f'
    
    const tabList = [
      {
        pagePath: '/pages/index/index',
        icon: 'book',
        activeIcon: 'book',
        text: '首页'
      },
      {
        pagePath: '/pages/vocabulary/index',
        icon: 'target',
        activeIcon: 'target',
        text: '单词学习'
      },
      {
        pagePath: '/pages/listening/index',
        icon: 'headphone',
        activeIcon: 'headphone',
        text: '听力练习'
      },
      {
        pagePath: '/pages/profile/index',
        icon: 'settings',
        activeIcon: 'settings',
        text: '个人中心'
      }
    ]
    
    const switchTab = (index: number, path: string) => {
      if (index !== props.current) {
        uni.switchTab({
          url: path
        })
        emit('update:current', index)
      }
    }
    
    return {
      color,
      activeColor,
      tabList,
      switchTab
    }
  }
})
</script>

<style>
.custom-tab-bar {
  display: flex;
  width: 100%;
  height: 110rpx;
  background-color: #ffffff;
  box-shadow: 0 -2rpx 10rpx rgba(0, 0, 0, 0.05);
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 999;
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding-top: 10rpx;
}

.icon-wrapper {
  width: 40rpx;
  height: 40rpx;
  display: flex;
  justify-content: center;
  align-items: center;
}

.tab-text {
  font-size: 24rpx;
  color: #7A7E83;
  margin-top: 6rpx;
}

.active-text {
  color: #3cc51f;
}
</style> 