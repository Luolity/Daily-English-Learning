<template>
  <view class="favorites-container">
    <view class="header">
      <text class="title">鎴戠殑鐢熻瘝鏈?</text>
      <view class="header-actions">
        <view class="search-box">
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="搜索单词"
            confirm-type="search"
            @confirm="handleSearch"
          />
          <text class="icon-search" @click="handleSearch">馃攳</text>
        </view>
        <text class="edit-btn" @click="toggleEditMode">{{ isEditMode ? '瀹屾垚' : '缂栬緫' }}</text>
      </view>
    </view>
    
    <view class="filter-section">
      <scroll-view scroll-x class="category-tabs">
        <view 
          class="category-tab" 
          :class="{ active: selectedCategory === '' }"
          @click="selectedCategory = ''"
        >
          鍏ㄩ儴
        </view>
        <view 
          v-for="category in categories" 
          :key="category"
          class="category-tab" 
          :class="{ active: selectedCategory === category }"
          @click="selectedCategory = category"
        >
          {{ category }}
        </view>
      </scroll-view>
      
      <view class="sort-dropdown">
        <picker 
          :value="sortOptionIndex" 
          :range="sortOptions" 
          range-key="label"
          @change="handleSortChange"
        >
          <view class="sort-label">
            <text>{{ sortOptions[sortOptionIndex].label }}</text>
            <text class="icon-down">鈻?</text>
          </view>
        </picker>
      </view>
    </view>
    
    <view v-if="filteredWords.length === 0" class="empty-state">
      <image src="/static/images/vocabulary/empty.png" class="empty-image"></image>
      <text class="empty-text">{{ searchQuery ? '娌℃湁鎵惧埌鍖归厤鐨勫崟璇?' : '鏆傛棤鏀惰棌鍗曡瘝' }}</text>
      <text class="empty-tip">{{ searchQuery ? '灏濊瘯鍏朵粬鍏抽敭璇?' : '瀛︿範鍗曡瘝鏃剁偣鍑绘槦鏍囨敹钘忓崟璇?' }}</text>
      <button class="go-learn-btn" @click="navigateToWordCard">鍘诲涔犲崟璇?</button>
    </view>
    
    <view v-else>
      <view class="batch-actions" v-if="isEditMode">
        <text class="select-all" @click="toggleSelectAll">{{ isAllSelected ? '鍙栨秷鍏ㄩ€?' : '鍏ㄩ€?' }}</text>
        <button 
          class="batch-btn delete" 
          :disabled="selectedWords.length === 0"
          @click="batchRemove"
        >
          鍒犻櫎 ({{ selectedWords.length }})
        </button>
        <button 
          class="batch-btn review" 
          :disabled="selectedWords.length === 0"
          @click="startReview"
        >
          澶嶄範
        </button>
      </view>
      
      <view class="word-list">
        <view 
          v-for="word in filteredWords" 
          :key="word.id"
          class="word-item"
          :class="{ selected: isEditMode && selectedWords.includes(word.id) }"
        >
          <view class="checkbox" v-if="isEditMode" @click="toggleWordSelection(word.id)">
            <text :class="selectedWords.includes(word.id) ? 'icon-check-circle' : 'icon-circle'">{{ selectedWords.includes(word.id) ? '鉁?' : '鈼?' }}</text>
          </view>
          
          <view class="word-info" @click="isEditMode ? toggleWordSelection(word.id) : showWordDetail(word)">
            <view class="word-header">
              <text class="word">{{ word.word }}</text>
              <text class="phonetic">{{ word.phonetic }}</text>
            </view>
            <text class="translation">{{ word.translation }}</text>
            <view class="word-tags">
              <text v-for="(category, index) in word.categories" :key="index" class="tag">{{ category }}</text>
              <text class="tag difficulty">{{ getDifficultyText(word.difficulty) }}</text>
            </view>
          </view>
          
          <view class="word-actions" v-if="!isEditMode">
            <button class="action-btn" @click="playPronunciation(word)">
              <text class="icon-sound">馃攰</text>
            </button>
            <button class="action-btn" @click="removeFromFavorites(word)">
              <text class="icon-delete">馃棏锔?</text>
            </button>
          </view>
        </view>
      </view>
      
      <view class="pagination" v-if="totalPages > 1">
        <text 
          class="page-btn prev" 
          :class="{ disabled: currentPage === 1 }"
          @click="prevPage"
        >
          涓婁竴椤?
        </text>
        <text class="page-info">{{ currentPage }}/{{ totalPages }}</text>
        <text 
          class="page-btn next" 
          :class="{ disabled: currentPage === totalPages }"
          @click="nextPage"
        >
          涓嬩竴椤?
        </text>
      </view>
    </view>
    
    <!-- 鍗曡瘝璇︽儏寮圭獥 -->
    <view class="word-detail-modal" v-if="showModal">
      <view class="modal-mask" @click="closeModal"></view>
      <view class="modal-content">
        <view class="modal-header">
          <text class="modal-title">{{ currentWord.word }}</text>
          <text class="modal-close" @click="closeModal">脳</text>
        </view>
        
        <view class="modal-body">
          <view class="word-pronunciation">
            <text class="word-phonetic">{{ currentWord.phonetic }}</text>
            <button class="play-btn" @click="playPronunciation(currentWord)">
              <text class="icon-sound">馃攰</text>
            </button>
          </view>
          
          <view class="word-meaning">
            <text class="meaning-label">閲婁箟</text>
            <text class="meaning-text">{{ currentWord.translation }}</text>
          </view>
          
          <view class="word-definition">
            <text class="definition-label">璇︾粏瑙ｉ噴</text>
            <text class="definition-text">{{ currentWord.definition }}</text>
          </view>
          
          <view class="word-example">
            <text class="example-label">渚嬪彞</text>
            <text class="example-text">{{ currentWord.example }}</text>
          </view>
          
          <view class="word-categories">
            <text class="categories-label">鍒嗙被</text>
            <view class="categories-tags">
              <text v-for="(category, index) in currentWord.categories" :key="index" class="category-tag">{{ category }}</text>
            </view>
          </view>
        </view>
        
        <view class="modal-footer">
          <button class="modal-btn" @click="removeFromFavorites(currentWord); closeModal();">绉诲嚭鐢熻瘝鏈?</button>
          <button class="modal-btn primary" @click="closeModal">鍏抽棴</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import type { IWordCard } from '../../store/types'

