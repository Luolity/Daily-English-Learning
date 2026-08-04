<template>
  <view class="wordcard-container">
    <view class="header">
      <text class="title">{{ reviewMode ? '错题复习' : '单词卡片' }}</text>
      <view class="header-actions">
        <text class="progress">{{ wordList.length ? currentIndex + 1 : 0 }}/{{ wordList.length }}</text>
        <view v-if="!reviewMode" class="filter-btn" @click="showFilterModal = true">
          <text>筛选</text>
          <text class="icon-filter">🔍</text>
        </view>
      </view>
    </view>
    
    <!-- 加载状态 -->
    <view class="loading-container" v-if="isLoading">
      <view class="loading-spinner"></view>
      <text class="loading-text">加载中...</text>
    </view>
    
    <!-- 空数据状态 -->
    <view class="empty-container" v-else-if="wordList.length === 0">
      <text class="empty-icon">📚</text>
      <text class="empty-text">{{ reviewMode ? '暂无待复习错题' : '暂无单词数据' }}</text>
      <button class="reload-btn" @click="handleReload">重新加载</button>
    </view>
    
    <swiper v-else class="swiper" @change="onSwiperChange" :current="currentIndex">
      <swiper-item v-for="(word, index) in wordList" :key="word.id">
        <view class="card-wrapper">
          <view 
            class="card" 
            :class="{ 'is-flipped': flippedCards[index] }" 
            @click="flipCard(index)"
          >
            <view class="card-front">
              <view class="difficulty-indicator" :class="word.difficulty"></view>
              <text class="word">{{ word.word }}</text>
              <text class="phonetic">{{ word.phonetic }}</text>
              <text class="part-of-speech">{{ word.partOfSpeech }}</text>
              <view class="card-actions">
                <button class="action-btn sound-btn" @click.stop="playPronunciation(word)">
                  <text class="icon-sound">🔊</text>
                </button>
                <button 
                  class="action-btn favorite-btn" 
                  :class="{ 'is-favorite': isFavorite(word) }"
                  @click.stop="toggleFavorite(word)"
                >
                  <text class="icon-star">{{ isFavorite(word) ? '★' : '☆' }}</text>
                </button>
              </view>
              <text class="hint">点击卡片查看释义</text>
            </view>
            <view class="card-back">
              <view class="difficulty-indicator" :class="word.difficulty"></view>
              <text class="translation">{{ word.translation }}</text>
              <text class="definition">{{ word.definition }}</text>
              <view class="example-container">
                <text class="example-label">例句：</text>
                <text class="example">{{ word.example }}</text>
              </view>
              <view class="tags-container" v-if="word.categories && word.categories.length > 0">
                <text v-for="(category, idx) in word.categories" :key="idx" class="tag">{{ category }}</text>
                <text class="tag difficulty">{{ getDifficultyText(word.difficulty) }}</text>
              </view>
              <view class="card-actions">
                <button class="action-btn sound-btn" @click.stop="playPronunciation(word)">
                  <text class="icon-sound">🔊</text>
                </button>
                <button 
                  class="action-btn favorite-btn" 
                  :class="{ 'is-favorite': isFavorite(word) }"
                  @click.stop="toggleFavorite(word)"
                >
                  <text class="icon-star">{{ isFavorite(word) ? '★' : '☆' }}</text>
                </button>
              </view>
              <text class="hint">点击卡片返回</text>
            </view>
          </view>
        </view>
      </swiper-item>
    </swiper>
    
    <view v-if="wordList.length > 0" class="controls">
      <button class="control-btn prev-btn" @click="prevCard" :disabled="currentIndex === 0">
        <text class="icon-left">◀</text>
      </button>
      <button class="control-btn primary learn-btn" @click="markAsLearned" :class="{ 'learned': learnedWords[wordList[currentIndex]?.id] }">
        <text>{{ learnedWords[wordList[currentIndex]?.id] ? '已学习' : '标记为已学' }}</text>
      </button>
      <button class="control-btn next-btn" @click="nextCard" :disabled="currentIndex === wordList.length - 1">
        <text class="icon-right">▶</text>
      </button>
    </view>
    
    <!-- 分页控件 -->
    <view v-if="!reviewMode && wordList.length > 0" class="pagination">
      <view class="pagination-info">
        <text>第 {{ currentPage }}/{{ totalPages }} 页 · 每页 {{ pageSize }} 条 · 共 {{ totalItems }} 个单词</text>
      </view>
      <view class="pagination-controls">
        <button class="page-btn" @click="loadPage(1)" :disabled="currentPage === 1">
          <text>首页</text>
        </button>
        <button class="page-btn" @click="loadPage(currentPage - 1)" :disabled="currentPage === 1">
          <text>上一页</text>
        </button>
        <button class="page-btn" @click="loadPage(currentPage + 1)" :disabled="totalPages === 0 || currentPage >= totalPages">
          <text>下一页</text>
        </button>
        <button class="page-btn" @click="loadPage(totalPages)" :disabled="totalPages === 0 || currentPage >= totalPages">
          <text>末页</text>
        </button>
      </view>
    </view>
    
    <!-- 筛选弹窗 -->
    <view class="filter-modal" v-if="showFilterModal">
      <view class="modal-mask" @click="showFilterModal = false"></view>
      <view class="modal-content">
        <view class="modal-header">
          <text class="modal-title">筛选单词</text>
          <text class="modal-close" @click="showFilterModal = false">×</text>
        </view>
        
        <view class="modal-body">
          <view class="filter-section">
            <text class="filter-label">搜索</text>
            <input
              class="filter-search-input"
              v-model="searchKeyword"
              placeholder="输入单词或释义"
              confirm-type="search"
              @confirm="applyFilters"
            />
          </view>

          <view class="filter-section">
            <text class="filter-label">难度</text>
            <view class="filter-options">
              <view 
                v-for="difficulty in difficulties" 
                :key="difficulty.value"
                class="filter-option" 
                :class="{ active: selectedDifficulty === difficulty.value }"
                @click="selectedDifficulty = difficulty.value"
              >
                <text>{{ difficulty.label }}</text>
              </view>
            </view>
          </view>
          
          <view class="filter-section">
            <text class="filter-label">分类</text>
            <view class="filter-options wrap">
              <view 
                v-for="category in categories" 
                :key="category"
                class="filter-option" 
                :class="{ active: selectedCategory === category }"
                @click="selectedCategory = category === selectedCategory ? '' : category"
              >
                <text>{{ category }}</text>
              </view>
            </view>
          </view>
          
          <view class="filter-section">
            <text class="filter-label">显示</text>
            <view class="filter-options">
              <view 
                class="filter-option" 
                :class="{ active: showFavoritesOnly }"
                @click="showFavoritesOnly = !showFavoritesOnly"
              >
                <text>仅显示收藏</text>
              </view>
              <view 
                class="filter-option" 
                :class="{ active: hideLearnedWords }"
                @click="hideLearnedWords = !hideLearnedWords"
              >
                <text>隐藏已学单词</text>
              </view>
            </view>
          </view>
        </view>
        
        <view class="modal-footer">
          <button class="modal-btn" @click="resetFilters">重置</button>
          <button class="modal-btn primary" @click="applyFilters">应用</button>
        </view>
      </view>
    </view>
    
    <!-- 添加成功提示 -->
    <view class="toast" v-if="showToast">
      <view class="toast-content">
        <text class="toast-icon">{{ toastSuccess ? '✓' : '✗' }}</text>
        <text class="toast-message">{{ toastMessage }}</text>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted, watch } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useStore } from 'vuex'
