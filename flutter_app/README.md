Flutter Mobile Example

- Login system: Login is required to access the transaction records of the relevant user.
- Token-based login (limited to 7 days), and an authentication system.
- Simple transaction page: Add amounts and notes, display a transaction list, and allow modification and deletion.
- Transaction recording provides simple addition and subtraction functions.
- Built-in local LLM provides simple agent services (conversational transaction recording). Chat content is managed by the LLM CMS, and historical records are retained for one day.
- Uses offline data storage, temporarily providing synchronization and buttons for fetching server data.
- Uses `http` to access the local PHP API (ensure the built-in PHP server is running and accessible in the `php_api` directory).
