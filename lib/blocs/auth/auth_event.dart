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
  final String address;
  AuthSignUpEvent(
      {required this.email,
      required this.password,
      required this.address,
      required this.name});
}

class AuthLogoutEvent extends AuthEvent {
  final BuildContext context;
  AuthLogoutEvent({required this.context});
}
