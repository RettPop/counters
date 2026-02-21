import 'database.dart';

AppDatabase? _instance;

AppDatabase get appDatabase {
  _instance ??= AppDatabase();
  return _instance!;
}