import type { IWordCard } from '../../store/types'
import { api } from '../../services/api'
import { calcTotalPages } from '../../utils/pagination'

export default defineComponent({
  name: 'WordCard',
  setup() {
    const store = useStore()
    const wordList = ref<IWordCard[]>([])
    const currentIndex = ref(0)
    const flippedCards = ref<Record<number, boolean>>({})
    const learnedWords = ref<Record<string, boolean>>({})
    const reviewMode = ref(false)
    
    // 分页相关
    const currentPage = ref(1)
    const pageSize = ref(10)
    const totalItems = ref(0)
    const totalPages = ref(0)
    
    // 筛选相关
    const showFilterModal = ref(false)
    const selectedDifficulty = ref('')
    const selectedCategory = ref('')
    const searchKeyword = ref('')
    const showFavoritesOnly = ref(false)
    const hideLearnedWords = ref(false)
    const categories = computed(() => store.state.vocabulary.categories)
    const difficulties = [
      { label: '全部', value: '' },
      { label: '简单', value: 'easy' },
      { label: '中等', value: 'medium' },
      { label: '困难', value: 'hard' }
    ]
    
    // 提示相关
    const showToast = ref(false)
    const toastMessage = ref('')
    const toastSuccess = ref(true)
    const toastTimer = ref<number | null>(null)
    
    // 音频播放器
    let audioContext: any = null
    
    // 加载状态
    const isLoading = ref(false)
    
    const getFilterParams = () => ({
      category: selectedCategory.value || undefined,
      difficulty: selectedDifficulty.value || undefined,
      keyword: searchKeyword.value.trim() || undefined
    })

    // 加载指定页码的数据：先查单词总数，再按 totalItems 计算总页数
    const loadPage = async (page: number): Promise<void> => {
      if (page < 1) return;
      
      isLoading.value = true;
      try {
        const filters = getFilterParams();

        const countRes = await api.wordCards.getWordCardCount(
          filters.category,
          filters.difficulty,
          filters.keyword
        );

        const response = await store.dispatch('fetchWordList', {
          ...filters,
          page: page,
          size: pageSize.value
        });
        
        if (response && typeof response === 'object') {
          wordList.value = response.content || [];
          const total = Math.max(countRes.totalItems, response.totalItems ?? 0);
          totalItems.value = total;
          totalPages.value = calcTotalPages(total, pageSize.value);

          if (totalPages.value > 0 && page > totalPages.value) {
            return loadPage(totalPages.value);
          }

          currentPage.value = page;
          currentIndex.value = 0;
          flippedCards.value = {};
        }
        
        console.log(`每页${pageSize.value}条，共${totalItems.value}个单词，${totalPages.value}页，当前第${page}页`);
      } catch (error) {
        console.error('加载分页数据失败:', error);
        uni.showToast({
          title: '加载分页数据失败',
          icon: 'none'
        });
      } finally {
        isLoading.value = false;
      }
    };

    // 加载当前用户的错题
    const loadWrongWords = async () => {
      isLoading.value = true
      try {
        wordList.value = await api.wrongWords.getWrongWords()
        totalItems.value = wordList.value.length
        totalPages.value = wordList.value.length > 0 ? 1 : 0
        currentPage.value = 1
        currentIndex.value = 0
        flippedCards.value = {}
      } catch (error) {
        console.error('加载错题失败:', error)
        uni.showToast({
          title: '加载错题失败',
          icon: 'none'
        })
      } finally {
        isLoading.value = false
      }
    }
    
    // 应用筛选
    const applyFilters = async () => {
      try {
        isLoading.value = true;
        console.log('应用筛选，重置到第一页');
        
        // 重置到第一页
        await loadPage(1);
        
        // 关闭筛选弹窗
        showFilterModal.value = false;
      } catch (error) {
        console.error('筛选单词时出错:', error);
        uni.showToast({
          title: '筛选单词时出错',
          icon: 'none'
        });
      } finally {
        isLoading.value = false;
      }
    }
    
    // 重置筛选
    const resetFilters = () => {
      selectedDifficulty.value = ''
      selectedCategory.value = ''
      searchKeyword.value = ''
      showFavoritesOnly.value = false
      hideLearnedWords.value = false
    }
    
    // 翻转卡片
    const flipCard = (index: number) => {
      flippedCards.value[index] = !flippedCards.value[index]
    }
    
    // 切换收藏状态
    const toggleFavorite = async (word: IWordCard) => {
      if (isFavorite(word)) {
        await store.dispatch('removeFromFavorites', word.id)
        showToastMessage('已从生词本移除', false)
      } else {
        await store.dispatch('addToFavorites', word)
        showToastMessage('已添加到生词本', true)
      }
      // 自动刷新生词本
      store.dispatch('fetchFavorites')
    }
    
    // 显示提示信息
    const showToastMessage = (message: string, success: boolean = true) => {
      // 清除之前的定时器
      if (toastTimer.value) {
        clearTimeout(toastTimer.value)
      }
      
      // 显示新提示
      toastMessage.value = message
      toastSuccess.value = success
      showToast.value = true
      
      // 设置自动隐藏
      toastTimer.value = setTimeout(() => {
        showToast.value = false
      }, 2000) as unknown as number
    }
    
    // 检查是否已收藏
    const isFavorite = (word: IWordCard) => {
      return store.getters.favoriteWords.some((item: IWordCard) => item.id === word.id)
    }
    
    // 获取难度文本
    const getDifficultyText = (difficulty: string) => {
      switch (difficulty) {
        case 'easy': return '简单'
        case 'medium': return '中等'
        case 'hard': return '困难'
        default: return difficulty
      }
    }
    
    // 播放发音
    const playPronunciation = (word: IWordCard) => {
      try {
        if (audioContext) {
          audioContext.stop()
        }
        
        audioContext = uni.createInnerAudioContext()
        audioContext.src = `https://dict.youdao.com/dictvoice?audio=${word.word}&type=2`
        audioContext.autoplay = true
        
        audioContext.onPlay(() => {
          console.log('音频开始播放')
        })
        
        audioContext.onError((res: any) => {
          console.error('音频播放失败:', res.errMsg)
          uni.showToast({
            title: '音频播放失败',
            icon: 'none'
          })
        })
      } catch (error) {
        console.error('播放发音错误:', error)
        uni.showToast({
          title: `正在播放: ${word.word}`,
          icon: 'none'
        })
      }
    }
    
    // 滑动切换卡片
    const onSwiperChange = (e: any) => {
      currentIndex.value = e.detail.current
    }
    
    // 下一张卡片
    const nextCard = () => {
      if (currentIndex.value < wordList.value.length - 1) {
        currentIndex.value++
      }
    }
    
    // 上一张卡片
    const prevCard = () => {
      if (currentIndex.value > 0) {
        currentIndex.value--
      }
    }
    
    // 标记为已学
    const markAsLearned = async () => {
      const currentWord = wordList.value[currentIndex.value]
      if (currentWord && !learnedWords.value[currentWord.id]) {
        learnedWords.value[currentWord.id] = true

        if (reviewMode.value) {
          try {
            await api.wrongWords.removeWrongWord(currentWord.id)
          } catch (error) {
            delete learnedWords.value[currentWord.id]
            console.error('移除错题失败:', error)
            uni.showToast({
              title: '移除错题失败',
              icon: 'none'
            })
            return
          }

          store.dispatch('updateProgress', {
            wordsLearned: 1,
            timeSpent: 1,
            correctCount: 0,
            totalCount: 0
          })
          wordList.value.splice(currentIndex.value, 1)
          totalItems.value = wordList.value.length
          totalPages.value = wordList.value.length > 0 ? 1 : 0
          if (currentIndex.value >= wordList.value.length) {
            currentIndex.value = Math.max(wordList.value.length - 1, 0)
          }
          flippedCards.value = {}
          showToastMessage('已完成复习，错题已移除', true)
          return
        }

        // 更新学习进度
        store.dispatch('updateProgress', {
          wordsLearned: 1,
          timeSpent: 1,
          correctCount: 0,
          totalCount: 0
        })
        
        showToastMessage('已标记为学习完成', true)
        
        // 如果设置了隐藏已学单词，则重新筛选
        if (hideLearnedWords.value) {
          // 延迟执行，让用户看到提示
          setTimeout(() => {
            applyFilters()
          }, 1000)
        } else {
          // 自动前进到下一张卡片
          nextCard()
        }
      }
    }
    
    // 获取单词列表
    const fetchWordList = async () => {
      try {
        isLoading.value = true
        // 使用分页加载第一页数据
        await loadPage(1);
      } catch (error) {
        console.error('获取单词列表失败:', error);
        // 使用模拟数据作为备选
        wordList.value = getMockWordCards();
        uni.showToast({
          title: '加载单词列表失败，使用本地数据',
          icon: 'none'
        });
      } finally {
        isLoading.value = false
      }
    }
    
    // 模拟单词数据，用于API失败时的备选
    const getMockWordCards = (): IWordCard[] => {
      return [
        {
          id: '1',
          word: 'hello',
          translation: '你好',
          phonetic: '/həˈloʊ/',
          partOfSpeech: 'n. & int.',
          definition: 'used as a greeting',
          example: 'Hello, how are you today?',
          difficulty: 'easy',
          categories: ['CET4']
        },
        {
          id: '2',
          word: 'world',
          translation: '世界',
          phonetic: '/wɜːrld/',
          partOfSpeech: 'n.',
          definition: 'the earth, together with all of its countries and peoples',
          example: 'He wants to travel around the world.',
          difficulty: 'easy',
          categories: ['CET4']
        },
        {
          id: '3',
          word: 'vocabulary',
          translation: '词汇',
          phonetic: '/vəˈkæbjəˌleri/',
          partOfSpeech: 'n.',
          definition: 'all the words known and used by a particular person',
          example: 'Reading helps to increase your vocabulary.',
          difficulty: 'medium',
          categories: ['CET6']
        }
      ];
    }
    
    // 重新加载数据
    const handleReload = () => {
      if (reviewMode.value) {
        loadWrongWords()
        return
      }
      fetchWordList()
    }

    onLoad((query) => {
      reviewMode.value = query?.mode === 'review'
    })
    
    // 组件卸载时释放资源
    onMounted(() => {
      console.log('单词卡片组件已挂载');
      
      if (reviewMode.value) {
        loadWrongWords()
      } else {
        fetchWordList()
      }
      
      // 返回清理函数
      return () => {
        if (audioContext) {
          audioContext.destroy();
        }
        if (toastTimer.value) {
          clearTimeout(toastTimer.value);
        }
      }
    })
    
    return {
      wordList,
      currentIndex,
      flippedCards,
      learnedWords,
      reviewMode,
      showFilterModal,
      selectedDifficulty,
      selectedCategory,
      searchKeyword,
      showFavoritesOnly,
      hideLearnedWords,
      categories,
      difficulties,
      showToast,
      toastMessage,
      toastSuccess,
      flipCard,
      toggleFavorite,
      isFavorite,
      getDifficultyText,
      playPronunciation,
      onSwiperChange,
      nextCard,
      prevCard,
      markAsLearned,
      applyFilters,
      resetFilters,
      isLoading,
      handleReload,
      // 分页相关
      currentPage,
      totalPages,
      totalItems,
      pageSize,
      loadPage
    }
  }
})
</script>

