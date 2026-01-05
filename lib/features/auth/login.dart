import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:foody/core/observers/auth_provider.dart';
import 'package:foody/core/routing/routes_url.dart';
import 'package:foody/features/auth/widgets/login_logo.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _isLoading = false;

  void _submit(auth) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await auth.login(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login failed')));
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoginLogo(),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  onTapOutside: (_) => _emailFocus.unfocus(),
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: "Username",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                    errorStyle: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.red),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Please enter your username'
                                      : null,
                                  onChanged: (_) =>
                                      _formKey.currentState!.validate(),
                                  onFieldSubmitted: (_) => FocusScope.of(
                                    context,
                                  ).requestFocus(_passwordFocus),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  onTapOutside: (_) => _passwordFocus.unfocus(),
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                    errorStyle: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.red),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) =>
                                      _formKey.currentState!.validate(),
                                  onFieldSubmitted: (_) => _submit(auth),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: ElevatedButton(
                          onPressed: () => _submit(auth),
                          child: const Text("Login"),
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 2000),
                        child: TextButton(
                          onPressed: () => context.go(RoutesUrl.register),
                          child: Text(
                            "Sign up for a new account",
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.amberAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // ),
    );
  }
}
