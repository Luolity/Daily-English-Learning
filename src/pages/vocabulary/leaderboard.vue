<template>
  <view class="leaderboard-container">
    <view class="header">
      <text class="title">全站挑战排行榜</text>
    </view>
    
    <view class="leaderboard-list">
      <view class="leaderboard-item" v-for="(record, index) in leaderboard" :key="record.id">
        <view class="rank">
          <text v-if="index === 0" class="rank-icon gold">🥇</text>
          <text v-else-if="index === 1" class="rank-icon silver">🥈</text>
          <text v-else-if="index === 2" class="rank-icon bronze">🥉</text>
          <text v-else class="rank-number">{{ index + 1 }}</text>
        </view>
        <view class="user-info">
          <image :src="record.displayAvatar" class="avatar" mode="aspectFill"></image>
          <text class="nickname">{{ record.nickname || '匿名用户' }}</text>
        </view>
        <view class="score-info">
          <text class="score">{{ record.score }} 分</text>
          <text class="accuracy">正确率: {{ Math.round(record.accuracy * 100) }}%</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useStore } from 'vuex'
import api from '../../services/api'
import { getUserAvatarUrl } from '../../utils/avatar'

export default defineComponent({
  name: 'Leaderboard',
  setup() {
    const store = useStore()
    const leaderboard = ref<any[]>([])

    const mapRecord = (record: any) => {
      const currentUser = store.getters.userInfo
      const isSelf = currentUser?.id && String(record.userId) === String(currentUser.id)
      const avatar = isSelf ? currentUser.avatar : record.avatar
      return {
        ...record,
        nickname: isSelf ? (currentUser.nickname || record.nickname) : record.nickname,
        displayAvatar: getUserAvatarUrl(avatar)
      }
    }

    const fetchLeaderboard = async () => {
      try {
        const res = await api.challenge.getLeaderboard(20)
        const list = Array.isArray(res) ? res : (res?.data || res?.content || [])
        leaderboard.value = (list || []).map(mapRecord)
      } catch (error) {
        console.error('获取排行榜失败', error)
      }
    }

    onMounted(() => {
      fetchLeaderboard()
    })

    onShow(() => {
      fetchLeaderboard()
    })

    return {
      leaderboard
    }
  }
})
</script>

<style>
.leaderboard-container {
  padding: 30rpx;
  background-color: #f4f6f9;
  min-height: 100vh;
}

.header {
  margin-bottom: 40rpx;
  text-align: center;
  padding: 20rpx 0;
}

.title {
  font-size: 44rpx;
  font-weight: 800;
  color: #2c3e50;
  letter-spacing: 2rpx;
}

.leaderboard-list {
  background: #ffffff;
  border-radius: 24rpx;
  padding: 10rpx 30rpx;
  box-shadow: 0 10rpx 30rpx rgba(0,0,0,0.04);
}

.leaderboard-item {
  display: flex;
  align-items: center;
  padding: 30rpx 0;
  border-bottom: 2rpx solid #f0f3f6;
  transition: background-color 0.2s;
}

.leaderboard-item:last-child {
  border-bottom: none;
}

.rank {
  width: 80rpx;
  text-align: center;
}

.rank-icon {
  font-size: 50rpx;
}

.rank-number {
  font-size: 36rpx;
  font-weight: 900;
  color: #95a5a6;
  font-family: 'DIN Alternate', sans-serif;
}

.user-info {
  flex: 1;
  display: flex;
  align-items: center;
  margin-left: 20rpx;
}

.avatar {
  width: 90rpx;
  height: 90rpx;
  border-radius: 50%;
  margin-right: 24rpx;
  background-color: #ecf0f1;
  border: 4rpx solid #ffffff;
  box-shadow: 0 4rpx 10rpx rgba(0,0,0,0.05);
}

.nickname {
  font-size: 32rpx;
  font-weight: 600;
  color: #34495e;
}

.score-info {
  text-align: right;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.score {
  font-size: 38rpx;
  font-weight: 900;
  color: #4caf50;
  display: block;
  margin-bottom: 6rpx;
  font-family: 'DIN Alternate', sans-serif;
}

.accuracy {
  font-size: 24rpx;
  color: #7f8c8d;
  background-color: #f8f9fa;
  padding: 4rpx 12rpx;
  border-radius: 12rpx;
  display: inline-block;
}
</style>
