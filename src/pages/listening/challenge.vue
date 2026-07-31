<template>
  <view class="challenge-container">
    <view class="header">
      <text class="title">听力挑战</text>
    </view>
    
    <view v-if="!isGameStarted" class="start-screen">
      <view class="start-card">
        <text class="start-icon">鍚?</text>
        <text class="start-title">听力理解挑战</text>
        <text class="start-description">鍚煶棰戯紝閫夋嫨姝ｇ‘鐨勭瓟妗?</text>
        
        <view class="difficulty-selector">
          <text class="selector-label">閫夋嫨闅惧害:</text>
          <view class="selector-options">
            <view 
              class="difficulty-option" 
              :class="{ active: selectedDifficulty === 'easy' }"
              @click="selectedDifficulty = 'easy'"
            >
              <text class="iconfont icon-star"></text>
              <text>绠€鍗?</text>
            </view>
            <view 
              class="difficulty-option" 
              :class="{ active: selectedDifficulty === 'medium' }"
              @click="selectedDifficulty = 'medium'"
            >
              <text class="iconfont icon-star"></text>
              <text class="iconfont icon-star"></text>
              <text>中等</text>
            </view>
            <view 
              class="difficulty-option" 
              :class="{ active: selectedDifficulty === 'hard' }"
              @click="selectedDifficulty = 'hard'"
            >
              <text class="iconfont icon-star"></text>
              <text class="iconfont icon-star"></text>
              <text class="iconfont icon-star"></text>
              <text>鍥伴毦</text>
            </view>
          </view>
        </view>
        
        <button class="start-btn" @click="startGame">
          <text>寮€濮嬫寫鎴?</text>
        </button>
      </view>
    </view>
    
    <view v-else-if="isGameOver" class="result-screen">
      <view class="result-card">
        <text class="result-title">鎸戞垬缁撴潫!</text>
        <view class="result-score">
          <text class="score-value">{{ score }}</text>
          <text class="score-total">/ {{ questions.length }}</text>
        </view>
        <text class="result-percentage">{{ Math.round((score / questions.length) * 100) }}%</text>
        
        <view class="result-message">
          <text v-if="score === questions.length"><text class="iconfont icon-badge"></text> 澶浜?! 瀹岀編绛旈!</text>
          <text v-else-if="score / questions.length >= 0.8"><text class="iconfont icon-check"></text> 很好! 继续努力!</text>
          <text v-else-if="score / questions.length >= 0.6"><text class="iconfont icon-info"></text> 涓嶉敊! 鍐嶆帴鍐嶅帀!</text>
          <text v-else><text class="iconfont icon-refresh"></text> 鍔犳补! 鍐嶈瘯涓€娆?!</text>
        </view>
        
        <view class="result-actions">
          <button class="action-btn" @click="restartGame">
            <text class="iconfont icon-refresh"></text>
            <text>鍐嶇帺涓€娆?</text>
          </button>
          <button class="action-btn" @click="backToHome">
            <text class="iconfont icon-right"></text>
            <text>杩斿洖</text>
          </button>
        </view>
      </view>
    </view>
    
    <view v-else class="game-screen">
      <view class="progress-bar">
        <view class="progress" :style="{ width: (currentQuestionIndex / questions.length) * 100 + '%' }"></view>
      </view>
      
      <view class="question-card">
        <text class="question-number">问题 {{ currentQuestionIndex + 1 }}/{{ questions.length }}</text>
        
        <view class="audio-player">
          <button class="play-btn" @click="playAudio">
            <text>{{ isPlaying ? '暂停' : '播放' }}</text>
          </button>
          <view class="progress-bar">
            <view class="progress" :style="{ width: audioProgress + '%' }"></view>
          </view>
          <text class="time">{{ formatTime(currentTime) }}/{{ formatTime(duration) }}</text>
        </view>
        
        <view class="question-text">
          <text>{{ currentQuestion.question }}</text>
        </view>
        
        <view class="options">
          <view 
            v-for="(option, index) in currentQuestion.options" 
            :key="index"
            class="option"
            :class="{
              selected: selectedOptionIndex === index,
              correct: showAnswer && index === currentQuestion.correctIndex,
              wrong: showAnswer && selectedOptionIndex === index && index !== currentQuestion.correctIndex
            }"
            @click="selectOption(index)"
          >
            <text>{{ option }}</text>
          </view>
        </view>
        
        <view v-if="showAnswer" class="answer-feedback">
          <view v-if="isCorrect" class="feedback correct">
            <text class="iconfont icon-check"></text>
            <text>鍥炵瓟姝ｇ‘!</text>
          </view>
          <view v-else class="feedback wrong">
            <text class="iconfont icon-close"></text>
            <text>回答错误!</text>
          </view>
          
          <view class="correct-answer">
            <text class="iconfont icon-info"></text>
            <text>正确答案: {{ currentQuestion.options[currentQuestion.correctIndex] }}</text>
          </view>
        </view>
        
        <button 
          v-if="!showAnswer" 
          class="submit-btn" 
          :disabled="selectedOptionIndex === -1"
          @click="submitAnswer"
        >
          <text class="iconfont icon-quiz"></text>
          <text>提交答案</text>
        </button>
        <button 
          v-else 
          class="next-btn"
          @click="nextQuestion"
        >
          <text class="iconfont" :class="isLastQuestion ? 'icon-chart' : 'icon-right'"></text>
          <text>{{ isLastQuestion ? '鏌ョ湅缁撴灉' : '涓嬩竴棰?' }}</text>
        </button>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onUnmounted } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'ListeningChallenge',
  setup() {
    const store = useStore()
    
    // 娓告垙鐘舵€?
    const isGameStarted = ref(false)
    const isGameOver = ref(false)
    const selectedDifficulty = ref('medium')
    
    // 问题鐩稿叧
    const questions = ref<Array<{
      audioUrl: string;
      question: string;
      options: string[];
      correctIndex: number;
    }>>([
      {
        audioUrl: 'https://example.com/audio/question1.mp3',
        question: '鏍规嵁鍚埌鐨勫唴瀹癸紝閫夋嫨姝ｇ‘鐨勬弿杩?',
        options: [
          '浠栦滑姝ｅ湪璁ㄨ涓€涓數褰?',
          '浠栦滑姝ｅ湪璁″垝涓€娆℃梾琛?',
          '他们正在谈论天气',
          '他们正在讨论工作'
        ],
        correctIndex: 1
      },
      {
        audioUrl: 'https://example.com/audio/question2.mp3',
        question: '女士最可能是什么职业？',
        options: [
          '鍖荤敓',
          '鏁欏笀',
          '宸ョ▼甯?',
          '鑹烘湳瀹?'
        ],
        correctIndex: 0
      },
      {
        audioUrl: 'https://example.com/audio/question3.mp3',
        question: '瀵硅瘽鍙戠敓鍦ㄥ摢閲岋紵',
        options: [
          '椁愬巺',
          '鍥句功棣?',
          '鍔炲叕瀹?',
          '鏈哄満'
        ],
        correctIndex: 3
      },
      {
        audioUrl: 'https://example.com/audio/question4.mp3',
        question: '鐢峰＋鎵撶畻鍋氫粈涔堬紵',
        options: [
          '璐拱鏂扮數鑴?',
          '修理他的电脑',
          '瀛︿範缂栫▼',
          '鎵句竴浠芥柊宸ヤ綔'
        ],
        correctIndex: 1
      },
      {
        audioUrl: 'https://example.com/audio/question5.mp3',
        question: '濂冲＋瀵逛粈涔堟劅鍒版媴蹇э紵',
        options: [
          '鑰冭瘯鎴愮哗',
          '杩熷埌',
          '澶╂皵鎯呭喌',
          '涓㈠け浜嗕笢瑗?'
        ],
        correctIndex: 2
      }
    ])
    const currentQuestionIndex = ref(0)
    const selectedOptionIndex = ref(-1)
    const showAnswer = ref(false)
    const score = ref(0)
    
    // 音频播放相关
    const isPlaying = ref(false)
    const audioProgress = ref(0)
    const currentTime = ref(0)
    const duration = ref(30) // 模拟音频时长
    let audioTimer: number | null = null
    
    // 褰撳墠问题
    const currentQuestion = computed(() => {
      return questions.value[currentQuestionIndex.value] || {
        audioUrl: '',
        question: '',
        options: [],
        correctIndex: 0
      }
    })
    
    // 鏄惁涓烘渶鍚庝竴棰?
    const isLastQuestion = computed(() => {
      return currentQuestionIndex.value === questions.value.length - 1
    })
    
    // 是否回答正确
    const isCorrect = computed(() => {
      return selectedOptionIndex.value === currentQuestion.value.correctIndex
    })
    
    // 寮€濮嬫父鎴?
    const startGame = () => {
      // 鏍规嵁闅惧害绛涢€夐棶棰?
      // 杩欓噷绠€鍖栧鐞嗭紝瀹為檯搴旇浠庢湇鍔″櫒鑾峰彇鎴栨牴鎹毦搴﹁繃婊?
      
      // 閲嶇疆娓告垙鐘舵€?
      currentQuestionIndex.value = 0
      selectedOptionIndex.value = -1
      showAnswer.value = false
      score.value = 0
      isGameStarted.value = true
      isGameOver.value = false
    }
    
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
    
    // 格式化时间
    const formatTime = (time: number) => {
      const minutes = Math.floor(time / 60)
      const seconds = Math.floor(time % 60)
      return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    }
    
    // 閫夋嫨閫夐」
    const selectOption = (index: number) => {
      if (!showAnswer.value) {
        selectedOptionIndex.value = index
      }
    }
    
    // 提交答案
    const submitAnswer = () => {
      showAnswer.value = true
      if (isCorrect.value) {
        score.value++
      }
    }
    
    // 涓嬩竴棰?
    const nextQuestion = () => {
      pauseAudio()
      currentTime.value = 0
      audioProgress.value = 0
      
      if (isLastQuestion.value) {
        // 娓告垙缁撴潫
        isGameOver.value = true
        
        // 鏇存柊瀛︿範杩涘害
        store.dispatch('updateProgress', {
          wordsLearned: 0,
          timeSpent: 10,
          correctCount: score.value,
          totalCount: questions.value.length
        })
      } else {
        // 杩涘叆涓嬩竴棰?
        currentQuestionIndex.value++
        selectedOptionIndex.value = -1
        showAnswer.value = false
      }
    }
    
    // 閲嶆柊寮€濮嬫父鎴?
    const restartGame = () => {
      isGameStarted.value = false
      isGameOver.value = false
    }
    
    // 杩斿洖涓婚〉
    const backToHome = () => {
      uni.navigateBack({
        delta: 1
      })
    }
    
    // 缁勪欢鍗歌浇鏃舵竻鐞嗗畾鏃跺櫒
    onUnmounted(() => {
      if (audioTimer) {
        clearInterval(audioTimer)
      }
    })
    
    return {
      isGameStarted,
      isGameOver,
      selectedDifficulty,
      questions,
      currentQuestionIndex,
      currentQuestion,
      selectedOptionIndex,
      showAnswer,
      score,
      isLastQuestion,
      isCorrect,
      isPlaying,
      audioProgress,
      currentTime,
      duration,
      startGame,
      playAudio,
      formatTime,
      selectOption,
      submitAnswer,
      nextQuestion,
      restartGame,
      backToHome
    }
  }
})
</script>

