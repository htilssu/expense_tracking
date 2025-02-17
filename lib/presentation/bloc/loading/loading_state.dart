part of 'loading_cubit.dart';

sealed class LoadingState extends Equatable {
  const LoadingState();
}

final class NotLoading extends LoadingState {
  @override
  List<Object> get props => [];
}

final class Loading extends LoadingState {
  @override
  List<Object> get props => [];
}
