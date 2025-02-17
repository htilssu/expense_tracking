part of 'category_selector_cubit.dart';

@immutable
sealed class CategorySelectorState {}

final class IncomeCategory extends CategorySelectorState {}

final class ExpenseCategory extends CategorySelectorState {}
