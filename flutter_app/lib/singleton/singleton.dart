import 'package:my_bookkeeping/database/app_database.dart';

import '../utils/app_state.dart';

class Global {
  static final AppState appState = AppState();
  static final AppDatabase appDatabase = AppDatabase();
}
