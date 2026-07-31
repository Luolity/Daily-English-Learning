<template>
  <view class="page-container">
    <view class="vocabulary-container">
      <view class="header">
        <text class="title">鍗曡瘝瀛︿範</text>
        <view class="filter-container">
          <picker @change="onCategoryChange" :value="categoryIndex" :range="categories">
            <view class="picker">
              <text>鍒嗙被锛歿{ categories[categoryIndex] }}</text>
              <text class="iconfont icon-arrow-down"></text>
            </view>
          </picker>
          <picker @change="onDifficultyChange" :value="difficultyIndex" :range="difficulties">
            <view class="picker">
              <text>闅惧害锛歿{ difficulties[difficultyIndex] }}</text>
              <text class="iconfont icon-arrow-down"></text>
            </view>
          </picker>
        </view>
      </view>
      
      <view class="content">
        <view class="section">
          <view class="section-header">
            <text class="section-title">浠婃棩瀛︿範</text>
            <text class="section-subtitle">{{ dailyGoal.completed }}/{{ dailyGoal.total }} 涓崟璇?</text>
          </view>
          <view class="progress-bar">
            <view class="progress" :style="{ width: dailyGoal.percentage + '%' }"></view>
          </view>
        </view>
        
        <view class="section">
          <view class="section-header">
            <text class="section-title">瀛︿範妯″紡</text>
          </view>
          <view class="card-container">
            <view class="card" @click="navigateTo('/pages/vocabulary/wordcard')">
              <view class="card-image-placeholder wordcard-bg">
                <text class="placeholder-icon">馃摎</text>
              </view>
              <view class="card-content">
                <text class="card-title">鍗曡瘝鍗＄墖</text>
                <text class="card-description">閫氳繃鍗＄墖瀛︿範鍗曡瘝</text>
              </view>
            </view>
            <view class="card" @click="navigateTo('/pages/vocabulary/challenge')">
              <view class="card-image-placeholder challenge-bg">
                <text class="placeholder-icon">馃幆</text>
              </view>
              <view class="card-content">
                <text class="card-title">璁板繂鎸戞垬</text>
                <text class="card-description">閫氳繃娴嬮獙宸╁浐璁板繂</text>
              </view>
            </view>
          </view>
        </view>
        
        <view class="section">
          <view class="section-header">
            <text class="section-title">鎴戠殑鐢熻瘝鏈?</text>
            <text class="view-all" @click="navigateTo('/pages/vocabulary/favorites')">鏌ョ湅鍏ㄩ儴</text>
          </view>
          <view class="favorites-list">
            <view v-if="favoriteWords.length === 0" class="empty-favorites">
              <text>鏆傛棤鏀惰棌鍗曡瘝</text>
            </view>
            <view v-else class="word-item" v-for="word in favoriteWords.slice(0, 3)" :key="word.id">
              <view class="word-info">
                <text class="word">{{ word.word }}</text>
                <text class="phonetic">{{ word.phonetic }}</text>
              </view>
              <text class="translation">{{ word.translation }}</text>
            </view>
          </view>
        </view>
      </view>
    </view>
    <tab-bar :current="1"></tab-bar>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import TabBar from '../../components/TabBar.vue'

