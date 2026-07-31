<template>
  <view class="admin-container">
    <view class="header">
      <text class="title">单词管理</text>
      <button class="add-btn" @click="openAddModal">
        <svg-icon name="plus" color="#fff" :size="14" />
        <text class="add-btn-text">添加</text>
      </button>
    </view>

    <view class="toolbar">
      <view class="search-box">
        <input
          class="search-input"
          v-model="searchKeyword"
          placeholder="搜索单词或释义"
          confirm-type="search"
          @confirm="handleSearch"
        />
        <button class="search-btn" @click="handleSearch">搜索</button>
      </view>
      <view class="filter-row">
        <picker :range="categoryOptions" :value="categoryIndex" @change="onCategoryChange">
          <view class="picker-field">分类: {{ categoryOptions[categoryIndex] }}</view>
        </picker>
        <picker :range="difficultyOptions" :value="difficultyIndex" @change="onFilterDifficultyChange">
          <view class="picker-field">难度: {{ difficultyOptions[difficultyIndex] }}</view>
        </picker>
      </view>
    </view>

    <view v-if="loading" class="loading-tip">加载中...</view>
    <view v-else-if="wordList.length === 0" class="empty-tip">暂无单词，点击右上角添加</view>

    <view class="word-list" v-else>
      <view class="word-item" v-for="word in wordList" :key="word.id">
        <view class="word-info">
          <text class="word-text">{{ word.word }}</text>
          <text class="translation-text">{{ word.translation }}</text>
          <text class="meta-text">{{ word.difficulty || 'easy' }} · {{ word.partOfSpeech || '-' }}</text>
        </view>
        <view class="word-actions">
          <button class="action-btn edit-btn" @click="openEditModal(word)">
            <svg-icon name="edit" color="#2196f3" :size="14" />
            <text>编辑</text>
          </button>
          <button class="action-btn delete-btn" @click="confirmDelete(word)">
            <svg-icon name="trash" color="#f44336" :size="14" />
            <text>删除</text>
          </button>
        </view>
      </view>
    </view>

    <view class="pagination" v-if="!loading && totalPages > 0">
      <text class="page-info">第 {{ currentPage }}/{{ totalPages }} 页 · 每页 {{ pageSize }} 条 · 共 {{ totalItems }} 个单词</text>
      <view class="pagination-controls">
        <button class="page-btn" :disabled="currentPage <= 1" @click="goToPage(1)">首页</button>
        <button class="page-btn" :disabled="currentPage <= 1" @click="goToPage(currentPage - 1)">上一页</button>
        <button class="page-btn" :disabled="currentPage >= totalPages" @click="goToPage(currentPage + 1)">下一页</button>
        <button class="page-btn" :disabled="currentPage >= totalPages" @click="goToPage(totalPages)">末页</button>
      </view>
    </view>

    <!-- 添加/编辑弹窗 -->
    <view class="modal" v-if="showModal">
      <view class="modal-mask" @click="closeModal"></view>
      <view class="modal-content">
        <view class="modal-header">
          <text class="modal-title">{{ isEditing ? '编辑单词' : '添加新单词' }}</text>
        </view>
        <view class="modal-body">
          <input class="input" v-model="formWord.word" placeholder="单词 (如: hello)" />
          <input class="input" v-model="formWord.translation" placeholder="翻译 (如: 你好)" />
          <input class="input" v-model="formWord.phonetic" placeholder="音标 (可选)" />
          <input class="input" v-model="formWord.partOfSpeech" placeholder="词性 (如: n.)" />
          <input class="input" v-model="formWord.definition" placeholder="英文释义 (可选)" />
          <input class="input" v-model="formWord.example" placeholder="例句 (可选)" />
          <picker :range="formDifficultyLevels" :value="formDifficultyIndex" @change="onFormDifficultyChange">
            <view class="picker-field">难度: {{ formWord.difficulty }}</view>
          </picker>
          <picker :range="formCategoryOptions" :value="formCategoryIndex" @change="onFormCategoryChange">
            <view class="picker-field">分类: {{ formWord.categories[0] }}</view>
          </picker>
        </view>
        <view class="modal-footer">
          <button class="modal-btn" @click="closeModal">取消</button>
          <button class="modal-btn primary" :disabled="submitting" @click="submitWord">
            {{ submitting ? '保存中...' : '保存' }}
          </button>
        </view>
      </view>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue'
import { api } from '../../services/api'
import SvgIcon from '../../components/SvgIcon.vue'
import { calcTotalPages } from '../../utils/pagination'

const emptyForm = () => ({
  word: '',
  translation: '',
  phonetic: '',
  partOfSpeech: '',
  definition: '',
  example: '',
  difficulty: 'easy',
  categories: ['CET4']
})

