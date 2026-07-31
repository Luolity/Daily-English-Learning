<template>
  <view class="wordcard-container">
    <view class="header">
      <text class="title">鍗曡瘝鍗＄墖</text>
      <view class="header-actions">
        <text class="progress">{{ currentIndex + 1 }}/{{ wordList.length }}</text>
        <view class="filter-btn" @click="showFilterModal = true">
          <text>绛涢€?</text>
          <text class="icon-filter">馃攳</text>
        </view>
      </view>
    </view>
    
    <!-- 鍔犺浇鐘舵€? -->
    <view class="loading-container" v-if="isLoading">
      <view class="loading-spinner"></view>
      <text class="loading-text">鍔犺浇涓?...</text>
    </view>
    
    <!-- 绌烘暟鎹姸鎬? -->
    <view class="empty-container" v-else-if="wordList.length === 0">
      <text class="empty-icon">馃摎</text>
      <text class="empty-text">鏆傛棤鍗曡瘝鏁版嵁</text>
      <button class="reload-btn" @click="handleReload">閲嶆柊鍔犺浇</button>
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
                  <text class="icon-sound">馃攰</text>
                </button>
                <button 
                  class="action-btn favorite-btn" 
                  :class="{ 'is-favorite': isFavorite(word) }"
                  @click.stop="toggleFavorite(word)"
                >
                  <text class="icon-star">{{ isFavorite(word) ? '鈽?' : '鈽?' }}</text>
                </button>
              </view>
              <text class="hint">鐐瑰嚮鍗＄墖鏌ョ湅閲婁箟</text>
            </view>
            <view class="card-back">
              <view class="difficulty-indicator" :class="word.difficulty"></view>
              <text class="translation">{{ word.translation }}</text>
              <text class="definition">{{ word.definition }}</text>
              <view class="example-container">
                <text class="example-label">渚嬪彞锛?</text>
                <text class="example">{{ word.example }}</text>
              </view>
              <view class="tags-container" v-if="word.categories && word.categories.length > 0">
                <text v-for="(category, idx) in word.categories" :key="idx" class="tag">{{ category }}</text>
                <text class="tag difficulty">{{ getDifficultyText(word.difficulty) }}</text>
              </view>
              <view class="card-actions">
                <button class="action-btn sound-btn" @click.stop="playPronunciation(word)">
                  <text class="icon-sound">馃攰</text>
                </button>
                <button 
                  class="action-btn favorite-btn" 
                  :class="{ 'is-favorite': isFavorite(word) }"
                  @click.stop="toggleFavorite(word)"
                >
                  <text class="icon-star">{{ isFavorite(word) ? '鈽?' : '鈽?' }}</text>
                </button>
              </view>
              <text class="hint">鐐瑰嚮鍗＄墖杩斿洖</text>
            </view>
          </view>
        </view>
      </swiper-item>
    </swiper>
    
    <view class="controls">
      <button class="control-btn prev-btn" @click="prevCard" :disabled="currentIndex === 0">
        <text class="icon-left">鈼€</text>
      </button>
      <button class="control-btn primary learn-btn" @click="markAsLearned" :class="{ 'learned': learnedWords[wordList[currentIndex]?.id] }">
        <text>{{ learnedWords[wordList[currentIndex]?.id] ? '宸插涔?' : '鏍囪涓哄凡瀛?' }}</text>
      </button>
      <button class="control-btn next-btn" @click="nextCard" :disabled="currentIndex === wordList.length - 1">
        <text class="icon-right">鈻?</text>
      </button>
    </view>
    
    <!-- 鍒嗛〉鎺т欢 -->
    <view class="pagination">
      <view class="pagination-info">
        <text>绗? {{ currentPage }}/{{ totalPages }} 椤? 路 姣忛〉 {{ pageSize }} 鏉? 路 鍏? {{ totalItems }} 涓崟璇?</text>
      </view>
      <view class="pagination-controls">
        <button class="page-btn" @click="loadPage(1)" :disabled="currentPage === 1">
          <text>棣栭〉</text>
        </button>
        <button class="page-btn" @click="loadPage(currentPage - 1)" :disabled="currentPage === 1">
          <text>涓婁竴椤?</text>
        </button>
        <button class="page-btn" @click="loadPage(currentPage + 1)" :disabled="totalPages === 0 || currentPage >= totalPages">
          <text>涓嬩竴椤?</text>
        </button>
        <button class="page-btn" @click="loadPage(totalPages)" :disabled="totalPages === 0 || currentPage >= totalPages">
          <text>末页</text>
        </button>
      </view>
    </view>
    
    <!-- 绛涢€夊脊绐? -->
    <view class="filter-modal" v-if="showFilterModal">
      <view class="modal-mask" @click="showFilterModal = false"></view>
      <view class="modal-content">
        <view class="modal-header">
          <text class="modal-title">绛涢€夊崟璇?</text>
          <text class="modal-close" @click="showFilterModal = false">脳</text>
        </view>
        
        <view class="modal-body">
          <view class="filter-section">
            <text class="filter-label">鎼滅储</text>
            <input
              class="filter-search-input"
              v-model="searchKeyword"
              placeholder="杈撳叆鍗曡瘝鎴栭噴涔?"
              confirm-type="search"
              @confirm="applyFilters"
            />
          </view>

          <view class="filter-section">
            <text class="filter-label">闅惧害</text>
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
            <text class="filter-label">鍒嗙被</text>
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
            <text class="filter-label">鏄剧ず</text>
            <view class="filter-options">
              <view 
                class="filter-option" 
                :class="{ active: showFavoritesOnly }"
                @click="showFavoritesOnly = !showFavoritesOnly"
              >
                <text>浠呮樉绀烘敹钘?</text>
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
          <button class="modal-btn" @click="resetFilters">閲嶇疆</button>
          <button class="modal-btn primary" @click="applyFilters">搴旂敤</button>
        </view>
      </view>
    </view>
    
    <!-- 娣诲姞鎴愬姛鎻愮ず -->
    <view class="toast" v-if="showToast">
      <view class="toast-content">
        <text class="toast-icon">{{ toastSuccess ? '鉁?' : '鉁?' }}</text>
        <text class="toast-message">{{ toastMessage }}</text>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted, watch } from 'vue'