export default defineComponent({
  name: 'Favorites',
  setup() {
    const store = useStore()
    
    // 鏀惰棌鐨勫崟璇嶅垪琛?
    const favoriteWords = computed(() => store.getters.favoriteWords)
    
    // 鍒嗙被鍒楄〃
    const categories = computed(() => store.state.vocabulary.categories)
    
    // 鎼滅储鍜岀瓫閫?
    const searchQuery = ref('')
    const selectedCategory = ref('')
    const sortOptions = [
      { label: '娣诲姞鏃堕棿锛氭柊鈫掓棫', value: 'timeDesc' },
      { label: '娣诲姞鏃堕棿锛氭棫鈫掓柊', value: 'timeAsc' },
      { label: '瀛楁瘝椤哄簭锛欰鈫抁', value: 'alphaAsc' },
      { label: '瀛楁瘝椤哄簭锛歓鈫扐', value: 'alphaDesc' }
    ]
    const sortOptionIndex = ref(0)
    
    // 缂栬緫妯″紡
    const isEditMode = ref(false)
    const selectedWords = ref<string[]>([])
    
    // 鍒嗛〉
    const pageSize = 10
    const currentPage = ref(1)
    
    // 璇︽儏寮圭獥
    const showModal = ref(false)
    const currentWord = ref<IWordCard>({} as IWordCard)
    
    // 闊抽鎾斁鍣?
    let audioContext: any = null
    
    // 鏍规嵁鎼滅储銆佺瓫閫夊拰鎺掑簭鏉′欢杩囨护鍗曡瘝
    const filteredWords = computed(() => {
      let result = [...favoriteWords.value]
      
      // 鎼滅储杩囨护
      if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase()
        result = result.filter(word => 
          word.word.toLowerCase().includes(query) || 
          word.translation.toLowerCase().includes(query)
        )
      }
      
      // 鍒嗙被杩囨护
      if (selectedCategory.value) {
        result = result.filter(word => 
          word.categories.includes(selectedCategory.value)
        )
      }
      
      // 鎺掑簭
      const sortValue = sortOptions[sortOptionIndex.value].value
      switch (sortValue) {
        case 'timeDesc':
          // 默认顺序，最新添加的在前面
          break
        case 'timeAsc':
          result = [...result].reverse()
          break
        case 'alphaAsc':
          result.sort((a, b) => a.word.localeCompare(b.word))
          break
        case 'alphaDesc':
          result.sort((a, b) => b.word.localeCompare(a.word))
          break
      }
      
      return result
    })
    
    // 鍒嗛〉鍚庣殑鍗曡瘝
    const paginatedWords = computed(() => {
      const start = (currentPage.value - 1) * pageSize
      const end = start + pageSize
      return filteredWords.value.slice(start, end)
    })
    
    // 鎬婚〉鏁?
    const totalPages = computed(() => {
      return Math.ceil(filteredWords.value.length / pageSize)
    })
    
    // 鏄惁鍏ㄩ€?
    const isAllSelected = computed(() => {
      return filteredWords.value.length > 0 && 
        filteredWords.value.every(word => selectedWords.value.includes(word.id))
    })
    
    // 澶勭悊鎼滅储
    const handleSearch = () => {
      currentPage.value = 1 // 閲嶇疆鍒扮涓€椤?
    }
    
    // 澶勭悊鎺掑簭鍙樺寲
    const handleSortChange = (e: any) => {
      sortOptionIndex.value = e.detail.value
    }
    
    // 鍒囨崲缂栬緫妯″紡
    const toggleEditMode = () => {
      isEditMode.value = !isEditMode.value
      if (!isEditMode.value) {
        selectedWords.value = []
      }
    }
    
    // 鍒囨崲鍗曡瘝閫夋嫨鐘舵€?
    const toggleWordSelection = (wordId: string) => {
      const index = selectedWords.value.indexOf(wordId)
      if (index === -1) {
        selectedWords.value.push(wordId)
      } else {
        selectedWords.value.splice(index, 1)
      }
    }
    
    // 鍏ㄩ€?/鍙栨秷鍏ㄩ€?
    const toggleSelectAll = () => {
      if (isAllSelected.value) {
        selectedWords.value = []
      } else {
        selectedWords.value = filteredWords.value.map(word => word.id)
      }
    }
    
    // 鎵归噺鍒犻櫎
    const batchRemove = () => {
      if (selectedWords.value.length === 0) return
      
      uni.showModal({
        title: '鎵归噺绉婚櫎',
        content: `纭畾瑕佸皢閫変腑鐨? ${selectedWords.value.length} 涓崟璇嶄粠鐢熻瘝鏈腑绉婚櫎鍚楋紵`,
        success: (res) => {
          if (res.confirm) {
            selectedWords.value.forEach(wordId => {
              store.dispatch('removeFromFavorites', wordId)
            })
            selectedWords.value = []
            
            uni.showToast({
              title: '已批量移除',
              icon: 'success'
            })
          }
        }
      })
    }
    
    // 寮€濮嬪涔?
    const startReview = () => {
      if (selectedWords.value.length === 0) return
      
      // 这里可以跳转到复习页面，并传递选中的单词ID
      uni.navigateTo({
        url: `/pages/vocabulary/wordcard?mode=review&words=${selectedWords.value.join(',')}`
      })
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
    
    // 浠庢敹钘忎腑绉婚櫎
    const removeFromFavorites = (word: IWordCard) => {
      uni.showModal({
        title: '移除单词',
        content: `确定要将“${word.word}”从生词本中移除吗？`,
        success: (res) => {
          if (res.confirm) {
            store.dispatch('removeFromFavorites', word.id)
          }
        }
      })
    }
    
    // 鏄剧ず鍗曡瘝璇︽儏
    const showWordDetail = (word: IWordCard) => {
      currentWord.value = word
      showModal.value = true
    }
    
    // 鍏抽棴璇︽儏寮圭獥
    const closeModal = () => {
      showModal.value = false
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
    
    // 导航到单词卡片页面
    const navigateToWordCard = () => {
      uni.navigateTo({
        url: '/pages/vocabulary/wordcard'
      })
    }
    
    // 鍒嗛〉瀵艰埅
    const prevPage = () => {
      if (currentPage.value > 1) {
        currentPage.value--
      }
    }
    
    const nextPage = () => {
      if (currentPage.value < totalPages.value) {
        currentPage.value++
      }
    }
    
    // 鑷姩璇锋眰鐢熻瘝鏈暟鎹?
    onMounted(() => {
      store.dispatch('fetchFavorites')
    })
    
    return {
      favoriteWords: paginatedWords,
      filteredWords,
      categories,
      searchQuery,
      selectedCategory,
      sortOptions,
      sortOptionIndex,
      isEditMode,
      selectedWords,
      currentPage,
      totalPages,
      isAllSelected,
      showModal,
      currentWord,
      handleSearch,
      handleSortChange,
      toggleEditMode,
      toggleWordSelection,
      toggleSelectAll,
      batchRemove,
      startReview,
      playPronunciation,
      removeFromFavorites,
      showWordDetail,
      closeModal,
      getDifficultyText,
      navigateToWordCard,
      prevPage,
      nextPage
    }
  }
})
</script>

<style>
.favorites-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  padding: 30rpx;
  box-sizing: border-box;
  background-color: #f8f9fa;
}