export default defineComponent({
  name: 'VocabularyIndex',
  components: {
    TabBar
  },
  setup() {
    const store = useStore()
    
    // 鍒嗙被閫夋嫨
    const categories = computed(() => ['鍏ㄩ儴', ...store.getters.categories])
    const categoryIndex = ref(0)
    const onCategoryChange = (e: any) => {
      categoryIndex.value = e.detail.value
      fetchWordList()
    }
    
    // 闅惧害閫夋嫨
    const difficulties = ref(['鍏ㄩ儴', '绠€鍗?', '涓瓑', '鍥伴毦'])
    const difficultyMap = ref<Record<number, string>>({
      0: '',
      1: 'easy',
      2: 'medium',
      3: 'hard'
    })
    const difficultyIndex = ref(0)
    const onDifficultyChange = (e: any) => {
      difficultyIndex.value = e.detail.value
      fetchWordList()
    }
    
    // 每日目标
    const dailyGoal = computed(() => {
      const completed = store.state.learningProgress.dailyStats.find(
        (item: any) => item.date === new Date().toISOString().split('T')[0]
      )?.wordsLearned || 0
      
      const total = store.getters.dailyTarget || 20
      const percentage = Math.min(Math.round((completed / total) * 100), 100)
      
      return {
        completed,
        total,
        percentage
      }
    })
    
    // 鏀惰棌鐨勫崟璇?
    const favoriteWords = computed(() => store.getters.favoriteWords)
    
    // 椤甸潰璺宠浆
    const navigateTo = (url: string) => {
      uni.navigateTo({
        url
      })
    }
    
    // 鑾峰彇鍗曡瘝鍒楄〃
    const fetchWordList = async () => {
      const category = categoryIndex.value === 0 ? undefined : categories.value[categoryIndex.value]
      const difficulty = difficultyMap.value[difficultyIndex.value] || undefined
      
      await store.dispatch('fetchWordList', { category, difficulty, page: 1, size: 20 })
    }
    
    onMounted(() => {
      fetchWordList()
    })
    
    return {
      categories,
      categoryIndex,
      onCategoryChange,
      difficulties,
      difficultyIndex,
      onDifficultyChange,
      dailyGoal,
      favoriteWords,
      navigateTo
    }
  }
})
</script>

<style>
.vocabulary-container {
  padding: 30rpx;
  padding-bottom: 110rpx;
}

.header {
  margin-bottom: 30rpx;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
}

.filter-container {
  display: flex;
  justify-content: space-between;
  margin-top: 20rpx;
}

.picker {
  background-color: #f5f5f5;
  padding: 15rpx 30rpx;
  border-radius: 10rpx;
  font-size: 28rpx;
  display: flex;
  align-items: center;
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

.section-subtitle {
  font-size: 26rpx;
  color: #666;
}

.view-all {
  font-size: 26rpx;
  color: #3cc51f;
}

.progress-bar {
  height: 20rpx;
  background-color: #f0f0f0;
  border-radius: 10rpx;
  overflow: hidden;
}

.progress {
  height: 100%;
  background-color: #3cc51f;
  transition: width 0.3s;
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
  border-radius: 0;
}

.wordcard-bg {
  background: linear-gradient(135deg, #4caf50, #8bc34a);
}

.challenge-bg {
  background: linear-gradient(135deg, #ff9800, #ffb74d);
}

.placeholder-icon {
  font-size: 80rpx;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 0 2rpx 5rpx rgba(0, 0, 0, 0.2);
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

.favorites-list {
  margin-top: 20rpx;
  background-color: #f9f9f9;
  border-radius: 12rpx;
  padding: 10rpx;
}

.word-item {
  padding: 20rpx;
  border-bottom: 1rpx solid #f0f0f0;
  background-color: #ffffff;
  border-radius: 10rpx;
  margin-bottom: 10rpx;
  box-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.03);
  transition: transform 0.2s ease;
}

.word-item:active {
  transform: scale(0.99);
}

.word-item:last-child {
  margin-bottom: 0;
  border-bottom: none;
}

.empty-favorites {
  text-align: center;
  padding: 40rpx 0;
  color: #999;
  font-size: 28rpx;
}

.word-info {
  display: flex;
  align-items: center;
  margin-bottom: 10rpx;
}

.word {
  font-size: 32rpx;
  font-weight: bold;
  margin-right: 20rpx;
  color: #333;
}

.phonetic {
  font-size: 24rpx;
  color: #999;
  font-style: italic;
}

.translation {
  font-size: 28rpx;
  color: #666;
}
</style> 