<template>
  <view class="register-container">
    <view class="header">
      <text class="title">账号注册</text>
      <text class="subtitle">创建您的英语学习账号</text>
    </view>
    
    <view class="form-section">
      <view class="input-group">
        <text class="input-label">用户名</text>
        <input 
          type="text" 
          v-model="username" 
          placeholder="请输入用户名" 
          class="input-field"
        />
      </view>
      
      <view class="input-group">
        <text class="input-label">邮箱</text>
        <input 
          type="text" 
          v-model="email" 
          placeholder="请输入邮箱" 
          class="input-field"
        />
      </view>
      
      <view class="input-group">
        <text class="input-label">昵称</text>
        <input 
          type="text" 
          v-model="nickname" 
          placeholder="请输入昵称（选填）" 
          class="input-field"
        />
      </view>
      
      <view class="input-group">
        <text class="input-label">密码</text>
        <input 
          type="password" 
          v-model="password" 
          placeholder="请输入密码" 
          class="input-field"
        />
      </view>
      
      <view class="input-group">
        <text class="input-label">确认密码</text>
        <input 
          type="password" 
          v-model="confirmPassword" 
          placeholder="请再次输入密码" 
          class="input-field"
        />
      </view>
      
      <button class="register-btn" @click="handleRegister" :disabled="isLoading">
        <text v-if="!isLoading">注册</text>
        <text v-else>注册中...</text>
      </button>
      
      <view class="login-link">
        <text>已有账号？</text>
        <text class="link" @click="goToLogin">立即登录</text>
      </view>
    </view>
    
    <view class="agreement-section">
      <checkbox-group @change="onAgreementChange">
        <label class="agreement-label">
          <checkbox value="agree" :checked="isAgreed" color="#4caf50" />
          <text class="agreement-text">
            我已阅读并同意
            <text class="agreement-link" @click="showUserAgreement">《用户协议》</text>
            和
            <text class="agreement-link" @click="showPrivacyPolicy">《隐私政策》</text>
          </text>
        </label>
      </checkbox-group>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'Register',
  setup() {
    const store = useStore()
    const username = ref('')
    const email = ref('')
    const nickname = ref('')
    const password = ref('')
    const confirmPassword = ref('')
    const isLoading = ref(false)
    const isAgreed = ref(false)
    
    // 处理协议勾选
    const onAgreementChange = (e: any) => {
      isAgreed.value = e.detail.value.includes('agree')
    }
    
    // 处理注册
    const handleRegister = async () => {
      try {
        // 表单验证
        if (!username.value.trim()) {
          uni.showToast({
            title: '请输入用户名',
            icon: 'none'
          })
          return
        }
        
        if (!email.value.trim()) {
          uni.showToast({
            title: '请输入邮箱',
            icon: 'none'
          })
          return
        }
        
        if (!password.value) {
          uni.showToast({
            title: '请输入密码',
            icon: 'none'
          })
          return
        }
        
        if (password.value !== confirmPassword.value) {
          uni.showToast({
            title: '两次密码输入不一致',
            icon: 'none'
          })
          return
        }
        
        if (!isAgreed.value) {
          uni.showToast({
            title: '请先同意用户协议和隐私政策',
            icon: 'none'
          })
          return
        }
        
        isLoading.value = true
        
        // 调用注册接口
        await store.dispatch('register', {
          username: username.value.trim(),
          email: email.value.trim(),
          password: password.value,
          nickname: nickname.value.trim() || username.value.trim()
        })
        
        uni.showToast({
          title: '注册成功',
          icon: 'success'
        })
        
        // 注册成功后跳转到首页
        setTimeout(() => {
          uni.switchTab({
            url: '/pages/index/index'
          })
        }, 1500)
      } catch (error: any) {
        // 显示服务器返回的具体错误消息
        uni.showToast({
          title: error.message || '注册失败，请重试',
          icon: 'none',
          duration: 3000  // 延长显示时间，确保用户能看清错误信息
        })
      } finally {
        isLoading.value = false
      }
    }
    
    // 跳转到登录页
    const goToLogin = () => {
      uni.navigateBack()
    }
    
    // 显示用户协议
    const showUserAgreement = () => {
      uni.showModal({
        title: '用户协议',
        content: '这是用户协议内容...',
        showCancel: false
      })
    }
    
    // 显示隐私政策
    const showPrivacyPolicy = () => {
      uni.showModal({
        title: '隐私政策',
        content: '这是隐私政策内容...',
        showCancel: false
      })
    }
    
    return {
      username,
      email,
      nickname,
      password,
      confirmPassword,
      isLoading,
      isAgreed,
      handleRegister,
      goToLogin,
      onAgreementChange,
      showUserAgreement,
      showPrivacyPolicy
    }
  }
})
</script>

<style>
.register-container {
  padding: 40rpx;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.header {
  margin-bottom: 60rpx;
  padding-top: 40rpx;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.subtitle {
  font-size: 28rpx;
  color: #999;
}

.form-section {
  margin-bottom: 40rpx;
}

.input-group {
  margin-bottom: 30rpx;
}

.input-label {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 10rpx;
  display: block;
}

.input-field {
  width: 100%;
  height: 90rpx;
  background-color: #f5f5f5;
  border-radius: 10rpx;
  padding: 0 20rpx;
  font-size: 30rpx;
}

.register-btn {
  width: 100%;
  height: 90rpx;
  background: linear-gradient(135deg, #4caf50, #8bc34a);
  color: #fff;
  border-radius: 10rpx;
  font-size: 32rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 40rpx 0;
}

.register-btn[disabled] {
  opacity: 0.7;
}

.login-link {
  text-align: center;
  font-size: 28rpx;
  color: #333;
}

.link {
  color: #4caf50;
  margin-left: 10rpx;
}

.agreement-section {
  margin-top: 40rpx;
}

.agreement-label {
  display: flex;
  align-items: center;
  font-size: 26rpx;
}

.agreement-text {
  margin-left: 10rpx;
  color: #666;
}

.agreement-link {
  color: #4caf50;
}
</style> 