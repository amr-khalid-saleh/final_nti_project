import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // TODO: connect to API later
  Future<void> loadHomeData() async {
    emit(HomeLoading());
    // API call will go here
    emit(HomeLoaded());
  }
}