<style>
.challenge-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  padding: 30rpx;
  box-sizing: border-box;
  background-color: #f8f9fa;
}

.header {
  margin-bottom: 30rpx;
  display: flex;
  align-items: center;
}

.header .iconfont {
  font-size: 36rpx;
  color: #4caf50;
  margin-right: 15rpx;
}

.title {
  font-size: 42rpx;
  font-weight: bold;
  color: #333;
  letter-spacing: 1rpx;
}

/* 开始页面 */
.start-screen {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 30rpx 0;
}

.start-card {
  width: 100%;
  background-color: #fff;
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
}

.start-icon {
  font-size: 80rpx;
  color: #4caf50;
  margin-bottom: 20rpx;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.1); }
  100% { transform: scale(1); }
}

.start-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 15rpx;
  text-align: center;
}

.start-description {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 40rpx;
  text-align: center;
}

.difficulty-selector {
  width: 100%;
  margin-bottom: 50rpx;
}

.selector-label {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 20rpx;
  display: block;
  text-align: center;
  font-weight: bold;
}

.selector-options {
  display: flex;
  justify-content: center;
  gap: 20rpx;
}

.difficulty-option {
  padding: 15rpx 40rpx;
  border-radius: 40rpx;
  background-color: #f0f0f0;
  font-size: 28rpx;
  color: #666;
  transition: all 0.3s ease;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
}

