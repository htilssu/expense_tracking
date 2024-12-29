part of 'user_bloc.dart';

@immutable
sealed class UserEvent extends Equatable {}

final class LoadUser extends UserEvent {
  final String uid;

  LoadUser(this.uid);

  @override
  List<Object?> get props => [uid];
}

final class ClearUser extends UserEvent {
  @override
  List<Object?> get props => [];
}