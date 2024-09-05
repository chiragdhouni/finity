import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:finity/models/user_model.dart';
import 'package:finity/services/location_service.dart';
import 'package:finity/services/user_service.dart';
import 'package:meta/meta.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService = UserService();
  late IO.Socket _socket;
  UserModel _user = UserModel(
    id: '',
    name: '',
    email: '',
    token: '',
    address: '',
    password: '',
    location: [],
    itemsListed: [],
    events: [],
    notifications: [],
    itemsLended: [],
    itemsBorrowed: [],
    itemsRequested: [],
  );

  UserBloc() : super(UserInitial()) {
    on<InitializeSocket>(_onInitializeSocket);
    on<UpdateUser>(_onUpdateUser);
    on<SetUserFromModel>(_onSetUserFromModel);
    on<UpdateLocation>(_onUpdateLocation);
    on<LogoutUser>(_onLogoutUser);
    // on<LoadUserEvent>(_onLoadUser);
    // add(InitializeSocket());
  }

  void _onInitializeSocket(InitializeSocket event, Emitter<UserState> emit) {
    log('Initializing socket connection...');
    _socket = IO.io("http://192.168.29.160:3001", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      log('Connected to socket server');
      _joinUserRoom(); // Join the user's room after connecting
      _listenForUserUpdates();
    });

    _socket.on('disconnect', (_) {
      log('Disconnected from socket server');
    });

    _socket.on('connect_error', (error) {
      log('Connection error: $error');
    });

    _socket.on('error', (error) {
      log('Socket error: $error');
    });
  }

  void _joinUserRoom() {
    log('Joining room for user ID=${_user.id}');
    _socket.emit('join_room', {'roomId': "${_user.id}_room"});
  }

  void _listenForUserUpdates() {
    log('Setting up listener for user updates...');
    _socket.on('user_update', (data) {
      try {
        log('Received update for user ${_user.id}: $data');
        final updatedUserMap = data as Map<String, dynamic>;
        _user = UserModel.fromMap(updatedUserMap);
        // emit(UserLoaded(_user));
        log("User updated: ID=${_user.id}, Name=${_user.name}, ${_user.itemsListed.length} items listed");

        log('User updated: ID=${_user.id}, Name=${_user.name}');

        add(SetUserFromModel(_user));
      } catch (e) {
        log('Error decoding or setting user: $e');
      }
    });
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) {
    log('Setting user from JSON: ${event.userJson}');
    try {
      final userMap = jsonDecode(event.userJson);
      log('Decoded JSON: $userMap');

      if (userMap is Map<String, dynamic>) {
        log('Decoded userMap is a valid Map<String, dynamic>');
        _user = UserModel.fromMap(userMap['user']);
        log('User set with ID=${_user.id}, Name=${_user.name}');
        emit(UserLoaded(_user));
      } else {
        log('Error: Decoded userMap is not a Map<String, dynamic>');
        emit(UserError('Invalid user data structure'));
      }
    } catch (e) {
      log('Error decoding or setting user: $e');
      emit(UserError(e.toString()));
    }
  }

  void _onSetUserFromModel(SetUserFromModel event, Emitter<UserState> emit) {
    log('Setting user from model: ID=${event.user.id}, Name=${event.user.name}');
    _user = event.user;

    emit(UserLoaded(_user));
    log(event.user.itemsListed.length.toString());
  }

  Future<void> _onUpdateLocation(
      UpdateLocation event, Emitter<UserState> emit) async {
    log('Updating location for user ${_user.id} to [lat=${event.latitude}, long=${event.longitude}]');
    _user.location = [event.latitude, event.longitude];
    await LocationService.updateUserLocation(
        _user.id, event.longitude, event.latitude);
    emit(UserLoaded(_user));
  }

  void _onLogoutUser(LogoutUser event, Emitter<UserState> emit) {
    log('Logging out user ID=${_user.id}');
    _user = UserModel(
      id: '',
      name: '',
      email: '',
      token: '',
      address: '',
      password: '',
      location: [],
      events: [],
      notifications: [],
      itemsListed: [],
      itemsLended: [],
      itemsBorrowed: [],
      itemsRequested: [],
    );
    emit(UserInitial());
    log('User reset after logout');
  }

  // void _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
  //   try {
  //     emit(UserLoading());
  //     final user = await _userService.getUserById();
  //     emit(UserLoaded(user));
  //   } catch (e) {
  //     emit(UserError(e.toString()));
  //   }
  // }
}
