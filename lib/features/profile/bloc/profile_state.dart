import 'package:foody/core/models/user.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {
  final String msg;
  ProfileLoading({this.msg = 'Loading Profiles...'});
}

class ProfileLoaded extends ProfileState {
  final User profile;

  ProfileLoaded({required this.profile});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
