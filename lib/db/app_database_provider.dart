// Temporary singleton accessor used before Riverpod DI is wired in Step 5.
// This file will be superseded by lib/providers/database_provider.dart.
// Do not use in production UI code.

import 'database.dart';

AppDatabase? _instance;

AppDatabase get appDatabase {
  _instance ??= AppDatabase();
  return _instance!;
}
