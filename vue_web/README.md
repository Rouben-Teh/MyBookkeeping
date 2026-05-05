Vue 3 Web example

- Uses Vite + Vue 3.
- Landing page introduces the features of the bookkeeping web app.
- Login system: Login is required to access the transaction records for the relevant user.
- Token-based login (limited to 7 days), with an authentication system.
- Real-time data storage, deletion, and modification.
- Built-in local LLM provides simple agent services (conversational transaction recording). Chat content is managed by the LLM CMS, and history is retained for one day.
- The page can read and add transactions by communicating with a PHP backend at http://localhost:8000/api.php.
- Run:

```bash
cd vue_web
npm install
npm run dev
```
