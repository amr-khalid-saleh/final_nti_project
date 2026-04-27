abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool notificationsEnabled;

  SettingsLoaded({this.notificationsEnabled = true});

  SettingsLoaded copyWith({bool? notificationsEnabled}) {
    return SettingsLoaded(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
