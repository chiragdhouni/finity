part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

// abstract class AuthActionState extends AuthState {}

class AuthLoading extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}
