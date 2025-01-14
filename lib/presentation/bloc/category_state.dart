part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();
}

final class CategoryInitial extends CategoryState {
  late List<Category> categories = [];

  CategoryInitial() {
    CategoryServiceImpl().getCategories().then((value) {
      categories = value;
    });
  }

  @override
  List<Object?> get props => [categories];
}
