import 'package:equatable/equatable.dart';
import 'package:expense_tracking/application/service/category_service_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/category.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial());

 /* CategoryBloc.fromState(super.initialState) {
  }*/
}
