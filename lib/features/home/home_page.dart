import 'package:flutter/material.dart';
import 'package:foody/core/observers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<AuthProvider>().logout(),
          child: Text('Logout'),
        ),
      ),
    );
  }
}