.header {
  display: flex;
  flex-direction: column;
  margin-bottom: 30rpx;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
  margin-bottom: 20rpx;
  color: #333;
  letter-spacing: 1rpx;
}

.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-box {
  flex: 1;
  position: relative;
  margin-right: 20rpx;
}

.search-box input {
  width: 100%;
  height: 80rpx;
  padding: 0 80rpx 0 30rpx;
  border-radius: 40rpx;
  background-color: #fff;
  font-size: 28rpx;
  box-shadow: 0 4rpx 10rpx rgba(0, 0, 0, 0.05);
  box-sizing: border-box;
  border: 1rpx solid #eaeaea;
}

.icon-search {
  position: absolute;
  right: 30rpx;
  top: 50%;
  transform: translateY(-50%);
  font-size: 32rpx;
  color: #999;
}

.edit-btn {
  padding: 16rpx 30rpx;
  border-radius: 40rpx;
  background-color: #4caf50;
  color: #fff;
  font-size: 28rpx;
  font-weight: bold;
  box-shadow: 0 4rpx 10rpx rgba(76, 175, 80, 0.2);
  transition: all 0.3s ease;
}

.edit-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 2rpx 5rpx rgba(76, 175, 80, 0.2);
}

.filter-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.category-tabs {
  flex: 1;
  white-space: nowrap;
  margin-right: 20rpx;
}