<style>
.wordcard-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  padding: 30rpx;
  box-sizing: border-box;
  background-color: #f8f9fa;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
  padding-bottom: 20rpx;
  border-bottom: 2rpx solid #eaeaea;
}

.title {
  font-size: 42rpx;
  font-weight: bold;
  color: #333;
  letter-spacing: 1rpx;
}

.header-actions {
  display: flex;
  align-items: center;
}

.progress {
  font-size: 28rpx;
  color: #666;
  margin-right: 20rpx;
  background-color: #e9ecef;
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
}

.filter-btn {
  display: flex;
  align-items: center;
  font-size: 28rpx;
  color: #fff;
  background-color: #4caf50;
  padding: 10rpx 20rpx;
  border-radius: 10rpx;
  box-shadow: 0 2rpx 5rpx rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.filter-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 1rpx 2rpx rgba(0, 0, 0, 0.1);
}

.icon-filter {
  margin-left: 8rpx;
}

.swiper {
  flex: 1;
  width: 100%;
}

.card-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  padding: 20rpx;
}

.card {
  width: 100%;
  height: 80%;
  position: relative;
  transition: transform 0.6s;
  transform-style: preserve-3d;
  perspective: 1000rpx;
}

.card.is-flipped {
  transform: rotateY(180deg);
}

