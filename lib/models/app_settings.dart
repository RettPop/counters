class AppSettings {
  const AppSettings({this.syncEnabled = false});

  final bool syncEnabled;

  AppSettings copyWith({bool? syncEnabled}) =>
      AppSettings(syncEnabled: syncEnabled ?? this.syncEnabled);
}
