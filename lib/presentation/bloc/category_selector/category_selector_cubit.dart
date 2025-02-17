import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'category_selector_state.dart';

class CategorySelectorCubit extends Cubit<CategorySelectorState> {
  CategorySelectorCubit() : super(IncomeCategory());

  void incomeCubit() {
    emit(IncomeCategory());
  }

  void expenseCubit() {
    emit(ExpenseCategory());
  }
}
