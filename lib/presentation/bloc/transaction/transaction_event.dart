part of 'transaction_bloc.dart';

@immutable
sealed class TransactionEvent {}

class LoadTransaction extends TransactionEvent {
  final User user;

  LoadTransaction(this.user);
}

class LoadMoreTransaction extends TransactionEvent {
  final User user;
  final int page;

  LoadMoreTransaction(this.user, this.page);
}