.category-tab {
  display: inline-block;
  padding: 12rpx 25rpx;
  font-size: 28rpx;
  color: #666;
  margin-right: 15rpx;
  border-radius: 30rpx;
  background-color: #fff;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.category-tab.active {
  background-color: #4caf50;
  color: #fff;
  box-shadow: 0 4rpx 12rpx rgba(76, 175, 80, 0.2);
}

.sort-dropdown {
  width: 200rpx;
}

.sort-label {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12rpx 20rpx;
  background-color: #fff;
  border-radius: 30rpx;
  font-size: 26rpx;
  color: #666;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}

.icon-down {
  font-size: 20rpx;
  color: #999;
  margin-left: 10rpx;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
}

.empty-image {
  width: 240rpx;
  height: 240rpx;
  margin-bottom: 30rpx;
  opacity: 0.7;
}

.empty-text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 10rpx;
}

.empty-tip {
  font-size: 26rpx;
  color: #999;
  margin-bottom: 40rpx;
  text-align: center;
}

.go-learn-btn {
  padding: 20rpx 50rpx;
  background-color: #4caf50;
  color: #fff;
  border-radius: 40rpx;
  font-size: 28rpx;
  font-weight: bold;
  border: none;
  box-shadow: 0 6rpx 15rpx rgba(76, 175, 80, 0.2);
  transition: all 0.3s ease;
}

.go-learn-btn:active {
  transform: translateY(3rpx);
  box-shadow: 0 3rpx 8rpx rgba(76, 175, 80, 0.2);
}

.batch-actions {
  display: flex;
  align-items: center;
  background-color: #fff;
  padding: 20rpx 30rpx;
  border-radius: 15rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.05);
}

.select-all {
  font-size: 28rpx;
  color: #666;
  margin-right: auto;
}

.batch-btn {
  background: none;
  border: none;
  font-size: 26rpx;
  margin-left: 20rpx;
  padding: 12rpx 30rpx;
  border-radius: 30rpx;
  box-shadow: 0 3rpx 8rpx rgba(0, 0, 0, 0.05);
}

.batch-btn.delete {
  background-color: #f44336;
  color: #fff;
}

.batch-btn.review {
  background-color: #4caf50;
  color: #fff;
}

.batch-btn[disabled] {
  opacity: 0.6;
  background-color: #e0e0e0;
  color: #999;
  box-shadow: none;
}

