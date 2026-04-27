import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsLoaded());

  void toggleNotifications() {
    final current = state as SettingsLoaded;
    emit(current.copyWith(notificationsEnabled: !current.notificationsEnabled));
  }

  // TODO: connect logout / account / audio quality to API later
  void logout() {}
}
