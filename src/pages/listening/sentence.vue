<template>
  <view class="sentence-container">
    <view class="header">
      <text class="title">句子听力</text>
    </view>
    
    <view class="content">
      <view class="sentence-card">
        <view class="card-header">
          <text class="sentence-number">句子 {{ currentIndex + 1 }}/{{ sentences.length }}</text>
          <view class="difficulty" :class="currentSentence.difficulty">
            <text>{{ difficultyText }}</text>
          </view>
        </view>
        
        <view class="audio-player">
          <button class="play-btn" @click="playAudio">
            <text>{{ isPlaying ? '暂停' : '播放' }}</text>
          </button>
          <view class="progress-bar">
            <view class="progress" :style="{ width: audioProgress + '%' }"></view>
          </view>
          <text class="time">{{ formatTime(currentTime) }}/{{ formatTime(duration) }}</text>
        </view>
        
        <view class="sentence-content">
          <text v-if="showTranscript" class="transcript">{{ currentSentence.text }}</text>
          <view v-else class="placeholder">
            <text>点击"显示文本"查看句子</text>
          </view>
        </view>
        
        <view class="translation" v-if="showTranslation">
          <text>{{ currentSentence.translation }}</text>
        </view>
        
        <view class="card-actions">
          <button class="action-btn" @click="toggleTranscript">
            {{ showTranscript ? '隐藏文本' : '显示文本' }}
          </button>
          <button class="action-btn" @click="toggleTranslation">
            {{ showTranslation ? '隐藏翻译' : '显示翻译' }}
          </button>
        </view>
      </view>
      
      <view class="controls">
        <button class="control-btn" @click="prevSentence" :disabled="currentIndex === 0">
          <text>上一句</text>
        </button>
        <button class="control-btn primary" @click="replayAudio">
          <text>重播</text>
        </button>
        <button class="control-btn" @click="nextSentence" :disabled="currentIndex === sentences.length - 1">
          <text>下一句</text>
        </button>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onUnmounted } from 'vue'

export default defineComponent({
  name: 'SentenceListening',
  setup() {
    // 模拟句子数据
    const sentences = ref([
      {
        id: '1',
        text: 'Learning a new language requires consistent practice and patience.',
        translation: '学习一门新语言需要持续的练习和耐心。',
        audioUrl: 'https://example.com/audio/sentence1.mp3',
        difficulty: 'easy'
      },
      {
        id: '2',
        text: 'The ability to speak multiple languages can open many doors in your career.',
        translation: '会说多种语言的能力可以为你的职业生涯打开许多大门。',
        audioUrl: 'https://example.com/audio/sentence2.mp3',
        difficulty: 'medium'
      },
      {
        id: '3',
        text: 'Despite the challenges, she persevered in her studies and eventually became fluent.',
        translation: '尽管面临挑战，她还是坚持学习，最终能够流利地使用这门语言。',
        audioUrl: 'https://example.com/audio/sentence3.mp3',
        difficulty: 'hard'
      },
      {
        id: '4',
        text: 'Immersion is one of the most effective ways to learn a language quickly.',
        translation: '沉浸式学习是快速学习语言的最有效方法之一。',
        audioUrl: 'https://example.com/audio/sentence4.mp3',
        difficulty: 'medium'
      },
      {
        id: '5',
        text: 'Regular listening practice can significantly improve your comprehension skills.',
        translation: '定期的听力练习可以显著提高你的理解能力。',
        audioUrl: 'https://example.com/audio/sentence5.mp3',
        difficulty: 'easy'
      }
    ])
    
    const currentIndex = ref(0)
    const currentSentence = computed(() => sentences.value[currentIndex.value])
    
    // 音频播放相关
    const isPlaying = ref(false)
    const audioProgress = ref(0)
    const currentTime = ref(0)
    const duration = ref(30) // 模拟音频时长，实际应从音频文件获取
    let audioTimer: number | null = null
    
    // 显示控制
    const showTranscript = ref(false)
    const showTranslation = ref(false)
    
    // 难度文本
    const difficultyText = computed(() => {
      const map: Record<string, string> = {
        easy: '简单',
        medium: '中等',
        hard: '困难'
      }
      return map[currentSentence.value.difficulty] || '中等'
    })
    
    // 播放音频
    const playAudio = () => {
      if (isPlaying.value) {
        // 暂停播放
        pauseAudio()
      } else {
        // 开始播放
        isPlaying.value = true
        
        // 这里模拟音频播放进度
        audioTimer = setInterval(() => {
          if (currentTime.value < duration.value) {
            currentTime.value += 0.1
            audioProgress.value = (currentTime.value / duration.value) * 100
          } else {
            pauseAudio()
          }
        }, 100) as unknown as number
        
        // 实际项目中应使用 uni.createInnerAudioContext() 播放音频
        uni.showToast({
          title: '正在播放音频',
          icon: 'none'
        })
      }
    }
    
    // 暂停音频
    const pauseAudio = () => {
      isPlaying.value = false
      if (audioTimer) {
        clearInterval(audioTimer)
        audioTimer = null
      }
    }
    
    // 重播音频
    const replayAudio = () => {
      pauseAudio()
      currentTime.value = 0
      audioProgress.value = 0
      playAudio()
    }
    
    // 格式化时间
    const formatTime = (time: number) => {
      const minutes = Math.floor(time / 60)
      const seconds = Math.floor(time % 60)
      return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    }
    
    // 切换显示文本
    const toggleTranscript = () => {
      showTranscript.value = !showTranscript.value
    }
    
    // 切换显示翻译
    const toggleTranslation = () => {
      showTranslation.value = !showTranslation.value
    }
    
    // 上一句
    const prevSentence = () => {
      if (currentIndex.value > 0) {
        pauseAudio()
        currentIndex.value--
        resetAudio()
      }
    }
    
    // 下一句
    const nextSentence = () => {
      if (currentIndex.value < sentences.value.length - 1) {
        pauseAudio()
        currentIndex.value++
        resetAudio()
      }
    }
    
    // 重置音频状态
    const resetAudio = () => {
      currentTime.value = 0
      audioProgress.value = 0
      showTranscript.value = false
    }
    
    // 组件卸载时清理定时器
    onUnmounted(() => {
      if (audioTimer) {
        clearInterval(audioTimer)
      }
    })
    
    return {
      sentences,
      currentIndex,
      currentSentence,
      isPlaying,
      audioProgress,
      currentTime,
      duration,
      showTranscript,
      showTranslation,
      difficultyText,
      playAudio,
      replayAudio,
      formatTime,
      toggleTranscript,
      toggleTranslation,
      prevSentence,
      nextSentence
    }
  }
})
</script>

