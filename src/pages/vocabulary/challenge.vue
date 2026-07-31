<template>
  <view class="challenge-container">
    <view class="header">
      <text class="title">璁板繂鎸戞垬</text>
      <text class="score">寰楀垎: {{ score }}/{{ questions.length }}</text>
    </view>
    
    <view v-if="!isGameStarted" class="start-screen">
      <view class="start-card">
        <text class="start-title">鍗曡瘝璁板繂鎸戞垬</text>
        <text class="start-description">娴嬭瘯浣犵殑鍗曡瘝璁板繂鑳藉姏锛岄€夋嫨姝ｇ‘鐨勪腑鏂囬噴涔?</text>
        
        <view class="leaderboard-btn-container">
          <button class="leaderboard-btn" @click="goToLeaderboard">馃弳 鏌ョ湅鎺掕姒?</button>
        </view>

        <view class="difficulty-selector">
          <text class="selector-label">閫夋嫨闅惧害:</text>
          <view class="selector-options">
            <view 
              class="difficulty-option" 
              :class="{ active: selectedDifficulty === 'easy' }"
              @click="selectedDifficulty = 'easy'"
            >
              <text>绠€鍗?</text>
            </view>
            <view 
              class="difficulty-option" 
              :class="{ active: selectedDifficulty === 'medium' }"
              @click="selectedDifficulty = 'medium'"
            >
              <text>中等</text>
            </view>
            <view 
              class="difficulty-option" 
              :class="{ active: selectedDifficulty === 'hard' }"
              @click="selectedDifficulty = 'hard'"
            >
              <text>鍥伴毦</text>
            </view>
          </view>
        </view>
        
        <view class="count-selector">
          <text class="selector-label">棰樼洰鏁伴噺: {{ questionCount }}</text>
          <slider 
            :min="5" 
            :max="50" 
            :step="5" 
            :value="questionCount" 
            @change="onQuestionCountChange"
            show-value
            active-color="#4caf50"
            block-color="#3cc51f"
            block-size="28"
            class="custom-slider"
          />
          <view class="slider-labels">
            <text>5</text>
            <text>50</text>
          </view>
        </view>
        
        <view class="challenge-options">
          <view class="option-row">
            <view class="option-item">
              <text class="option-label">鏃堕棿闄愬埗</text>
              <switch :checked="enableTimeLimit" @change="onTimeLimitChange" color="#3cc51f" />
            </view>
            <view class="option-item">
              <text class="option-label">音频提示</text>
              <switch :checked="enableAudio" @change="onAudioChange" color="#3cc51f" />
            </view>
          </view>
        </view>
        
        <button class="start-btn" @click="startGame">寮€濮嬫寫鎴?</button>
      </view>
    </view>
    
    <view v-else-if="isGameOver" class="result-screen">
      <view class="result-card">
        <text class="result-title">鎸戞垬缁撴潫!</text>
        <view class="result-stats">
          <view class="stat-item">
            <text class="stat-value">{{ score }}</text>
            <text class="stat-label">寰楀垎</text>
          </view>
          <view class="stat-item">
            <text class="stat-value">{{ Math.round((score / questions.length) * 100) }}%</text>
            <text class="stat-label">姝ｇ‘鐜?</text>
          </view>
          <view class="stat-item">
            <text class="stat-value">{{ usedTime }}s</text>
            <text class="stat-label">鐢ㄦ椂</text>
          </view>
        </view>
        
        <view class="result-badge" :class="resultBadgeClass">
          <text class="badge-text">{{ resultBadgeText }}</text>
        </view>
        
        <view class="result-message">
          <text v-if="score === questions.length">澶浜?! 瀹岀編绛旈!</text>
          <text v-else-if="score / questions.length >= 0.8">很好! 继续努力!</text>
          <text v-else-if="score / questions.length >= 0.6">涓嶉敊! 鍐嶆帴鍐嶅帀!</text>
          <text v-else>鍔犳补! 鍐嶈瘯涓€娆?!</text>
        </view>
        
        <view class="result-actions">
          <button class="action-btn" @click="restartGame">鍐嶇帺涓€娆?</button>
          <button class="action-btn" @click="backToHome">杩斿洖涓婚〉</button>
        </view>
      </view>
    </view>
    
    <view v-else class="game-screen">
      <view class="progress-bar">
        <view class="progress" :style="{ width: (currentQuestionIndex / questions.length) * 100 + '%' }"></view>
      </view>
      
      <view class="question-card">
        <text class="question-number">问题 {{ currentQuestionIndex + 1 }}/{{ questions.length }}</text>
        <text class="question-word">{{ currentQuestion.word }}</text>
        <text class="question-phonetic">{{ currentQuestion.phonetic }}</text>
        
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
            <svg-icon name="check" color="#4caf50" :size="22" />
            <text>鍥炵瓟姝ｇ‘!</text>
          </view>
          <view v-else class="feedback wrong">
            <svg-icon name="close" color="#f44336" :size="22" />
            <text>回答错误!</text>
          </view>
          
          <view class="correct-answer">
            <text>正确答案: {{ currentQuestion.options[currentQuestion.correctIndex] }}</text>
          </view>
        </view>
        
        <button 
          v-if="!showAnswer" 
          class="submit-btn" 
          :disabled="selectedOptionIndex === -1"
          @click="submitAnswer"
        >
          提交答案
        </button>
        <button 
          v-else 
          class="next-btn"
          @click="nextQuestion"
        >
          {{ isLastQuestion ? '鏌ョ湅缁撴灉' : '涓嬩竴棰?' }}
        </button>
      </view>
      
      <view class="game-info">
        <view class="info-item">
          <text class="info-label">闅惧害</text>
          <text class="info-value">{{ difficultyText }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">棰樼洰</text>
          <text class="info-value">{{ currentQuestionIndex + 1 }}/{{ questions.length }}</text>
        </view>
        <view v-if="enableTimeLimit" class="info-item">
          <text class="info-label">鏃堕棿</text>
          <text class="info-value" :class="{ 'time-warning': timeLeft <= 10 }">{{ timeLeft }}s</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted, watch, onUnmounted } from 'vue'