.card-front, .card-back {
  position: absolute;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  border-radius: 20rpx;
  padding: 40rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.difficulty-indicator {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 8rpx;
}

.difficulty-indicator.easy {
  background-color: #4caf50;
}

.difficulty-indicator.medium {
  background-color: #ff9800;
}

.difficulty-indicator.hard {
  background-color: #f44336;
}

.card-front {
  background-color: #ffffff;
}

.card-back {
  background-color: #f9f9f9;
  transform: rotateY(180deg);
}

.word {
  font-size: 70rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
  text-align: center;
  color: #333;
  text-shadow: 1rpx 1rpx 2rpx rgba(0, 0, 0, 0.1);
}

.phonetic {
  font-size: 32rpx;
  color: #666;
  margin-bottom: 20rpx;
  text-align: center;
  background-color: #f5f5f5;
  padding: 5rpx 15rpx;
  border-radius: 10rpx;
}

.part-of-speech {
  font-size: 28rpx;
  color: #999;
  margin-bottom: 40rpx;
  text-align: center;
  font-style: italic;
}

.translation {
  font-size: 48rpx;
  font-weight: bold;
  margin-bottom: 30rpx;
  text-align: center;
  color: #333;
}

.definition {
  font-size: 32rpx;
  color: #333;
  margin-bottom: 30rpx;
  text-align: center;
  line-height: 1.5;
  padding: 0 20rpx;
}

.example-container {
  margin-bottom: 30rpx;
  width: 100%;
  background-color: #f5f5f5;
  padding: 20rpx;
  border-radius: 10rpx;
  border-left: 6rpx solid #4caf50;
}

.example-label {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 10rpx;
  font-weight: bold;
}

.example {
  font-size: 30rpx;
  color: #333;
  font-style: italic;
  line-height: 1.5;
}

.tags-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  margin-bottom: 30rpx;
}