export default defineComponent({
  name: 'WordManage',
  components: { SvgIcon },
  setup() {
    const wordList = ref<any[]>([])
    const loading = ref(false)
    const submitting = ref(false)
    const showModal = ref(false)
    const isEditing = ref(false)
    const editingId = ref<string | number | null>(null)
    const difficultyOptions = ['全部', 'easy', 'medium', 'hard']
    const formDifficultyLevels = ['easy', 'medium', 'hard']
    const formCategoryOptions = ['CET4', 'CET6', 'TOEFL', 'IELTS', 'GRE']
    const difficultyIndex = ref(0)
    const formDifficultyIndex = ref(0)
    const formCategoryIndex = ref(0)
    const categoryOptions = ['全部', 'CET4', 'CET6', 'TOEFL', 'IELTS', 'GRE']
    const categoryIndex = ref(0)
    const searchKeyword = ref('')
    const currentPage = ref(1)
    const pageSize = 20
    const totalPages = ref(0)
    const totalItems = ref(0)
    const formWord = ref(emptyForm())

    const getFilterParams = () => {
      const category = categoryIndex.value === 0 ? undefined : categoryOptions[categoryIndex.value]
      const difficulty = difficultyIndex.value === 0 ? undefined : difficultyOptions[difficultyIndex.value]
      const keyword = searchKeyword.value.trim() || undefined
      return { category, difficulty, keyword }
    }

    const fetchWords = async (page: number = currentPage.value): Promise<void> => {
      loading.value = true
      try {
        const { category, difficulty, keyword } = getFilterParams()

        const countRes = await api.wordCards.getWordCardCount(category, difficulty, keyword)
        const response = await api.wordCards.getWordCards(page, pageSize, category, difficulty, keyword)

        wordList.value = response.content || []
        const total = Math.max(countRes.totalItems, response.totalItems ?? 0)
        totalItems.value = total
        totalPages.value = calcTotalPages(total, pageSize)

        if (totalPages.value > 0 && page > totalPages.value) {
          return fetchWords(totalPages.value)
        }

        currentPage.value = response.currentPage || page
      } catch (error) {
        console.error('获取单词列表失败', error)
        uni.showToast({ title: '获取单词列表失败', icon: 'none' })
      } finally {
        loading.value = false
      }
    }

    const goToPage = (page: number) => {
      if (page < 1 || (totalPages.value > 0 && page > totalPages.value)) return
      fetchWords(page)
    }

    const handleSearch = () => {
      currentPage.value = 1
      fetchWords(1)
    }

    const onCategoryChange = (e: { detail: { value: number } }) => {
      categoryIndex.value = e.detail.value
      handleSearch()
    }

    const onFilterDifficultyChange = (e: { detail: { value: number } }) => {
      difficultyIndex.value = e.detail.value
      handleSearch()
    }

    const openAddModal = () => {
      isEditing.value = false
      editingId.value = null
      formWord.value = emptyForm()
      formDifficultyIndex.value = 0
      formCategoryIndex.value = 0
      showModal.value = true
    }

    const openEditModal = (word: any) => {
      isEditing.value = true
      editingId.value = word.id
      formWord.value = {
        word: word.word || '',
        translation: word.translation || '',
        phonetic: word.phonetic || '',
        partOfSpeech: word.partOfSpeech || '',
        definition: word.definition || '',
        example: word.example || '',
        difficulty: word.difficulty || 'easy',
        categories: Array.isArray(word.categories) && word.categories.length > 0
          ? word.categories
          : ['CET4']
      }
      formDifficultyIndex.value = Math.max(0, formDifficultyLevels.indexOf(formWord.value.difficulty))
      formCategoryIndex.value = Math.max(0, formCategoryOptions.indexOf(formWord.value.categories[0]))
      showModal.value = true
    }

    const closeModal = () => {
      showModal.value = false
    }

    const confirmDelete = (word: { id: number | string; word: string }) => {
      uni.showModal({
        title: '确认删除',
        content: `确定删除单词「${word.word}」吗？`,
        success: async (res) => {
          if (res.confirm) {
            await deleteWord(word.id)
          }
        }
      })
    }

    const deleteWord = async (id: number | string) => {
      try {
        await api.wordCards.deleteWordCard(id)
        uni.showToast({ title: '删除成功', icon: 'success' })
        fetchWords()
      } catch (error) {
        console.error('删除失败', error)
        uni.showToast({ title: '删除失败', icon: 'none' })
      }
    }

    const onFormDifficultyChange = (e: { detail: { value: number } }) => {
      formDifficultyIndex.value = e.detail.value
      formWord.value.difficulty = formDifficultyLevels[e.detail.value]
    }

    const onFormCategoryChange = (e: { detail: { value: number } }) => {
      formCategoryIndex.value = e.detail.value
      formWord.value.categories = [formCategoryOptions[e.detail.value]]
    }

    const submitWord = async () => {
      if (!formWord.value.word?.trim() || !formWord.value.translation?.trim()) {
        uni.showToast({ title: '单词和翻译不能为空', icon: 'none' })
        return
      }
      submitting.value = true
      const payload = {
        ...formWord.value,
        word: formWord.value.word.trim(),
        translation: formWord.value.translation.trim(),
        difficulty: formWord.value.difficulty as 'easy' | 'medium' | 'hard'
      }
      try {
        if (isEditing.value && editingId.value != null) {
          await api.wordCards.updateWordCard(editingId.value, payload)
          uni.showToast({ title: '更新成功', icon: 'success' })
        } else {
          await api.wordCards.createWordCard(payload)
          uni.showToast({ title: '添加成功', icon: 'success' })
        }
        closeModal()
        fetchWords()
      } catch (error) {
        console.error('保存失败', error)
        uni.showToast({ title: '保存失败', icon: 'none' })
      } finally {
        submitting.value = false
      }
    }

    onMounted(() => {
      fetchWords()
    })

    return {
      wordList,
      loading,
      submitting,
      showModal,
      isEditing,
      formWord,
      difficultyOptions,
      difficultyIndex,
      formDifficultyLevels,
      formDifficultyIndex,
      formCategoryOptions,
      formCategoryIndex,
      categoryOptions,
      categoryIndex,
      searchKeyword,
      currentPage,
      pageSize,
      totalPages,
      totalItems,
      openAddModal,
      openEditModal,
      closeModal,
      confirmDelete,
      submitWord,
      handleSearch,
      onCategoryChange,
      onFilterDifficultyChange,
      onFormDifficultyChange,
      onFormCategoryChange,
      goToPage
    }
  }
})
</script>

