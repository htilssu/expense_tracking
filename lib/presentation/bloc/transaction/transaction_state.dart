part of 'transaction_bloc.dart';

@immutable
sealed class TransactionState extends Equatable {}

final class TransactionInitial extends TransactionState {
  final User user;

  TransactionInitial(this.user);

  @override
  List<Object?> get props => [];
}

final class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;

  TransactionLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}
