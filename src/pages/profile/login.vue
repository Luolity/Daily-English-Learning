<template>
  <view class="login-container">
    <view class="logo-section">
      <image src="/static/images/logo.png" class="logo" mode="aspectFit"></image>
      <text class="app-name">每日英语学习助手</text>
      <text class="slogan">让英语学习更高效</text>
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
        <text class="input-label">密码</text>
        <input 
          type="password" 
          v-model="password" 
          placeholder="请输入密码" 
          class="input-field"
        />
      </view>
      
      <view class="form-actions">
        <text class="forgot-password" @click="showResetPassword">忘记密码？</text>
      </view>
      
      <button class="login-btn" @click="handleLogin" :disabled="isLoading">
        <text v-if="!isLoading">登录</text>
        <text v-else>登录中...</text>
      </button>
      
      <view class="divider">
        <view class="divider-line"></view>
        <text class="divider-text">其他登录方式</text>
        <view class="divider-line"></view>
      </view>
      
      <view class="social-login">
        <view class="social-btn wechat" @click="handleWechatLogin">
          <text class="iconfont icon-wechat"></text>
        </view>
        <view class="social-btn qq" @click="handleQQLogin">
          <text class="iconfont icon-qq"></text>
        </view>
      </view>
    </view>
    
    <view class="register-section">
      <text>还没有账号？</text>
      <text class="register-link" @click="showRegister">立即注册</text>
    </view>
    
    <view class="agreement-section">
      <text class="agreement-text">
        登录即表示您同意
        <text class="agreement-link" @click="showUserAgreement">《用户协议》</text>
        和
        <text class="agreement-link" @click="showPrivacyPolicy">《隐私政策》</text>
      </text>
    </view>
  </view>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'Login',
  setup() {
    const store = useStore()
    const username = ref('')
    const password = ref('')
    const isLoading = ref(false)
    
    // 处理登录
    const handleLogin = async () => {
      try {
        // 表单验证
        if (!username.value.trim()) {
          uni.showToast({
            title: '请输入用户名',
            icon: 'none'
          });
          return;
        }
        
        if (!password.value) {
          uni.showToast({
            title: '请输入密码',
            icon: 'none'
          });
          return;
        }
        
        isLoading.value = true;
        
        // 调用登录接口
        await store.dispatch('login', {
          username: username.value.trim(),
          password: password.value
        });
        
        uni.showToast({
          title: '登录成功',
          icon: 'success'
        });
        
        // 登录成功后跳转到首页tabBar页面
        setTimeout(() => {
          uni.switchTab({
            url: '/pages/index/index'
          });
        }, 1500);
      } catch (error: any) {
        uni.showToast({
          title: error.message || '登录失败，请重试',
          icon: 'none'
        });
      } finally {
        isLoading.value = false;
      }
    }
    
    // 微信登录
    const handleWechatLogin = () => {
      uni.showToast({
        title: '微信登录功能开发中',
        icon: 'none'
      })
    }
    
    // QQ登录
    const handleQQLogin = () => {
      uni.showToast({
        title: 'QQ登录功能开发中',
        icon: 'none'
      })
    }
    
    // 显示注册页面
    const showRegister = () => {
      uni.navigateTo({
        url: '/pages/profile/register'
      });
    }
    
    // 显示重置密码
    const showResetPassword = () => {
      uni.showToast({
        title: '密码重置功能开发中',
        icon: 'none'
      })
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
      password,
      isLoading,
      handleLogin,
      handleWechatLogin,
      handleQQLogin,
      showRegister,
      showResetPassword,
      showUserAgreement,
      showPrivacyPolicy
    }
  }
})
</script>

<style>
.login-container {
  padding: 40rpx;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.logo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 60rpx;
  padding-top: 40rpx;
}

.logo {
  width: 180rpx;
  height: 180rpx;
  margin-bottom: 20rpx;
}

.app-name {
  font-size: 40rpx;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.slogan {
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

.form-actions {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 30rpx;
}

.forgot-password {
  font-size: 26rpx;
  color: #3cc51f;
}

.login-btn {
  width: 100%;
  height: 90rpx;
  line-height: 90rpx;
  background-color: #3cc51f;
  color: #ffffff;
  font-size: 32rpx;
  border-radius: 10rpx;
  margin-bottom: 40rpx;
}

.login-btn[disabled] {
  opacity: 0.7;
}

.divider {
  display: flex;
  align-items: center;
  margin-bottom: 40rpx;
}

.divider-line {
  flex: 1;
  height: 1rpx;
  background-color: #e0e0e0;
}

.divider-text {
  padding: 0 20rpx;
  font-size: 26rpx;
  color: #999;
}

.social-login {
  display: flex;
  justify-content: center;
}

.social-btn {
  width: 100rpx;
  height: 100rpx;
  border-radius: 50rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 0 30rpx;
}

.social-btn .iconfont {
  font-size: 50rpx;
  color: #ffffff;
}

.wechat {
  background-color: #07c160;
}

.qq {
  background-color: #12b7f5;
}

.register-section {
  display: flex;
  justify-content: center;
  margin-bottom: 40rpx;
  font-size: 28rpx;
}

.register-link {
  color: #3cc51f;
  margin-left: 10rpx;
}

.agreement-section {
  text-align: center;
  margin-top: auto;
  padding-bottom: 20rpx;
}

.agreement-text {
  font-size: 24rpx;
  color: #999;
  line-height: 1.5;
}

.agreement-link {
  color: #3cc51f;
}
</style> 