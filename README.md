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

### 后端

1. 创建 MySQL 数据库：

```sql
CREATE DATABASE english_learning DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 导入初始化数据：

```bash
mysql -u root -p english_learning < backend/src/main/resources/sql.sql
```

3. 当前数据库连接配置位于 `backend/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/english_learning?useSSL=false&serverTimezone=UTC&characterEncoding=utf8&allowPublicKeyRetrieval=true
    username: root
    password: "123456"
```

如本地 MySQL 的地址、账号或密码不同，请按实际环境修改上述配置。

4. 启动后端服务：

```bash
cd backend
mvn spring-boot:run
```

默认后端端口为 `8081`。

## 管理员账号

导入 `backend/src/main/resources/sql.sql` 后，可使用以下管理员账号登录：

| 用户名 | 密码 | 角色 |
| --- | --- | --- |
| `admin` | `123456` | 管理员 |
