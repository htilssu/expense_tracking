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
    on<LoadUser>(_onLoadUser);
    on<ClearUser>(_onClearUser);
  }

  UserBloc.fromState(super.initialState) {
    on<LoadUser>(_onLoadUser);
    on<ClearUser>(_onClearUser);

    if (state is UserLoaded) {
      add(LoadUser((state as UserLoaded).user.id));
    }
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
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

  void _onClearUser(ClearUser event, Emitter<UserState> emit) {
    emit(UserInitial());
  }
}
