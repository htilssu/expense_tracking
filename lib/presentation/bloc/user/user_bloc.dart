import 'package:equatable/equatable.dart';
import 'package:expense_tracking/application/service/category_service_impl.dart';
import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/domain/repository/user_repository.dart';
import 'package:expense_tracking/domain/service/category_service.dart';
import 'package:expense_tracking/infrastructure/repository/user_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = UserRepositoryImpl();
  final CategoryService _categoryService = CategoryServiceImpl();

  UserBloc() : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<ClearUserEvent>(_onClearUser);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  UserBloc.fromState(super.initialState) {
    on<LoadUserEvent>(_onLoadUser);
    on<ClearUserEvent>(_onClearUser);
    on<UpdateUserEvent>(_onUpdateUser);

    if (state is UserLoaded) {
      add(LoadUserEvent((state as UserLoaded).user.id));
    }
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    try {
      var user = await _userRepository.findById(event.uid);
      var categories = await _categoryService.getCategories();
      user?.categories = categories;

      if (user != null) {
        emit(UserLoaded(user: user));
      } else {
        emit(UserError(message: 'Người dùng không tồn tại'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  void _onClearUser(ClearUserEvent event, Emitter<UserState> emit) {
    emit(UserInitial());
  }

  void _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      emit(UserLoaded(user: event.user));
    } else {
      emit(UserError(message: 'Người dùng không tồn tại'));
    }
  }
}
