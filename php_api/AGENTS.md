# Agent Handoff Notes

This repository is a lightweight PHP backend for a bookkeeping app. It uses plain PHP scripts, SQLite, and no framework or Composer dependencies.

## Project Shape

- `api.php` is the main HTTP API entry point. Every endpoint is selected with `api.php?action=...`.
- `db.php` opens `bookkeeping.sqlite` with PDO and exception mode.
- `db_init.php` creates the SQLite tables if they do not exist.
- `llm_tools.php` contains the local LLM integration and tool execution logic.
- `categories.php` returns the bookkeeping category list used in the LLM prompt.
- `bookkeeping.sqlite` is the live local SQLite database in this folder.
- `.htaccess` rewrites `/api` to `api.php` for Apache.
- `migration.php`, `add_column.php`, and `delete_column.php` are one-off database migration helpers. Treat them carefully; do not run casually.

## Running Locally

Initialize the database:

```bash
php db_init.php
```

Start the PHP built-in server from this directory:

```bash
php -S localhost:8000
```

Example API base:

```text
http://localhost:8000/api.php?action=list
```

Most endpoints require a token. Tokens can be provided as:

- `Authorization: Bearer <token>`
- `?token=<token>`
- POST form field named `token`

## Database Schema

Current tables:

- `accounts`: user accounts with `email`, hashed `password`, and `created_at`.
- `tokens`: login tokens with `user_id`, `token`, `device_type`, `expired_at`, `is_revoked`.
- `transactions`: ledger rows with string `id`, `user_id`, `type` (`expense` or `income`), `category`, `amount`, `note`, millisecond `timestamp`, `synced`, and soft-delete flag `deleted`.
- `plans`: recurring/installment plan rows with `name`, `type`, `amount`, installment fields, interval fields, `auto_add_to_ledger`, `paid_installments`, `synced`, and `deleted`.
- `contacts`: contact form submissions.

Timestamps used by the API are generally Unix milliseconds. `created_at` fields are SQLite localtime text.

## API Endpoints

Authentication:

- `POST action=register`: body `{ "email": "...", "password": "..." }`.
- `POST action=login`: body `{ "email": "...", "password": "...", "device_type": "WEB|APP|..." }`; returns `{ id, token }`.
- `POST action=logout`: marks the current token as revoked.

Transactions:

- `GET action=list`: all transactions for current user, ordered by `timestamp DESC`.
- `POST action=month-list`: body `{ "start": <ms>, "end": <ms> }`; returns transactions where `timestamp >= start` and `< end`.
- `POST action=add`: body includes `id`, `type`, `category`, `amount`, `note`, `timestamp`.
- `POST action=delete`: hard-deletes by `id` after ownership check.
- `POST action=soft-delete`: sets `deleted = 1` after ownership check.
- `POST action=sync-transaction`: upserts a transaction by `id`.

Plans:

- `GET action=list-plans`: returns plans for current user ordered by `created_at ASC`.
- `POST action=sync-plan`: upserts a plan by `id`.

Stats:

- `GET action=streak`: returns distinct `DATE(created_at)` values from non-deleted transactions.
- `GET action=count`: returns count of non-deleted transactions.
- `POST action=statistic`: body `{ "start": <ms>, "end": <ms> }`; returns non-deleted transactions in range.

LLM and contact:

- `POST action=chat`: body `{ "message": "..." }`; calls the local LLM service.
- `POST action=get_chat_history`: fetches local LLM chat history.
- `POST action=contact`: body `{ "device_type": "...", "name": "...", "email": "...", "message": "..." }`; no auth required.

Note: `README.md` mentions `action=sync`, but the implemented endpoint is `action=sync-transaction`.

## LLM Integration

`llm_tools.php` posts to a service expected at:

```text
http://localhost:5000/api/chat
http://localhost:5000/api/get_chat_history
```

The prompt asks the model to return only JSON:

```json
{
  "type": "chat | tool",
  "content": "",
  "tool": {
    "name": "",
    "args": {}
  }
}
```

Implemented tool side effects:

- `add_expense`: inserts an expense transaction.
- `add_income`: inserts an income transaction.

Declared but not implemented:

- `get_total_expense`
- `get_total_income`

Important LLM details:

- The API key is currently hardcoded in `api.php`.
- `convertDateToTimestamp()` uses UTC and has a typo: it checks `"yesteday"` instead of `"yesterday"`.
- LLM-generated transaction IDs are built as `$user_id . round(microtime(true) * 1000)`.

## Known Cautions

- `getAuth()` currently does not enforce `is_revoked` or `expired_at`; the checks are present but commented out. Logout sets `is_revoked = 1`, but revoked tokens may still authenticate unless this is fixed.
- `api.php` contains mojibake comments, likely originally Chinese comments saved or displayed with the wrong encoding. Avoid touching them unless cleaning encoding intentionally.
- The default SQLite expression `((strftime('%s','now') * 1000, 'unixepoch', 'localtime'))` looks suspicious because of SQLite comma-expression behavior. Most API paths pass explicit millisecond timestamps, so test before relying on defaults.
- `sync-plan` accepts `user_id` from the body, defaulting to authenticated user. Consider whether clients should be allowed to override it.
- `month-list` does not filter out soft-deleted rows.
- `list` returns all rows including `deleted = 1`; some stats endpoints filter deleted rows.
- `streak` uses `DATE(created_at)` even though `created_at` is text localtime, while most other date filtering uses millisecond `timestamp`.
- Network calls to the LLM service are local only and will fail unless the service is running on port `5000`.

## Useful Verification Commands

Syntax-check PHP files:

```bash
php -l api.php
php -l db.php
php -l db_init.php
php -l llm_tools.php
php -l categories.php
```

Inspect SQLite schema:

```bash
sqlite3 bookkeeping.sqlite ".schema"
```

Quick smoke test after starting the server:

```bash
curl "http://localhost:8000/api.php?action=unknown"
```

Expected response is a JSON error like:

```json
{"error":"unknown action"}
```

## Git Note

In the Codex sandbox, `git status` may fail with "detected dubious ownership" because the repository owner differs from the sandbox user. Avoid changing global Git config unless the user asks or approves it.
