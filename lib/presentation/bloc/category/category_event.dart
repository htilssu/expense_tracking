part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();
}

final class LoadCategories extends CategoryEvent {
  final User user;

  const LoadCategories(this.user);

  @override
  List<Object> get props => [user];
}

final class AddCategory extends CategoryEvent {
  final Category category;

  const AddCategory(this.category);

  @override
  List<Object> get props => [category];
}
