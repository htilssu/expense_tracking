import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(NotLoading());

  void showLoading() {
    emit(Loading());
  }

  void hideLoading() {
    emit(NotLoading());
  }
}