<style>
.sentence-container {
  padding: 30rpx;
}

.header {
  margin-bottom: 30rpx;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
}

.content {
  display: flex;
  flex-direction: column;
  gap: 30rpx;
}

.sentence-card {
  background-color: #ffffff;
  border-radius: 15rpx;
  padding: 30rpx;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.sentence-number {
  font-size: 28rpx;
  color: #666;
}

.difficulty {
  padding: 8rpx 20rpx;
  border-radius: 30rpx;
  font-size: 24rpx;
}

.difficulty.easy {
  background-color: #e6f7e6;
  color: #3cc51f;
}

.difficulty.medium {
  background-color: #fff5e6;
  color: #ff9500;
}

.difficulty.hard {
  background-color: #ffebeb;
  color: #ff3b30;
}

.audio-player {
  display: flex;
  align-items: center;
  margin-bottom: 40rpx;
}

.play-btn {
  width: 80rpx;
  height: 80rpx;
  border-radius: 40rpx;
  background-color: #3cc51f;
  color: #ffffff;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 20rpx;
  padding: 0;
  line-height: 1;
}

.play-btn .iconfont {
  font-size: 40rpx;
}

.progress-bar {
  flex: 1;
  height: 10rpx;
  background-color: #f0f0f0;
  border-radius: 5rpx;
  margin-right: 20rpx;
  overflow: hidden;
}

.progress {
  height: 100%;
  background-color: #3cc51f;
  transition: width 0.1s linear;
}

.time {
  font-size: 24rpx;
  color: #999;
  width: 100rpx;
  text-align: right;
}

.sentence-content {
  background-color: #f9f9f9;
  border-radius: 10rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  min-height: 200rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.transcript {
  font-size: 32rpx;
  line-height: 1.6;
}

.placeholder {
  color: #999;
  font-size: 28rpx;
  text-align: center;
}

.translation {
  background-color: #f0f8ff;
  border-radius: 10rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  font-size: 30rpx;
  line-height: 1.6;
  color: #333;
}

.card-actions {
  display: flex;
  justify-content: space-around;
}

.action-btn {
  background-color: #f5f5f5;
  border: none;
  border-radius: 30rpx;
  padding: 15rpx 40rpx;
  font-size: 28rpx;
  color: #333;
}

.controls {
  display: flex;
  justify-content: space-between;
  margin-top: 20rpx;
}

.control-btn {
  flex: 1;
  margin: 0 10rpx;
  padding: 20rpx 0;
  font-size: 28rpx;
  border-radius: 10rpx;
  background-color: #f5f5f5;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
}

.control-btn .iconfont {
  margin: 0 10rpx;
}

.control-btn.primary {
  background-color: #3cc51f;
  color: #ffffff;
}

.control-btn[disabled] {
  opacity: 0.5;
}
</style> 
