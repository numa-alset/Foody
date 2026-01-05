import 'package:flutter/material.dart';
import 'package:foody/core/observers/auth_provider.dart';
import 'package:foody/core/routing/routes_url.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      try {
                        await auth.register(
                          email: emailCtrl.text,
                          password: passwordCtrl.text,
                          name: nameCtrl.text,
                          phone: phoneCtrl.text,
                          address: addressCtrl.text,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration failed')),
                        );
                      }
                      setState(() => loading = false);
                    },
              child: const Text('Create Account'),
            ),
            TextButton(
              onPressed: () => context.go(RoutesUrl.login),
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
