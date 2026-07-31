<template>
  <view class="sentence-container">
    <view class="header">
      <text class="title">句子听力</text>
    </view>
    
    <view class="content">
      <view class="sentence-card">
        <view class="card-header">
          <text class="sentence-number">鍙ュ瓙 {{ currentIndex + 1 }}/{{ sentences.length }}</text>
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
            <text>鐐瑰嚮"鏄剧ず鏂囨湰"鏌ョ湅鍙ュ瓙</text>
          </view>
        </view>
        
        <view class="translation" v-if="showTranslation">
          <text>{{ currentSentence.translation }}</text>
        </view>
        
        <view class="card-actions">
          <button class="action-btn" @click="toggleTranscript">
            {{ showTranscript ? '闅愯棌鏂囨湰' : '鏄剧ず鏂囨湰' }}
          </button>
          <button class="action-btn" @click="toggleTranslation">
            {{ showTranslation ? '闅愯棌缈昏瘧' : '鏄剧ず缈昏瘧' }}
          </button>
        </view>
      </view>
      
      <view class="controls">
        <button class="control-btn" @click="prevSentence" :disabled="currentIndex === 0">
          <text>涓婁竴鍙?</text>
        </button>
        <button class="control-btn primary" @click="replayAudio">
          <text>閲嶆挱</text>
        </button>
        <button class="control-btn" @click="nextSentence" :disabled="currentIndex === sentences.length - 1">
          <text>涓嬩竴鍙?</text>
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
    // 妯℃嫙鍙ュ瓙鏁版嵁
    const sentences = ref([
      {
        id: '1',
        text: 'Learning a new language requires consistent practice and patience.',
        translation: '瀛︿範涓€闂ㄦ柊璇█闇€瑕佹寔缁殑缁冧範鍜岃€愬績銆?',
        audioUrl: 'https://example.com/audio/sentence1.mp3',
        difficulty: 'easy'
      },
      {
        id: '2',
        text: 'The ability to speak multiple languages can open many doors in your career.',
        translation: '浼氳澶氱璇█鐨勮兘鍔涘彲浠ヤ负浣犵殑鑱屼笟鐢熸动鎵撳紑璁稿澶ч棬銆?',
        audioUrl: 'https://example.com/audio/sentence2.mp3',
        difficulty: 'medium'
      },
      {
        id: '3',
        text: 'Despite the challenges, she persevered in her studies and eventually became fluent.',
        translation: '灏界闈复鎸戞垬锛屽ス杩樻槸鍧氭寔瀛︿範锛屾渶缁堣兘澶熸祦鍒╁湴浣跨敤杩欓棬璇█銆?',
        audioUrl: 'https://example.com/audio/sentence3.mp3',
        difficulty: 'hard'
      },
      {
        id: '4',
        text: 'Immersion is one of the most effective ways to learn a language quickly.',
        translation: '娌夋蹈寮忓涔犳槸蹇€熷涔犺瑷€鐨勬渶鏈夋晥鏂规硶涔嬩竴銆?',
        audioUrl: 'https://example.com/audio/sentence4.mp3',
        difficulty: 'medium'
      },
      {
        id: '5',
        text: 'Regular listening practice can significantly improve your comprehension skills.',
        translation: '瀹氭湡鐨勫惉鍔涚粌涔犲彲浠ユ樉钁楁彁楂樹綘鐨勭悊瑙ｈ兘鍔涖€?',
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
    const duration = ref(30) // 妯℃嫙闊抽鏃堕暱锛屽疄闄呭簲浠庨煶棰戞枃浠惰幏鍙?
    let audioTimer: number | null = null
    
    // 鏄剧ず鎺у埗
    const showTranscript = ref(false)
    const showTranslation = ref(false)
    
    // 闅惧害鏂囨湰
    const difficultyText = computed(() => {
      const map: Record<string, string> = {
        easy: '绠€鍗?',
        medium: '中等',
        hard: '鍥伴毦'
      }
      return map[currentSentence.value.difficulty] || '中等'
    })
    
    // 播放音频
    const playAudio = () => {
      if (isPlaying.value) {
        // 暂停播放
        pauseAudio()
      } else {
        // 寮€濮嬫挱鏀?
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
    
    // 鍒囨崲鏄剧ず鏂囨湰
    const toggleTranscript = () => {
      showTranscript.value = !showTranscript.value
    }
    
    // 鍒囨崲鏄剧ず缈昏瘧
    const toggleTranslation = () => {
      showTranslation.value = !showTranslation.value
    }
    
    // 涓婁竴鍙?
    const prevSentence = () => {
      if (currentIndex.value > 0) {
        pauseAudio()
        currentIndex.value--
        resetAudio()
      }
    }
    
    // 涓嬩竴鍙?
    const nextSentence = () => {
      if (currentIndex.value < sentences.value.length - 1) {
        pauseAudio()
        currentIndex.value++
        resetAudio()
      }
    }
    
    // 閲嶇疆闊抽鐘舵€?
    const resetAudio = () => {
      currentTime.value = 0
      audioProgress.value = 0
      showTranscript.value = false
    }
    
    // 缁勪欢鍗歌浇鏃舵竻鐞嗗畾鏃跺櫒
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
