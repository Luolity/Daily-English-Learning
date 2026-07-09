# 每日英语学习助手

每日英语学习助手是一个基于 uni-app + Vue 3 + TypeScript 和 Spring Boot 的前后端分离英语学习系统。项目面向日常英语学习场景，后续将逐步建设用户认证、单词学习、生词收藏、记忆挑战、听力练习、学习统计、成就徽章和后台管理等功能。

## 技术栈

### 前端

- Vue 3
- TypeScript
- uni-app
- Vuex
- Axios
- ECharts

### 后端

- Java
- Spring Boot
- Spring Security
- JWT
- MyBatis-Plus
- MySQL
- Lombok

## 项目结构

```text
project-english-learning/
├── backend/                 # Spring Boot 后端服务
│   ├── src/main/java/       # 后端 Java 源码
│   ├── src/main/resources/  # 后端配置与 SQL 脚本
│   └── pom.xml              # 后端 Maven 配置
├── public/                  # 前端公共静态资源
├── src/                     # uni-app 前端源码
│   ├── components/          # 公共组件
│   ├── pages/               # 页面目录
│   ├── services/            # 接口请求封装
│   ├── static/              # 前端静态资源
│   ├── store/               # Vuex 状态管理
│   ├── utils/               # 工具方法
│   ├── App.vue              # 应用入口组件
│   ├── main.ts              # 应用入口
│   ├── manifest.json        # uni-app 应用配置
│   └── pages.json           # 页面与路由配置
├── package.json             # 前端依赖与脚本
├── tsconfig.json            # TypeScript 配置
└── vite.config.ts           # Vite 配置
```

## 运行方式

### 前端

```bash
npm install
npm run dev:h5
```

常用脚本：

```bash
npm run dev:h5          # H5 开发模式
npm run dev:mp-weixin   # 微信小程序开发模式
npm run build:h5        # H5 构建
npm run type-check      # TypeScript 类型检查
```

### 后端

1. 创建 MySQL 数据库：

```sql
CREATE DATABASE english_learning DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 按需调整 `backend/src/main/resources/application.properties` 中的数据库连接配置。

3. 启动后端服务：

```bash
cd backend
mvn spring-boot:run
```

默认后端端口为 `8081`。
