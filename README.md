Simple Accounting Project

Contains three sub-projects:

- `flutter_app`: Flutter mobile application example
- `vue_web`: Vue 3 web application example
- `php_api`: PHP backend (SQLite storage), providing a REST-like interface

Main Functions (Minimum Available Set):

- Accounting (Add/View/Modify/Delete Transactions)
- Categorization (Category Categorization)
- Note Detailed Description
- Monthly Summary (Sum by Month)
- Mobile and Web Data Synchronization
- Landing Page (Web)

Running Instructions (Brief):

- Flutter: Navigate to `flutter_app`, run `flutter pub get`, then `flutter run`.
- Vue: Navigate to `vue_web`, run `npm install`, then `npm run dev` (Requires Node.js).
- PHP: Go to `php_api` and run `php db_init.php` to initialize the database. After that, you can use the built-in server `php -S localhost:8000` to start the API with the current directory as the root.
