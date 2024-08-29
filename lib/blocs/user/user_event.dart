part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}
class InitializeSocket extends UserEvent {}

class UpdateUser extends UserEvent {
  final String userJson;

   UpdateUser(this.userJson);

 
}

class SetUserFromModel extends UserEvent {
  final UserModel user;

   SetUserFromModel(this.user);

}

class UpdateLocation extends UserEvent {
  final double latitude;
  final double longitude;

   UpdateLocation(this.latitude, this.longitude);

}

class LogoutUser extends UserEvent {}