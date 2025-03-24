part of 'user_bloc.dart';

@immutable
sealed class UserEvent extends Equatable {}

final class LoadUserEvent extends UserEvent {
  final String uid;

  LoadUserEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}

final class ClearUserEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}

final class UpdateUserEvent extends UserEvent {
  User user;

  UpdateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}