.tag {
  font-size: 24rpx;
  background-color: #f0f0f0;
  color: #666;
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  margin: 5rpx;
  box-shadow: 0 1rpx 3rpx rgba(0, 0, 0, 0.1);
}

.tag.difficulty {
  background-color: #e6f7e6;
  color: #4caf50;
  font-weight: bold;
}

.card-actions {
  display: flex;
  justify-content: center;
  margin-top: 40rpx;
  width: 100%;
}

.action-btn {
  background: none;
  border: none;
  font-size: 40rpx;
  color: #999;
  margin: 0 30rpx;
  padding: 0;
  line-height: 1;
  transition: all 0.3s ease;
}

.action-btn:active {
  transform: scale(1.1);
}

.sound-btn {
  color: #2196f3;
}

.favorite-btn {
  color: #999;
}

.action-btn.is-favorite {
  color: #ffc107;
}

.icon-star {
  font-size: 40rpx;
}

.hint {
  font-size: 24rpx;
  color: #999;
  margin-top: 40rpx;
  background-color: rgba(0, 0, 0, 0.05);
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
}

.controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 30rpx;
}

.control-btn {
  flex: 1;
  margin: 0 10rpx;
  padding: 20rpx 0;
  font-size: 30rpx;
  border-radius: 10rpx;
  background-color: #f5f5f5;
  border: none;
  box-shadow: 0 3rpx 6rpx rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.control-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 1rpx 2rpx rgba(0, 0, 0, 0.1);
}

