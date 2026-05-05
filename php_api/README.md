Lightweight PHP Backend

- Stores transactions in SQLite (`bookkeeping.sqlite`).
- Initialize the database with: `php db_init.php` (creates `bookkeeping.sqlite` in the current directory).
- Start the built-in PHP server:

```bash
php -S localhost:8000
# or
php -S 0.0.0.0:8000
```

Main scripts:

- `api.php` - main API entry point
- `db.php` - database service
- `llm_tools.php` - LLM-related functionality
- `categories.php` - bookkeeping categories used by agent features

API Endpoints:

All requests use `api.php?action=...`.

- `POST api.php?action=register`
  - Request body JSON: `{ "email": "...", "password": "..." }`
  - Registers a new account.

- `POST api.php?action=login`
  - Request body JSON: `{ "email": "...", "password": "...", "device_type": "..." }`
  - Returns `id` and `token`.

- `POST api.php?action=logout`
  - Requires authentication token.
  - Revokes the current token.

- `GET api.php?action=list`
  - Requires authentication token.
  - Returns all transactions for the authenticated user.

- `POST api.php?action=month-list`
  - Requires authentication token.
  - Request body JSON: `{ "start": "...", "end": "..." }`
  - Returns transactions in the specified date range.

- `POST api.php?action=add`
  - Requires authentication token.
  - Request body JSON: `{ "id": "...", "category": "...", "amount": 0.0, "note": "...", "timestamp": 1234567890000 }`
  - Adds a new transaction.

- `POST api.php?action=delete`
  - Requires authentication token.
  - Request body JSON: `{ "id": "..." }`
  - Deletes a transaction if it belongs to the authenticated user.

- `POST api.php?action=soft-delete`
  - Requires authentication token.
  - Request body JSON: `{ "id": "..." }`
  - Marks a transaction as deleted without removing it from the database.

- `POST api.php?action=sync`
  - Requires authentication token.
  - Request body JSON: `{ "id": "...", "category": "...", "amount": 0.0, "note": "...", "timestamp": 1234567890000, "deleted": false }`
  - Inserts or updates a transaction record for sync.

- `POST api.php?action=chat`
  - Requires authentication token.
  - Request body JSON: `{ "message": "..." }`
  - Calls the LLM chat endpoint and returns a response.

- `POST api.php?action=get_chat_history`
  - Requires authentication token.
  - Returns stored LLM chat history.

Authentication:

- Pass `token` as a query parameter, POST body field, or `Authorization: Bearer <token>` header.
- Most endpoints require a valid user token except `register` and `login`.
