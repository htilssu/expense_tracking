import 'package:equatable/equatable.dart';
import 'package:expense_tracking/application/service/category_service_impl.dart';
import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/domain/service/category_service.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/category.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService _categoryService = CategoryServiceImpl();

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>(_handleLoadCategories);
    on<AddCategory>(_handleAddCategory);
  }

  CategoryBloc.withUser(User user, {Key? key}) : super(CategoryInitial()) {
    on<LoadCategories>(_handleLoadCategories);
    on<AddCategory>(_handleAddCategory);

    add(LoadCategories(user));
  }

  void _handleLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    try {
      emit(const CategoryLoading());
      var categories = await _categoryService.getCategories(
          month: event.month, year: event.year);
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void _handleAddCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    if (state is CategoryLoaded) {
      var categories = (state as CategoryLoaded).categories;
      emit(CategoryLoaded([...categories, event.category]));
    }
  }
}