.prev-btn, .next-btn {
  max-width: 100rpx;
  background-color: #e9ecef;
  color: #495057;
}

.learn-btn {
  background-color: #4caf50;
  color: #ffffff;
  font-weight: bold;
  letter-spacing: 1rpx;
}

.learn-btn.learned {
  background-color: #81c784;
}

.control-btn.primary {
  background-color: #4caf50;
  color: #ffffff;
}

.control-btn[disabled] {
  opacity: 0.5;
  pointer-events: none;
}

/* 筛选弹窗样式 */
.filter-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-mask {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(5rpx);
}

.modal-content {
  position: relative;
  width: 90%;
  max-height: 80%;
  background-color: #fff;
  border-radius: 15rpx;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20rpx 40rpx rgba(0, 0, 0, 0.2);
}

.modal-header {
  padding: 30rpx;
  border-bottom: 1rpx solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f8f9fa;
}

.modal-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.modal-close {
  font-size: 40rpx;
  color: #999;
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.modal-close:active {
  background-color: #f0f0f0;
}

.modal-body {
  padding: 30rpx;
  flex: 1;
  overflow-y: auto;
}

.filter-section {
  margin-bottom: 30rpx;
}

.filter-search-input {
  width: 100%;
  border: 1rpx solid #ddd;
  border-radius: 10rpx;
  padding: 16rpx 20rpx;
  font-size: 28rpx;
  box-sizing: border-box;
  margin-bottom: 10rpx;
}

.filter-label {
  font-size: 30rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
  display: block;
  color: #333;
}

.filter-options {
  display: flex;
  flex-wrap: nowrap;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 10rpx;
}

.filter-options::-webkit-scrollbar {
  height: 6rpx;
}

.filter-options::-webkit-scrollbar-thumb {
  background-color: rgba(0, 0, 0, 0.1);
  border-radius: 3rpx;
}

.filter-options.wrap {
  flex-wrap: wrap;
}

.filter-option {
  padding: 15rpx 30rpx;
  background-color: #f5f5f5;
  border-radius: 30rpx;
  margin-right: 15rpx;
  margin-bottom: 15rpx;
  font-size: 28rpx;
  color: #666;
  transition: all 0.3s ease;
  box-shadow: 0 2rpx 5rpx rgba(0, 0, 0, 0.05);
}

.filter-option.active {
  background-color: #4caf50;
  color: #fff;
  box-shadow: 0 2rpx 8rpx rgba(76, 175, 80, 0.3);
}

.modal-footer {
  padding: 20rpx 30rpx;
  border-top: 1rpx solid #eee;
  display: flex;
  justify-content: flex-end;
  background-color: #f8f9fa;
}

.modal-btn {
  padding: 15rpx 30rpx;
  font-size: 28rpx;
  border-radius: 30rpx;
  margin-left: 20rpx;
  background-color: #f0f0f0;
  color: #666;
  border: none;
  transition: all 0.3s ease;
}

.modal-btn.primary {
  background-color: #4caf50;
  color: #fff;
  box-shadow: 0 2rpx 8rpx rgba(76, 175, 80, 0.3);
}

.modal-btn:active {
  transform: translateY(2rpx);
}

/* 提示样式 */
.toast {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 200;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translate(-50%, -60%); }
  to { opacity: 1; transform: translate(-50%, -50%); }
}

