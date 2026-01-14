import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/user.dart';
import 'package:foody/core/observers/auth_provider.dart';
import 'package:foody/core/supabase/supabase_client.dart';
import 'package:foody/features/profile/bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(ProfileError('User not authenticated'));
        return;
      }

      final profileResponse = await supabase
          .from('users')
          .select()
          .eq('user_id', userId)
          .single();

      final profile = User.fromJson(profileResponse);

      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError('Failed to load Profile: ${e.toString()}'));
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    emit(ProfileLoading(msg: "Updating profile..."));

    try {
      await supabase
          .from('users')
          .update({
            "name": updatedUser.name,
            "phone": updatedUser.phone,
            "address": updatedUser.address,
          })
          .eq('user_id', updatedUser.id);

      emit(ProfileLoaded(profile: updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> logout(BuildContext context) async {
    context.read<AuthProvider>().logout();
  }
}
