part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();
}

final class LoadCategories extends CategoryEvent {
  final User user;
  final int? month;
  final int? year;

  const LoadCategories(this.user, {this.month, this.year});

  @override
  List<Object?> get props => [user, month, year];
}

final class AddCategory extends CategoryEvent {
  final Category category;

  const AddCategory(this.category);

  @override
  List<Object> get props => [category];
}
