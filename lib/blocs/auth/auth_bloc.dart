import 'dart:async';
// import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:finity/services/auth_service.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthSignUpEvent>(_onSignUpRequested);
    on<AuthLoginEvent>(_onSignInRequested);
    on<AuthLogoutEvent>(_onLogoutRequested);
  }

  void _onSignUpRequested(
      AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signUpUser(
        email: event.email,
        password: event.password,
        name: event.name,
        address: event.address,
      );
      emit(AuthInitial());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  FutureOr<void> _onSignInRequested(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authService.signInUser(
        context: event.context,
        email: event.email,
        password: event.password,
      );
      if (res == "login successful") {
        emit(AuthAuthenticated());
      } else {
        emit(AuthErrorState("error from authrepo"));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  FutureOr<void> _onLogoutRequested(
      AuthLogoutEvent event, Emitter<AuthState> emit) {
    emit(AuthLoading());
    try {
      authService.logOut(event.context);
      emit(AuthInitial());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
