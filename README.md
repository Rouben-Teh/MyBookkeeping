简单记账项目骨架

包含三个子工程：

- `flutter_app`: Flutter 移动端应用示例
- `vue_web`: Vue 3 网页端示例
- `php_api`: PHP 后端（SQLite 存储），提供简单的 REST-like 接口

主要功能（最小可用集）：

- 记账（新增/查看/删除交易）
- 分类（简单文本分类）
- 每月汇总（按月份求和）

运行指引（简要）：

- Flutter: 进入 `flutter_app`，运行 `flutter pub get` 然后 `flutter run`。
- Vue: 进入 `vue_web`，运行 `npm install`，然后 `npm run dev`（需要 Node.js）。
- PHP: 进入 `php_api`，运行 `php db_init.php` 初始化数据库，之后可以用内置服务器 `php -S localhost:8000` 以当前目录为根启动 API。
