part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final BuildContext context;
  final String email;
  final String password;

  AuthLoginEvent(
      {required this.email, required this.password, required this.context});
}

class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String location;
  AuthSignUpEvent(
      {required this.email,
      required this.password,
      required this.location,
      required this.name});
}

// class AuthCheckRequestedEvent extends AuthEvent {}