.toast-content {
  background-color: rgba(0, 0, 0, 0.8);
  color: #fff;
  padding: 20rpx 40rpx;
  border-radius: 10rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 5rpx 15rpx rgba(0, 0, 0, 0.2);
}

.toast-icon {
  margin-right: 10rpx;
  font-size: 32rpx;
}

.toast-message {
  font-size: 28rpx;
}

/* 加载状态样式 */
.loading-container {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.8);
}

.loading-spinner {
  width: 60rpx;
  height: 60rpx;
  border: 4rpx solid #4caf50;
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  margin-top: 20rpx;
  font-size: 28rpx;
  color: #333;
}

/* 空数据状态样式 */
.empty-container {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 30rpx;
  background-color: #fff;
}

.empty-icon {
  font-size: 60rpx;
  color: #999;
  margin-bottom: 20rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 30rpx;
}

.reload-btn {
  padding: 15rpx 30rpx;
  font-size: 28rpx;
  border-radius: 30rpx;
  background-color: #4caf50;
  color: #fff;
  border: none;
  transition: all 0.3s ease;
}

.reload-btn:active {
  transform: translateY(2rpx);
}

/* 分页样式 */
.pagination {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 20rpx;
  padding: 20rpx 0;
  border-top: 2rpx solid #eaeaea;
}

.pagination-info {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 10rpx;
  padding: 0 20rpx;
  text-align: center;
}

.pagination-controls {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  padding: 0 10rpx;
}

.page-btn {
  margin: 0 10rpx;
  padding: 10rpx 20rpx;
  font-size: 24rpx;
  background-color: #f0f0f0;
  color: #333;
  border-radius: 8rpx;
  border: none;
  min-width: 100rpx;
  text-align: center;
}

.page-btn:disabled {
  opacity: 0.5;
  background-color: #e0e0e0;
  color: #999;
}

.page-btn:active {
  background-color: #e0e0e0;
}
</style>