import { useStore } from 'vuex'
import type { IWordCard } from '../../store/types'
import { api } from '../../services/api'
import { calcTotalPages } from '../../utils/pagination'

export default defineComponent({
  name: 'WordCard',
  setup() {
    const store = useStore()
    const allWords = computed(() => store.state.vocabulary.wordList)
    const wordList = ref<IWordCard[]>([])
    const currentIndex = ref(0)
    const flippedCards = ref<Record<number, boolean>>({})
    const learnedWords = ref<Record<string, boolean>>({})
    
    // 鍒嗛〉鐩稿叧
    const currentPage = ref(1)
    const pageSize = ref(10)
    const totalItems = ref(0)
    const totalPages = ref(0)
    
    // 绛涢€夌浉鍏?
    const showFilterModal = ref(false)
    const selectedDifficulty = ref('')
    const selectedCategory = ref('')
    const searchKeyword = ref('')
    const showFavoritesOnly = ref(false)
    const hideLearnedWords = ref(false)
    const categories = computed(() => store.state.vocabulary.categories)
    const difficulties = [
      { label: '鍏ㄩ儴', value: '' },
      { label: '绠€鍗?', value: 'easy' },
      { label: '中等', value: 'medium' },
      { label: '鍥伴毦', value: 'hard' }
    ]
    
    // 鎻愮ず鐩稿叧
    const showToast = ref(false)
    const toastMessage = ref('')
    const toastSuccess = ref(true)
    const toastTimer = ref<number | null>(null)
    
    // 闊抽鎾斁鍣?
    let audioContext: any = null
    
    // 鍔犺浇鐘舵€?
    const isLoading = ref(false)
    
    // 鏍规嵁璺敱鍙傛暟鍒濆鍖?
    const initFromRoute = () => {
      const query = uni.getLaunchOptionsSync().query || {}
      
      // 如果是复习模式，从参数中获取单词ID
      if (query.mode === 'review' && query.words) {
        const wordIds = (query.words as string).split(',')
        const wordsToReview = allWords.value.filter((word: IWordCard) => wordIds.includes(word.id))
        wordList.value = wordsToReview
      } else {
        // 姝ｅ父妯″紡锛屽姞杞界涓€椤垫暟鎹?
        loadPage(1)
      }
    }
    
    const getFilterParams = () => ({
      category: selectedCategory.value || undefined,
      difficulty: selectedDifficulty.value || undefined,
      keyword: searchKeyword.value.trim() || undefined
    })

    // 鍔犺浇鎸囧畾椤电爜鐨勬暟鎹細鍏堟煡鍗曡瘝鎬绘暟锛屽啀鎸? totalItems 璁＄畻鎬婚〉鏁?
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
            await loadPage(totalPages.value);
            return;
          }

          currentPage.value = page;
          currentIndex.value = 0;
          flippedCards.value = {};
        }
        
        console.log(`每页 ${pageSize.value} 条，共 ${totalItems.value} 个单词，${totalPages.value} 页，当前第 ${page} 页`);
      } catch (error) {
        console.error('鍔犺浇鍒嗛〉鏁版嵁澶辫触:', error);
        uni.showToast({
          title: '鍔犺浇鍒嗛〉鏁版嵁澶辫触',
          icon: 'none'
        });
      } finally {
        isLoading.value = false;
      }
    };
    
    // 搴旂敤绛涢€?
    const applyFilters = async () => {
      try {
        isLoading.value = true;
        console.log('搴旂敤绛涢€夛紝閲嶇疆鍒扮涓€椤?');
        
        // 閲嶇疆鍒扮涓€椤?
        await loadPage(1);
        
        // 鍏抽棴绛涢€夊脊绐?
        showFilterModal.value = false;
      } catch (error) {
        console.error('绛涢€夊崟璇嶆椂鍑洪敊:', error);
        uni.showToast({
          title: '绛涢€夊崟璇嶆椂鍑洪敊',
          icon: 'none'
        });
      } finally {
        isLoading.value = false;
      }
    }
    
    // 閲嶇疆绛涢€?
    const resetFilters = () => {
      selectedDifficulty.value = ''
      selectedCategory.value = ''
      searchKeyword.value = ''
      showFavoritesOnly.value = false
      hideLearnedWords.value = false
    }
    
    // 缈昏浆鍗＄墖
    const flipCard = (index: number) => {
      flippedCards.value[index] = !flippedCards.value[index]
    }
    
    // 鍒囨崲鏀惰棌鐘舵€?
    const toggleFavorite = async (word: IWordCard) => {
      if (isFavorite(word)) {
        await store.dispatch('removeFromFavorites', word.id)
        showToastMessage('已从生词本移除', false)
      } else {
        await store.dispatch('addToFavorites', word)
        showToastMessage('宸叉坊鍔犲埌鐢熻瘝鏈?', true)
      }
      // 鑷姩鍒锋柊鐢熻瘝鏈?
      store.dispatch('fetchFavorites')
    }
    
    // 鏄剧ず鎻愮ず淇℃伅
    const showToastMessage = (message: string, success: boolean = true) => {
      // 娓呴櫎涔嬪墠鐨勫畾鏃跺櫒
      if (toastTimer.value) {
        clearTimeout(toastTimer.value)
      }
      
      // 鏄剧ず鏂版彁绀?
      toastMessage.value = message
      toastSuccess.value = success
      showToast.value = true
      
      // 设置自动隐藏
      toastTimer.value = setTimeout(() => {
        showToast.value = false
      }, 2000) as unknown as number
    }
    
    // 妫€鏌ユ槸鍚﹀凡鏀惰棌
    const isFavorite = (word: IWordCard) => {
      return store.getters.favoriteWords.some((item: IWordCard) => item.id === word.id)
    }
    
    // 鑾峰彇闅惧害鏂囨湰
    const getDifficultyText = (difficulty: string) => {
      switch (difficulty) {
        case 'easy': return '绠€鍗?'
        case 'medium': return '中等'
        case 'hard': return '鍥伴毦'
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
          console.log('闊抽寮€濮嬫挱鏀?')
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
    
    // 婊戝姩鍒囨崲鍗＄墖
    const onSwiperChange = (e: any) => {
      currentIndex.value = e.detail.current
    }
    
    // 涓嬩竴寮犲崱鐗?
    const nextCard = () => {
      if (currentIndex.value < wordList.value.length - 1) {
        currentIndex.value++
      }
    }
    
    // 涓婁竴寮犲崱鐗?
    const prevCard = () => {
      if (currentIndex.value > 0) {
        currentIndex.value--
      }
    }
    
    // 鏍囪涓哄凡瀛?
    const markAsLearned = () => {
      const currentWord = wordList.value[currentIndex.value]
      if (!learnedWords.value[currentWord.id]) {
        learnedWords.value[currentWord.id] = true
        
        // 鏇存柊瀛︿範杩涘害
        store.dispatch('updateProgress', {
          wordsLearned: 1,
          timeSpent: 1,
          correctCount: 0,
          totalCount: 0
        })
        
        showToastMessage('宸叉爣璁颁负瀛︿範瀹屾垚', true)
        
        // 濡傛灉璁剧疆浜嗛殣钘忓凡瀛﹀崟璇嶏紝鍒欓噸鏂扮瓫閫?
        if (hideLearnedWords.value) {
          // 延迟执行，让用户看到提示
          setTimeout(() => {
            applyFilters()
          }, 1000)
        } else {
          // 鑷姩鍓嶈繘鍒颁笅涓€寮犲崱鐗?
          nextCard()
        }
      }
    }
    
    // 鑾峰彇鍗曡瘝鍒楄〃
    const fetchWordList = async () => {
      try {
        isLoading.value = true
        // 浣跨敤鍒嗛〉鍔犺浇绗竴椤垫暟鎹?
        await loadPage(1);
      } catch (error) {
        console.error('鑾峰彇鍗曡瘝鍒楄〃澶辫触:', error);
        // 浣跨敤妯℃嫙鏁版嵁浣滀负澶囬€?
        wordList.value = getMockWordCards();
        uni.showToast({
          title: '鍔犺浇鍗曡瘝鍒楄〃澶辫触锛屼娇鐢ㄦ湰鍦版暟鎹?',
          icon: 'none'
        });
      } finally {
        isLoading.value = false
      }
    }
    
    // 妯℃嫙鍗曡瘝鏁版嵁锛岀敤浜嶢PI澶辫触鏃剁殑澶囬€?
    const getMockWordCards = (): IWordCard[] => {
      return [
        {
          id: '1',
          word: 'hello',
          translation: '浣犲ソ',
          phonetic: '/h蓹藞lo蕣/',
          partOfSpeech: 'n. & int.',
          definition: 'used as a greeting',
          example: 'Hello, how are you today?',
          difficulty: 'easy',
          categories: ['CET4']
        },
        {
          id: '2',
          word: 'world',
          translation: '涓栫晫',
          phonetic: '/w蓽藧rld/',
          partOfSpeech: 'n.',
          definition: 'the earth, together with all of its countries and peoples',
          example: 'He wants to travel around the world.',
          difficulty: 'easy',
          categories: ['CET4']
        },
        {
          id: '3',
          word: 'vocabulary',
          translation: '璇嶆眹',
          phonetic: '/v蓹藞k忙bj蓹藢leri/',
          partOfSpeech: 'n.',
          definition: 'all the words known and used by a particular person',
          example: 'Reading helps to increase your vocabulary.',
          difficulty: 'medium',
          categories: ['CET6']
        }
      ];
    }
    
    // 閲嶆柊鍔犺浇鏁版嵁
    const handleReload = () => {
      fetchWordList();
    }
    
    // 缁勪欢鍗歌浇鏃堕噴鏀捐祫婧?
    onMounted(() => {
      console.log('鍗曡瘝鍗＄墖缁勪欢宸叉寕杞?');
      
      // 鍔犺浇鍗曡瘝鍒楄〃
      fetchWordList().then(() => {
        console.log('鍗曡瘝鍒楄〃鍔犺浇瀹屾垚锛屽噯澶囧垵濮嬪寲璺敱鍙傛暟');
        
        // 根据路由参数初始化（如果有）
        try {
          initFromRoute();
        } catch (error) {
          console.error('鍒濆鍖栬矾鐢卞弬鏁板け璐?:', error);
        }
        
        // 璋冭瘯锛氭墦鍗版暟鎹?
        setTimeout(() => {
          console.log('allWords:', allWords.value);
          console.log('wordList:', wordList.value);
        }, 1000);
      }).catch(error => {
        console.error('鍔犺浇鍗曡瘝鍒楄〃澶辫触:', error);
        // 浣跨敤妯℃嫙鏁版嵁
        wordList.value = getMockWordCards();
      });
      
      // 杩斿洖娓呯悊鍑芥暟
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
      // 鍒嗛〉鐩稿叧
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

/* 绛涢€夊脊绐楁牱寮? */
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

/* 鎻愮ず鏍峰紡 */
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

/* 鍔犺浇鐘舵€佹牱寮? */
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

/* 绌烘暟鎹姸鎬佹牱寮? */
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

/* 鍒嗛〉鏍峰紡 */
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