<style>
.admin-container {
  padding: 30rpx;
  background-color: #f8f9fa;
  min-height: 100vh;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
}

.add-btn {
  display: flex;
  align-items: center;
  gap: 6rpx;
  background-color: #4caf50;
  color: white;
  font-size: 26rpx;
  line-height: 1;
  padding: 8rpx 20rpx;
  border-radius: 8rpx;
}

.add-btn-text {
  color: white;
  font-size: 26rpx;
}

.toolbar {
  margin-bottom: 24rpx;
}

.search-box {
  display: flex;
  gap: 12rpx;
  margin-bottom: 16rpx;
}

.search-input {
  flex: 1;
  border: 1rpx solid #ddd;
  border-radius: 10rpx;
  padding: 15rpx;
  font-size: 28rpx;
  background: #fff;
}

.search-btn {
  background-color: #2196f3;
  color: #fff;
  font-size: 26rpx;
  padding: 0 24rpx;
  border-radius: 10rpx;
}

.filter-row {
  display: flex;
  gap: 16rpx;
}

.filter-row .picker-field {
  flex: 1;
  margin-bottom: 0;
}

.pagination {
  margin-top: 24rpx;
  padding: 20rpx;
  background: #fff;
  border-radius: 10rpx;
}

.page-info {
  display: block;
  text-align: center;
  font-size: 26rpx;
  color: #666;
  margin-bottom: 16rpx;
}

.pagination-controls {
  display: flex;
  justify-content: center;
  gap: 12rpx;
  flex-wrap: wrap;
}

.page-btn {
  font-size: 24rpx;
  padding: 8rpx 20rpx;
  border-radius: 8rpx;
  background: #f5f5f5;
  color: #333;
}

.page-btn[disabled] {
  opacity: 0.5;
}

.loading-tip,
.empty-tip {
  text-align: center;
  color: #999;
  font-size: 28rpx;
  padding: 60rpx 0;
}

.word-list {
  background: white;
  border-radius: 10rpx;
  padding: 20rpx;
}

.word-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #eee;
}

.word-info {
  display: flex;
  flex-direction: column;
  flex: 1;
}

.word-text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.translation-text {
  font-size: 28rpx;
  color: #666;
  margin-top: 10rpx;
}

.meta-text {
  font-size: 24rpx;
  color: #999;
  margin-top: 6rpx;
}

.word-actions {
  display: flex;
  gap: 12rpx;
  flex-shrink: 0;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 4rpx;
  padding: 6rpx 12rpx;
  border-radius: 6rpx;
  font-size: 24rpx;
  line-height: 1;
  background: transparent;
  border: 1rpx solid #e0e0e0;
}

.action-btn text {
  font-size: 24rpx;
}

.edit-btn {
  color: #2196f3;
}

.delete-btn {
  color: #f44336;
}

.modal {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-mask {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: rgba(0,0,0,0.5);
}

.modal-content {
  position: relative;
  width: 80%;
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
}

.modal-header {
  margin-bottom: 20rpx;
  text-align: center;
}

.modal-title {
  font-size: 32rpx;
  font-weight: bold;
}

.input,
.picker-field {
  border: 1rpx solid #ddd;
  border-radius: 10rpx;
  padding: 15rpx;
  margin-bottom: 20rpx;
  font-size: 28rpx;
}

.picker-field {
  color: #333;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 20rpx;
}

.modal-btn {
  margin-left: 20rpx;
  padding: 10rpx 30rpx;
  font-size: 28rpx;
  border-radius: 10rpx;
}

.modal-btn.primary {
  background-color: #4caf50;
  color: white;
}
</style>