.difficulty-option .iconfont {
  font-size: 24rpx;
  color: #ffc107;
  margin-right: 4rpx;
}

.difficulty-option.active {
  background-color: #4caf50;
  color: #fff;
  box-shadow: 0 4rpx 12rpx rgba(76, 175, 80, 0.2);
}

.difficulty-option.active .iconfont {
  color: #fff;
}

.start-btn {
  background: linear-gradient(to right, #4caf50, #8bc34a);
  color: #fff;
  border: none;
  border-radius: 40rpx;
  padding: 20rpx 80rpx;
  font-size: 32rpx;
  font-weight: bold;
  box-shadow: 0 6rpx 15rpx rgba(76, 175, 80, 0.2);
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.start-btn .iconfont {
  font-size: 28rpx;
  margin-right: 10rpx;
}

.start-btn:active {
  transform: translateY(3rpx);
  box-shadow: 0 3rpx 8rpx rgba(76, 175, 80, 0.2);
}

/* 娓告垙椤甸潰 */
.game-screen {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.progress-bar {
  height: 8rpx;
  background-color: #e0e0e0;
  border-radius: 4rpx;
  overflow: hidden;
  margin-bottom: 30rpx;
}

.progress {
  height: 100%;
  background: linear-gradient(to right, #4caf50, #8bc34a);
  transition: width 0.3s ease;
}

.question-card {
  flex: 1;
  background-color: #fff;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
}

.question-number {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 20rpx;
  align-self: flex-end;
}

.audio-player {
  display: flex;
  align-items: center;
  background-color: #f5f5f5;
  padding: 20rpx;
  border-radius: 15rpx;
  margin-bottom: 30rpx;
}

.play-btn {
  width: 90rpx;
  height: 90rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #4caf50, #8bc34a);
  color: #fff;
  margin-right: 20rpx;
  box-shadow: 0 4rpx 10rpx rgba(76, 175, 80, 0.3);
  border: none;
  flex-shrink: 0;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.play-btn::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: radial-gradient(circle, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0) 70%);
  border-radius: 50%;
}

.play-btn .iconfont {
  font-size: 50rpx;
  z-index: 2;
}

.play-btn:active {
  transform: scale(0.95);
  box-shadow: 0 2rpx 5rpx rgba(76, 175, 80, 0.2);
}

.audio-player .progress-bar {
  flex: 1;
  margin-bottom: 0;
  margin-right: 20rpx;
}

.time {
  font-size: 24rpx;
  color: #666;
  min-width: 120rpx;
  text-align: right;
}

.question-text {
  font-size: 32rpx;
  color: #333;
  font-weight: bold;
  margin-bottom: 30rpx;
  line-height: 1.5;
  padding: 0 20rpx;
}

.options {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  margin-bottom: 40rpx;
}

.option {
  padding: 25rpx 30rpx;
  border-radius: 15rpx;
  background-color: #f5f5f5;
  font-size: 28rpx;
  color: #333;
  transition: all 0.3s ease;
  position: relative;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}

.option:active {
  transform: translateY(2rpx);
}

.option.selected {
  background-color: rgba(76, 175, 80, 0.1);
  border: 2rpx solid #4caf50;
}

.option.correct {
  background-color: rgba(76, 175, 80, 0.2);
  border: 2rpx solid #4caf50;
}

.option.wrong {
  background-color: rgba(244, 67, 54, 0.1);
  border: 2rpx solid #f44336;
}

.answer-feedback {
  margin-bottom: 30rpx;
  animation: fadeIn 0.5s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20rpx); }
  to { opacity: 1; transform: translateY(0); }
}

.feedback {
  display: flex;
  align-items: center;
  padding: 20rpx;
  border-radius: 15rpx;
  margin-bottom: 20rpx;
}

.feedback.correct {
  background-color: rgba(76, 175, 80, 0.1);
  color: #4caf50;
  border-left: 8rpx solid #4caf50;
}

.feedback.wrong {
  background-color: rgba(244, 67, 54, 0.1);
  color: #f44336;
  border-left: 8rpx solid #f44336;
}

.feedback text {
  font-size: 28rpx;
  font-weight: bold;
}

.feedback .iconfont {
  font-size: 36rpx;
  margin-right: 15rpx;
}

.correct-answer {
  font-size: 26rpx;
  color: #666;
  padding: 15rpx 20rpx;
  background-color: #f5f5f5;
  border-radius: 10rpx;
  display: flex;
  align-items: center;
}

.correct-answer .iconfont {
  font-size: 26rpx;
  color: #2196f3;
  margin-right: 10rpx;
}

.submit-btn, .next-btn {
  padding: 25rpx 0;
  border-radius: 40rpx;
  font-size: 32rpx;
  font-weight: bold;
  border: none;
  box-shadow: 0 6rpx 15rpx rgba(0, 0, 0, 0.1);
  margin-top: auto;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.submit-btn .iconfont, .next-btn .iconfont {
  margin-right: 10rpx;
  font-size: 28rpx;
}

.submit-btn {
  background-color: #4caf50;
  color: #fff;
}

.submit-btn:active {
  transform: translateY(3rpx);
  box-shadow: 0 3rpx 8rpx rgba(76, 175, 80, 0.2);
}

.submit-btn[disabled] {
  background-color: #e0e0e0;
  color: #999;
  box-shadow: none;
}

.next-btn {
  background: linear-gradient(to right, #2196f3, #03a9f4);
  color: #fff;
}

.next-btn:active {
  transform: translateY(3rpx);
  box-shadow: 0 3rpx 8rpx rgba(33, 150, 243, 0.2);
}

/* 缁撴灉椤甸潰 */
.result-screen {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 30rpx 0;
}

.result-card {
  width: 100%;
  background-color: #fff;
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
}

.result-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 30rpx;
}

.result-score {
  display: flex;
  align-items: baseline;
  margin-bottom: 15rpx;
}

.score-value {
  font-size: 80rpx;
  font-weight: bold;
  color: #4caf50;
}

.score-total {
  font-size: 40rpx;
  color: #666;
  margin-left: 10rpx;
}

.result-percentage {
  font-size: 36rpx;
  color: #333;
  margin-bottom: 30rpx;
  font-weight: bold;
}

.result-message {
  font-size: 32rpx;
  color: #333;
  margin-bottom: 50rpx;
  text-align: center;
  line-height: 1.5;
}

.result-message text {
  font-size: 32rpx;
  color: #333;
  display: flex;
  align-items: center;
  justify-content: center;
}

.result-message .iconfont {
  margin-right: 10rpx;
  font-size: 36rpx;
  color: #4caf50;
}

.result-actions {
  display: flex;
  gap: 30rpx;
}

.action-btn {
  padding: 20rpx 60rpx;
  border-radius: 40rpx;
  font-size: 28rpx;
  font-weight: bold;
  border: none;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-btn .iconfont {
  margin-right: 10rpx;
  font-size: 28rpx;
}

.action-btn:first-child {
  background-color: #4caf50;
  color: #fff;
}

.action-btn:last-child {
  background-color: #f5f5f5;
  color: #666;
}

.action-btn:active {
  transform: translateY(3rpx);
  box-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.1);
}
</style> 
