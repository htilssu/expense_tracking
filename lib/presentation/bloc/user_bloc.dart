import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/domain/repository/user_repository.dart';
import 'package:expense_tracking/infrastructure/repository/user_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository userRepository = UserRepositoryImpl();

  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<ClearUser>(_onClearUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    try {
      var user = await userRepository.findById(event.uid);
      if (user != null) {
        emit(UserLoaded(user: user));
      } else {
        emit(UserError(message: 'Người dùng không tồn tại'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  void _onClearUser(ClearUser event, Emitter<UserState> emit) {
    emit(UserInitial());
  }
}