import { useStore } from 'vuex'
import type { IWordCard } from '../../store/types'
import api from '../../services/api'
import SvgIcon from '../../components/SvgIcon.vue'

export default defineComponent({
  name: 'VocabularyChallenge',
  components: { SvgIcon },
  setup() {
    const store = useStore()
    
    // 娓告垙鐘舵€?
    const isGameStarted = ref(false)
    const isGameOver = ref(false)
    const selectedDifficulty = ref(store.getters.defaultDifficulty || 'medium')
    const questionCount = ref(10)
    const enableTimeLimit = ref(true)
    const enableAudio = ref(true)
    
    // 问题鐩稿叧
    const questions = ref<Array<{
      word: string;
      phonetic: string;
      options: string[];
      correctIndex: number;
    }>>([])
    const currentQuestionIndex = ref(0)
    const selectedOptionIndex = ref(-1)
    const showAnswer = ref(false)
    const score = ref(0)
    const timeLeft = ref(60)
    const usedTime = ref(0)
    const timerInterval = ref<number | null>(null)
    const startTime = ref<number>(0)
    
    // 褰撳墠问题
    const currentQuestion = computed(() => {
      return questions.value[currentQuestionIndex.value] || {
        word: '',
        phonetic: '',
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
    
    // 棰樼洰鏁伴噺鍙樺寲
    const onQuestionCountChange = (e: any) => {
      questionCount.value = e.detail.value
    }
    
    // 计算每题时间
    const calculateTimePerQuestion = (): number => {
      // 根据难度和题目数量计算每题时间
      const baseTime = selectedDifficulty.value === 'easy' ? 15 : 
                       selectedDifficulty.value === 'medium' ? 12 : 8;
      return baseTime;
    }
    
    // 鍚姩璁℃椂鍣?
    const startTimer = () => {
      startTime.value = Date.now();
      
      if (!enableTimeLimit.value) return;
      
      const timePerQuestion = calculateTimePerQuestion();
      timeLeft.value = timePerQuestion;
      
      clearInterval(Number(timerInterval.value));
      timerInterval.value = setInterval(() => {
        timeLeft.value--;
        
        if (timeLeft.value <= 0) {
          // 时间到，自动提交答案
          if (!showAnswer.value) {
            submitAnswer();
          }
        }
      }, 1000) as unknown as number;
    }
    
    // 閲嶇疆璁℃椂鍣?
    const resetTimer = () => {
      if (!enableTimeLimit.value) return;
      
      const timePerQuestion = calculateTimePerQuestion();
      timeLeft.value = timePerQuestion;
    }
    
    // 鍋滄璁℃椂鍣?
    const stopTimer = () => {
      if (timerInterval.value) {
        clearInterval(Number(timerInterval.value));
        timerInterval.value = null;
      }
    }
    
    // 播放单词音频
    const playWordAudio = (word: string) => {
      if (!enableAudio.value) return;
      
      // 实际项目中使用真实的音频API
      console.log(`播放单词: ${word}`);
      // const audio = uni.createInnerAudioContext();
      // audio.src = `https://dict.youdao.com/dictvoice?audio=${word}&type=2`;
      // audio.play();
    }
    
    // 寮€濮嬫父鎴?
    const startGame = async () => {
      try {
      // 闇€瑕佽冻澶熷崟璇嶇敓鎴愬共鎵伴」锛宻ize 蹇呴』涓烘暣鏁?
      const pageSize = Math.min(50, Math.max(questionCount.value + 10, questionCount.value * 3));
      
      await store.dispatch('fetchWordList', { 
        difficulty: selectedDifficulty.value,
        size: pageSize
      })
      
      const wordList = (store.state.vocabulary.wordList as IWordCard[])
        .filter((w) => w.word && w.translation)

      if (wordList.length < 4) {
        uni.showToast({
          title: '璇ラ毦搴︿笅鍗曡瘝涓嶈冻锛岃鎹㈤毦搴︽垨鍏堟坊鍔犲崟璇?',
          icon: 'none'
        })
        return
      }

      const availableWords = [...wordList]
      const selectedWords: IWordCard[] = []
      
      const targetCount = Math.min(questionCount.value, availableWords.length);
      if (targetCount < questionCount.value) {
        uni.showToast({
          title: `浠呮壘鍒? ${targetCount} 涓崟璇嶏紝灏嗘寜瀹為檯鏁伴噺鍑洪`,
          icon: 'none'
        })
      }

      for (let i = 0; i < targetCount; i++) {
        const randomIndex = Math.floor(Math.random() * availableWords.length)
        selectedWords.push(availableWords[randomIndex])
        availableWords.splice(randomIndex, 1)
      }

      if (selectedWords.length === 0) {
        uni.showToast({ title: '鏃犳硶鐢熸垚棰樼洰', icon: 'none' })
        return
      }
      
      // 鐢熸垚问题
      questions.value = selectedWords.map(word => {
        // 涓烘瘡涓棶棰樼敓鎴?3涓敊璇€夐」
        const otherWords = wordList.filter((w: IWordCard) => w.id !== word.id)
        const wrongOptions: string[] = []
        
        // 随机选择3个不同的错误选项
        while (wrongOptions.length < 3 && otherWords.length > 0) {
          const randomIndex = Math.floor(Math.random() * otherWords.length)
          wrongOptions.push(otherWords[randomIndex].translation)
          otherWords.splice(randomIndex, 1)
        }
        
        // 纭繚鍗充娇鍗曡瘝鏁伴噺涓嶈冻锛屼篃鑳界敓鎴?4涓€夐」锛堝彲鑳藉寘鍚噸澶嶉€夐」锛?
        const allOptions = [...wrongOptions]
        
        // 如果没有足够的错误选项，从wordList中随机选择（可能重复）
        while (allOptions.length < 3) {
          if (wordList.length > 0) {
            const randomIndex = Math.floor(Math.random() * wordList.length)
            // 确保不选择当前单词
            if (wordList[randomIndex].translation !== word.translation) {
              allOptions.push(wordList[randomIndex].translation)
            }
          } else {
            // 如果wordList为空，使用占位符
            allOptions.push("閫夐」" + (allOptions.length + 1))
          }
        }
        
        // 随机插入正确答案
        const correctIndex = Math.floor(Math.random() * 4)
        allOptions.splice(correctIndex, 0, word.translation)
        
        return {
          word: word.word,
          phonetic: word.phonetic,
          options: allOptions,
          correctIndex
        }
      })
      
      // 閲嶇疆娓告垙鐘舵€?
      currentQuestionIndex.value = 0
      selectedOptionIndex.value = -1
      showAnswer.value = false
      score.value = 0
      timeLeft.value = calculateTimePerQuestion()
      usedTime.value = 0
      startTime.value = Date.now()
      isGameStarted.value = true
      isGameOver.value = false
      
      // 鍚姩璁℃椂鍣?
      startTimer()
      
      // 播放当前单词音频
      if (questions.value.length > 0) {
        playWordAudio(questions.value[0].word)
      }
      } catch (error) {
        console.error('寮€濮嬫寫鎴樺け璐?', error)
        uni.showToast({ title: '寮€濮嬫寫鎴樺け璐ワ紝璇烽噸璇?', icon: 'none' })
      }
    }
    
    // 閫夋嫨閫夐」
    const selectOption = (index: number) => {
      if (!showAnswer.value) {
        selectedOptionIndex.value = index
      }
    }
    
    // 提交答案
    const submitAnswer = () => {
      stopTimer();
      showAnswer.value = true
      if (isCorrect.value) {
        score.value++
      }
      
      // 累加用时
      const currentQuestionTime = Math.round((Date.now() - startTime.value) / 1000);
      usedTime.value += currentQuestionTime;
    }
    
    // 涓嬩竴棰?
    const nextQuestion = async () => {
      if (isLastQuestion.value) {
        // 娓告垙缁撴潫
        isGameOver.value = true
        stopTimer();
        
        // 鎻愪氦鎸戞垬璁板綍
        try {
          await api.challenge.submitRecord({
            score: score.value,
            totalQuestions: questions.value.length,
            accuracy: score.value / questions.value.length,
            timeSpent: usedTime.value
          });
          await store.dispatch('updateProgress', {
            wordsLearned: questions.value.length,
            timeSpent: usedTime.value,
            correctCount: score.value,
            totalCount: questions.value.length
          });
        } catch (error) {
          console.error('鎸戞垬鏁版嵁鎻愪氦澶辫触', error);
        }
      } else {
        // 杩涘叆涓嬩竴棰?
        currentQuestionIndex.value++
        selectedOptionIndex.value = -1
        showAnswer.value = false
        
        // 閲嶇疆璁℃椂鍣?
        resetTimer();
        startTimer();
        
        // 播放当前单词音频
        playWordAudio(currentQuestion.value.word)
      }
    }
    
    // 閲嶆柊寮€濮嬫父鎴?
    const restartGame = () => {
      isGameStarted.value = false
      isGameOver.value = false
      stopTimer();
    }
    
    // 杩斿洖涓婚〉
    const backToHome = () => {
      uni.switchTab({
        url: '/pages/index/index'
      })
    }
    
    // 鍓嶅線鎺掕姒?
    const goToLeaderboard = () => {
      uni.navigateTo({
        url: '/pages/vocabulary/leaderboard'
      })
    }
    
    // 鏃堕棿闄愬埗鍙樺寲
    const onTimeLimitChange = (e: any) => {
      enableTimeLimit.value = e.detail.value
    }
    
    // 音频提示变化
    const onAudioChange = (e: any) => {
      enableAudio.value = e.detail.value
    }
    
    // 璁＄畻闅惧害鏂囨湰
    const difficultyText = computed(() => {
      switch (selectedDifficulty.value) {
        case 'easy':
          return '绠€鍗?'
        case 'medium':
          return '中等'
        case 'hard':
          return '鍥伴毦'
        default:
          return '未知'
      }
    })
    
    // 璁＄畻缁撴灉寰界珷
    const resultBadgeClass = computed(() => {
      const percentage = score.value / questions.value.length;
      if (percentage === 1) {
        return 'perfect'
      } else if (percentage >= 0.8) {
        return 'good'
      } else if (percentage >= 0.6) {
        return 'average'
      } else {
        return 'poor'
      }
    })
    
    const resultBadgeText = computed(() => {
      const percentage = score.value / questions.value.length;
      if (percentage === 1) {
        return '瀹岀編'
      } else if (percentage >= 0.8) {
        return '良好'
      } else if (percentage >= 0.6) {
        return '涓€鑸?'
      } else {
        return '杈冨樊'
      }
    })
    
    // 页面卸载时清除计时器
    onUnmounted(() => {
      stopTimer();
    })
    
    return {
      isGameStarted,
      isGameOver,
      selectedDifficulty,
      questionCount,
      questions,
      currentQuestionIndex,
      currentQuestion,
      selectedOptionIndex,
      showAnswer,
      score,
      isLastQuestion,
      isCorrect,
      onQuestionCountChange,
      startGame,
      selectOption,
      submitAnswer,
      nextQuestion,
      restartGame,
      backToHome,
      goToLeaderboard,
      enableTimeLimit,
      enableAudio,
      timeLeft,
      usedTime,
      onTimeLimitChange,
      onAudioChange,
      difficultyText,
      resultBadgeClass,
      resultBadgeText,
      playWordAudio
    }
  }
})
</script>

<style>
.challenge-container {
  padding: 30rpx;
  min-height: 100vh;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  background-color: #f8f9fa;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
}

.score {
  font-size: 32rpx;
  color: #4caf50;
  font-weight: bold;
  background-color: rgba(76, 175, 80, 0.1);
  padding: 8rpx 20rpx;
  border-radius: 30rpx;
}

/* 开始界面 */
.start-screen {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.start-card {
  background-color: #ffffff;
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  width: 100%;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
}

.start-title {
  font-size: 36rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
  text-align: center;
  color: #333;
}

.start-description {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 20rpx;
  text-align: center;
  line-height: 1.5;
}

.leaderboard-btn-container {
  display: flex;
  justify-content: center;
  margin-bottom: 40rpx;
}

.leaderboard-btn {
  background-color: #fff3e0;
  color: #ff9800;
  border: 1rpx solid #ffe0b2;
  border-radius: 30rpx;
  padding: 10rpx 40rpx;
  font-size: 28rpx;
  font-weight: bold;
  display: inline-flex;
  align-items: center;
  line-height: 1.5;
}

.difficulty-selector {
  margin-bottom: 40rpx;
}

.selector-label {
  font-size: 28rpx;
  margin-bottom: 20rpx;
  display: block;
  color: #333;
  font-weight: 500;
}

.selector-options {
  display: flex;
  justify-content: space-between;
  gap: 15rpx;
}

.difficulty-option {
  flex: 1;
  text-align: center;
  padding: 20rpx 0;
  background-color: #f5f5f5;
  border-radius: 12rpx;
  transition: all 0.2s ease;
  color: #666;
  font-size: 28rpx;
}

.difficulty-option.active {
  background-color: #4caf50;
  color: #ffffff;
  box-shadow: 0 2rpx 8rpx rgba(76, 175, 80, 0.3);
  font-weight: 500;
}

.count-selector {
  margin-bottom: 40rpx;
}

.custom-slider {
  margin: 20rpx 0;
}

.slider-labels {
  display: flex;
  justify-content: space-between;
  font-size: 24rpx;
  color: #999;
  margin-top: 10rpx;
}

.challenge-options {
  margin-bottom: 40rpx;
  background-color: #f5f5f5;
  border-radius: 12rpx;
  padding: 20rpx;
}

.option-row {
  display: flex;
  justify-content: space-between;
}

.option-item {
  display: flex;
  align-items: center;
  padding: 10rpx;
}

.option-label {
  margin-right: 20rpx;
  font-size: 28rpx;
  color: #333;
}

.start-btn {
  background: linear-gradient(135deg, #4caf50, #8bc34a);
  color: #ffffff;
  border: none;
  border-radius: 12rpx;
  padding: 25rpx 0;
  font-size: 32rpx;
  font-weight: 500;
  box-shadow: 0 4rpx 12rpx rgba(76, 175, 80, 0.3);
  transition: all 0.2s ease;
}

.start-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 2rpx 6rpx rgba(76, 175, 80, 0.2);
}

/* 娓告垙鐣岄潰 */
.game-screen {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.progress-bar {
  height: 10rpx;
  background-color: #f0f0f0;
  border-radius: 5rpx;
  margin-bottom: 30rpx;
  overflow: hidden;
}

.progress {
  height: 100%;
  background: linear-gradient(90deg, #4caf50, #8bc34a);
  transition: width 0.3s;
}

.question-card {
  background-color: #ffffff;
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  flex: 1;
  display: flex;
  flex-direction: column;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
}

.question-number {
  font-size: 28rpx;
  color: #999;
  margin-bottom: 30rpx;
}

.question-word {
  font-size: 48rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
  text-align: center;
  color: #333;
}

.question-phonetic {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 40rpx;
  text-align: center;
}

.options {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  margin-bottom: 40rpx;
}

.option {
  padding: 30rpx;
  background-color: #f5f5f5;
  border-radius: 12rpx;
  text-align: center;
  transition: all 0.2s ease;
  border: 2rpx solid transparent;
  color: #333;
  font-size: 30rpx;
}

.option:active {
  background-color: #e6f7e6;
}

.option.selected {
  background-color: #e6f7e6;
  border: 2rpx solid #4caf50;
}

.option.correct {
  background-color: #e6f7e6;
  border: 2rpx solid #4caf50;
  color: #4caf50;
  font-weight: 500;
}

.option.wrong {
  background-color: #ffebeb;
  border: 2rpx solid #ff3b30;
  color: #ff3b30;
  font-weight: 500;
}

.answer-feedback {
  margin-bottom: 30rpx;
}

.feedback {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20rpx;
  padding: 20rpx;
  border-radius: 12rpx;
}

.feedback.correct {
  background-color: #e6f7e6;
  color: #4caf50;
}

.feedback.wrong {
  background-color: #ffebeb;
  color: #ff3b30;
}

.feedback .iconfont {
  margin-right: 10rpx;
}

.correct-answer {
  text-align: center;
  font-size: 28rpx;
  color: #666;
  padding: 15rpx;
  background-color: #f5f5f5;
  border-radius: 10rpx;
}

.submit-btn, .next-btn {
  margin-top: auto;
  background: linear-gradient(135deg, #4caf50, #8bc34a);
  color: #ffffff;
  border: none;
  border-radius: 12rpx;
  padding: 25rpx 0;
  font-size: 32rpx;
  font-weight: 500;
  box-shadow: 0 4rpx 12rpx rgba(76, 175, 80, 0.3);
  transition: all 0.2s ease;
}

.submit-btn:active, .next-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 2rpx 6rpx rgba(76, 175, 80, 0.2);
}

.submit-btn[disabled] {
  background: #cccccc;
  box-shadow: none;
}

.game-info {
  display: flex;
  justify-content: space-around;
  margin-top: 30rpx;
  background-color: #f5f5f5;
  border-radius: 12rpx;
  padding: 15rpx;
}

.info-item {
  text-align: center;
  padding: 0 15rpx;
}

.info-label {
  font-size: 24rpx;
  color: #999;
  margin-bottom: 5rpx;
}

.info-value {
  font-size: 32rpx;
  font-weight: bold;
  color: #4caf50;
}

.time-warning {
  color: #ff3b30;
}

/* 缁撴灉鐣岄潰 */
.result-screen {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.result-card {
  background-color: #ffffff;
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  width: 100%;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
  text-align: center;
}

.result-title {
  font-size: 36rpx;
  font-weight: bold;
  margin-bottom: 30rpx;
  color: #333;
}

.result-stats {
  display: flex;
  justify-content: space-around;
  margin-bottom: 30rpx;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 48rpx;
  font-weight: bold;
  color: #4caf50;
  line-height: 1.2;
}

.stat-label {
  font-size: 24rpx;
  color: #999;
}

.result-badge {
  background-color: #4caf50;
  border-radius: 12rpx;
  padding: 15rpx 30rpx;
  margin: 0 auto 30rpx;
  display: inline-block;
}

.result-badge.perfect {
  background: linear-gradient(135deg, #8e24aa, #6a1b9a);
}

.result-badge.good {
  background: linear-gradient(135deg, #4caf50, #2e7d32);
}

.result-badge.average {
  background: linear-gradient(135deg, #ff9800, #ef6c00);
}

.result-badge.poor {
  background: linear-gradient(135deg, #f44336, #c62828);
}

.badge-text {
  font-size: 36rpx;
  font-weight: bold;
  color: #ffffff;
}

.result-message {
  font-size: 32rpx;
  color: #666;
  margin-bottom: 40rpx;
  line-height: 1.5;
}

.result-actions {
  display: flex;
  justify-content: space-around;
  gap: 20rpx;
}

.action-btn {
  flex: 1;
  background-color: #f5f5f5;
  border: none;
  border-radius: 12rpx;
  padding: 25rpx 0;
  font-size: 28rpx;
  color: #333;
  transition: all 0.2s ease;
}

.action-btn:first-child {
  background: linear-gradient(135deg, #4caf50, #8bc34a);
  color: #ffffff;
  box-shadow: 0 4rpx 12rpx rgba(76, 175, 80, 0.3);
}

.action-btn:first-child:active {
  transform: translateY(2rpx);
  box-shadow: 0 2rpx 6rpx rgba(76, 175, 80, 0.2);
}
</style> 
