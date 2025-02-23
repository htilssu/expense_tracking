import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/domain/repository/transaction_repository.dart';
import 'package:expense_tracking/infrastructure/repository/transaction_repostory_impl.dart';
import 'package:meta/meta.dart';

import '../../../domain/entity/transaction.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository =
  TransactionRepositoryImpl();

  TransactionBloc(TransactionInitial initialState) : super(initialState) {
    on<LoadTransaction>(_handleLoadTransaction);

    add(LoadTransaction(initialState.user));
  }

  void _handleLoadTransaction(LoadTransaction event,
      Emitter<TransactionState> emit) async {
    var transactions =
    await _transactionRepository.findRecentByUserId(event.user.id, 0, 30);

    emit(TransactionLoaded(transactions));
  }
}