.word-list {
  margin-bottom: 30rpx;
}

.word-item {
  display: flex;
  align-items: center;
  padding: 25rpx;
  background-color: #fff;
  border-radius: 15rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.word-item.selected {
  background-color: rgba(76, 175, 80, 0.05);
  border: 1rpx solid rgba(76, 175, 80, 0.3);
}

.checkbox {
  margin-right: 20rpx;
  font-size: 40rpx;
  color: #4caf50;
}

.icon-circle {
  color: #ccc;
}

.icon-check-circle {
  color: #4caf50;
}

.word-info {
  flex: 1;
}

.word-header {
  display: flex;
  align-items: baseline;
  margin-bottom: 10rpx;
}

.word {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-right: 15rpx;
}

.phonetic {
  font-size: 24rpx;
  color: #666;
  background-color: #f5f5f5;
  padding: 4rpx 10rpx;
  border-radius: 6rpx;
}

.translation {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 10rpx;
  line-height: 1.5;
}

.word-tags {
  display: flex;
  flex-wrap: wrap;
}

.tag {
  font-size: 22rpx;
  color: #666;
  background-color: #f0f0f0;
  padding: 4rpx 12rpx;
  border-radius: 10rpx;
  margin-right: 10rpx;
  margin-bottom: 6rpx;
}

.tag.difficulty {
  background-color: rgba(76, 175, 80, 0.1);
  color: #4caf50;
  font-weight: bold;
}

.word-actions {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-left: 20rpx;
}

.action-btn {
  background: none;
  border: none;
  font-size: 36rpx;
  color: #999;
  padding: 15rpx;
  line-height: 1;
  transition: all 0.3s ease;
}

.action-btn:first-child {
  margin-bottom: 15rpx;
}

.icon-sound {
  color: #2196f3;
}

.icon-delete {
  color: #f44336;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 30rpx;
  margin-bottom: 30rpx;
}

.page-btn {
  padding: 12rpx 30rpx;
  font-size: 26rpx;
  color: #666;
  background-color: #fff;
  border-radius: 30rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.page-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 1rpx 4rpx rgba(0, 0, 0, 0.05);
}

.page-btn.disabled {
  opacity: 0.5;
  pointer-events: none;
}

.page-info {
  margin: 0 30rpx;
  font-size: 26rpx;
  color: #666;
}

/* 鍗曡瘝璇︽儏寮圭獥 */
.word-detail-modal {
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
  border-radius: 20rpx;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20rpx 40rpx rgba(0, 0, 0, 0.2);
  animation: slideUp 0.3s ease;
}

@keyframes slideUp {
  from { opacity: 0; transform: translateY(50rpx); }
  to { opacity: 1; transform: translateY(0); }
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
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
}

.modal-close {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40rpx;
  color: #999;
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

.word-pronunciation {
  display: flex;
  align-items: center;
  margin-bottom: 30rpx;
}

.word-phonetic {
  font-size: 30rpx;
  color: #666;
  margin-right: auto;
}

.play-btn {
  background: none;
  border: none;
  width: 70rpx;
  height: 70rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40rpx;
  background-color: rgba(33, 150, 243, 0.1);
  color: #2196f3;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.play-btn:active {
  transform: scale(1.1);
}

.word-meaning, .word-definition, .word-example, .word-categories {
  margin-bottom: 30rpx;
}

.meaning-label, .definition-label, .example-label, .categories-label {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 10rpx;
  display: block;
}

.meaning-text {
  font-size: 34rpx;
  color: #333;
  line-height: 1.5;
}

.definition-text {
  font-size: 28rpx;
  color: #666;
  line-height: 1.6;
}

.example-text {
  font-size: 28rpx;
  color: #03a9f4;
  font-style: italic;
  line-height: 1.6;
  padding: 15rpx;
  background-color: rgba(3, 169, 244, 0.05);
  border-left: 4rpx solid #03a9f4;
  border-radius: 0 8rpx 8rpx 0;
}

.categories-tags {
  display: flex;
  flex-wrap: wrap;
}

.category-tag {
  font-size: 26rpx;
  padding: 8rpx 20rpx;
  background-color: #f0f0f0;
  color: #666;
  border-radius: 30rpx;
  margin-right: 15rpx;
  margin-bottom: 10rpx;
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
  box-shadow: 0 4rpx 12rpx rgba(76, 175, 80, 0.2);
}

.modal-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.1);
}
</style>
