import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase/supabase_client.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _initialized = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get initialized => _initialized;

  AuthProvider() {
    _init();
  }

  void _init() {
    _user = supabase.auth.currentUser;

    supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      _initialized = true;
      notifyListeners();
    });

    _initialized = true;
  }

  /// LOGIN
  Future<void> login({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  /// REGISTER + INSERT USER PROFILE
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('User creation failed');
    }
    try {
      await supabase
          .from('users')
          .update({'name': name, 'phone': phone, 'address': address})
          .eq("user_id", user.id);
    } catch (e) {
      print("e");
      print(e);
      print("e");
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
