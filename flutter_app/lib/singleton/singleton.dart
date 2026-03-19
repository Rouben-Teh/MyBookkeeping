import 'package:my_bookkeeping/database/app_database.dart';
import 'package:my_bookkeeping/utils/app_state.dart';

class Global {
  static final AppState appState = AppState();
  static final AppDatabase appDatabase = AppDatabase();
}
