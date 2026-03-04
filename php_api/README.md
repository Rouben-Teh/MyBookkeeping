PHP 后端（轻量）

- 使用 SQLite (`bookkeeping.sqlite`) 存储交易。
- 初始化数据库：`php db_init.php`（会在当前目录创建 `bookkeeping.sqlite`）。
- 启动内置服务器：

```bash
php -S localhost:8000
# or
php -S 0.0.0.0:8000
```

API:

- `GET api.php?action=list` -> 返回交易列表
- `POST api.php?action=add` (JSON body: `{amount, note}`) -> 添加交易
- `GET api.php?action=delete&id=...` -> 删除交易（简单实现）
