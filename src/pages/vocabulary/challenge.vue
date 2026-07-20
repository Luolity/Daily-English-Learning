<template>
  <view class="challenge-container">
    <view class="header">
      <text class="title">记忆挑战</text>
      <text class="score">得分: {{ score }}/{{ questions.length }}</text>
    </view>
    
    <view v-if="!isGameStarted" class="start-screen">
      <view class="start-card">
        <text class="start-title">单词记忆挑战</text>
        <text class="start-description">测试你的单词记忆能力，选择正确的中文释义</text>
        
        <view class="leaderboard-btn-container">
          <button class="leaderboard-btn" @click="goToLeaderboard">🏆 查看排行榜</button>
        </view>

        <view class="difficulty-selector">
          <text class="selector-label">选择难度:</text>
          <view class="selector-options">
            <view 
              class="difficulty-option" 
              :class="{ active: selectedDifficulty === 'easy' }"
              @click="selectedDifficulty = 'easy'"
            >
              <text>简单</text>
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
              <text>困难</text>
            </view>
          </view>
        </view>
        
        <view class="count-selector">
          <text class="selector-label">题目数量: {{ questionCount }}</text>
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
              <text class="option-label">时间限制</text>
              <switch :checked="enableTimeLimit" @change="onTimeLimitChange" color="#3cc51f" />
            </view>
            <view class="option-item">
              <text class="option-label">音频提示</text>
              <switch :checked="enableAudio" @change="onAudioChange" color="#3cc51f" />
            </view>
          </view>
        </view>
        
        <button class="start-btn" @click="startGame">开始挑战</button>
      </view>
    </view>
    
    <view v-else-if="isGameOver" class="result-screen">
      <view class="result-card">
        <text class="result-title">挑战结束!</text>
        <view class="result-stats">
          <view class="stat-item">
            <text class="stat-value">{{ score }}</text>
            <text class="stat-label">得分</text>
          </view>
          <view class="stat-item">
            <text class="stat-value">{{ Math.round((score / questions.length) * 100) }}%</text>
            <text class="stat-label">正确率</text>
          </view>
          <view class="stat-item">
            <text class="stat-value">{{ usedTime }}s</text>
            <text class="stat-label">用时</text>
          </view>
        </view>
        
        <view class="result-badge" :class="resultBadgeClass">
          <text class="badge-text">{{ resultBadgeText }}</text>
        </view>
        
        <view class="result-message">
          <text v-if="score === questions.length">太棒了! 完美答题!</text>
          <text v-else-if="score / questions.length >= 0.8">很好! 继续努力!</text>
          <text v-else-if="score / questions.length >= 0.6">不错! 再接再厉!</text>
          <text v-else>加油! 再试一次!</text>
        </view>
        
        <view class="result-actions">
          <button class="action-btn" @click="restartGame">再玩一次</button>
          <button class="action-btn" @click="backToHome">返回主页</button>
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
            <text>回答正确!</text>
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
          {{ isLastQuestion ? '查看结果' : '下一题' }}
        </button>
      </view>
      
      <view class="game-info">
        <view class="info-item">
          <text class="info-label">难度</text>
          <text class="info-value">{{ difficultyText }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">题目</text>
          <text class="info-value">{{ currentQuestionIndex + 1 }}/{{ questions.length }}</text>
        </view>
        <view v-if="enableTimeLimit" class="info-item">
          <text class="info-label">时间</text>
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
    
    // 游戏状态
    const isGameStarted = ref(false)
    const isGameOver = ref(false)
    const selectedDifficulty = ref(store.getters.defaultDifficulty || 'medium')
    const questionCount = ref(10)
    const enableTimeLimit = ref(true)
    const enableAudio = ref(true)
    
    // 问题相关
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
    
    // 当前问题
    const currentQuestion = computed(() => {
      return questions.value[currentQuestionIndex.value] || {
        word: '',
        phonetic: '',
        options: [],
        correctIndex: 0
      }
    })
    
    // 是否为最后一题
    const isLastQuestion = computed(() => {
      return currentQuestionIndex.value === questions.value.length - 1
    })
    
    // 是否回答正确
    const isCorrect = computed(() => {
      return selectedOptionIndex.value === currentQuestion.value.correctIndex
    })
    
    // 题目数量变化
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
    
    // 启动计时器
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
    
    // 重置计时器
    const resetTimer = () => {
      if (!enableTimeLimit.value) return;
      
      const timePerQuestion = calculateTimePerQuestion();
      timeLeft.value = timePerQuestion;
    }
    
    // 停止计时器
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
    
    // 开始游戏
    const startGame = async () => {
      try {
      // 需要足够单词生成干扰项，size 必须为整数
      const pageSize = Math.min(50, Math.max(questionCount.value + 10, questionCount.value * 3));
      
      await store.dispatch('fetchWordList', { 
        difficulty: selectedDifficulty.value,
        size: pageSize
      })
      
      const wordList = (store.state.vocabulary.wordList as IWordCard[])
        .filter((w) => w.word && w.translation)

      if (wordList.length < 4) {
        uni.showToast({
          title: '该难度下单词不足，请换难度或先添加单词',
          icon: 'none'
        })
        return
      }

      const availableWords = [...wordList]
      const selectedWords: IWordCard[] = []
      
      const targetCount = Math.min(questionCount.value, availableWords.length);
      if (targetCount < questionCount.value) {
        uni.showToast({
          title: `仅找到 ${targetCount} 个单词，将按实际数量出题`,
          icon: 'none'
        })
      }

      for (let i = 0; i < targetCount; i++) {
        const randomIndex = Math.floor(Math.random() * availableWords.length)
        selectedWords.push(availableWords[randomIndex])
        availableWords.splice(randomIndex, 1)
      }

      if (selectedWords.length === 0) {
        uni.showToast({ title: '无法生成题目', icon: 'none' })
        return
      }
      
      // 生成问题
      questions.value = selectedWords.map(word => {
        // 为每个问题生成3个错误选项
        const otherWords = wordList.filter((w: IWordCard) => w.id !== word.id)
        const wrongOptions: string[] = []
        
        // 随机选择3个不同的错误选项
        while (wrongOptions.length < 3 && otherWords.length > 0) {
          const randomIndex = Math.floor(Math.random() * otherWords.length)
          wrongOptions.push(otherWords[randomIndex].translation)
          otherWords.splice(randomIndex, 1)
        }
        
        // 确保即使单词数量不足，也能生成4个选项（可能包含重复选项）
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
            allOptions.push("选项" + (allOptions.length + 1))
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
      
      // 重置游戏状态
      currentQuestionIndex.value = 0
      selectedOptionIndex.value = -1
      showAnswer.value = false
      score.value = 0
      timeLeft.value = calculateTimePerQuestion()
      usedTime.value = 0
      startTime.value = Date.now()
      isGameStarted.value = true
      isGameOver.value = false
      
      // 启动计时器
      startTimer()
      
      // 播放当前单词音频
      if (questions.value.length > 0) {
        playWordAudio(questions.value[0].word)
      }
      } catch (error) {
        console.error('开始挑战失败', error)
        uni.showToast({ title: '开始挑战失败，请重试', icon: 'none' })
      }
    }
    
    // 选择选项
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
    
    // 下一题
    const nextQuestion = async () => {
      if (isLastQuestion.value) {
        // 游戏结束
        isGameOver.value = true
        stopTimer();
        
        // 提交挑战记录
        try {
          await api.challenge.submitRecord({
            score: score.value,
            totalQuestions: questions.value.length,
            accuracy: score.value / questions.value.length,
            timeSpent: usedTime.value
          });
        } catch (error) {
          console.error('挑战记录提交失败', error);
        }
      } else {
        // 进入下一题
        currentQuestionIndex.value++
        selectedOptionIndex.value = -1
        showAnswer.value = false
        
        // 重置计时器
        resetTimer();
        startTimer();
        
        // 播放当前单词音频
        playWordAudio(currentQuestion.value.word)
      }
    }
    
    // 重新开始游戏
    const restartGame = () => {
      isGameStarted.value = false
      isGameOver.value = false
      stopTimer();
    }
    
    // 返回主页
    const backToHome = () => {
      uni.switchTab({
        url: '/pages/index/index'
      })
    }
    
    // 前往排行榜
    const goToLeaderboard = () => {
      uni.navigateTo({
        url: '/pages/vocabulary/leaderboard'
      })
    }
    
    // 时间限制变化
    const onTimeLimitChange = (e: any) => {
      enableTimeLimit.value = e.detail.value
    }
    
    // 音频提示变化
    const onAudioChange = (e: any) => {
      enableAudio.value = e.detail.value
    }
    
    // 计算难度文本
    const difficultyText = computed(() => {
      switch (selectedDifficulty.value) {
        case 'easy':
          return '简单'
        case 'medium':
          return '中等'
        case 'hard':
          return '困难'
        default:
          return '未知'
      }
    })
    
    // 计算结果徽章
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
        return '完美'
      } else if (percentage >= 0.8) {
        return '良好'
      } else if (percentage >= 0.6) {
        return '一般'
      } else {
        return '较差'
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

/* 游戏界面 */
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

/* 结果界面 */
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
