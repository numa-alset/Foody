import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:foody/core/observers/auth_provider.dart';
import 'package:foody/core/routing/routes_url.dart';
import 'package:foody/features/auth/widgets/login_logo.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;

  Future<void> _submit(AuthProvider auth) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await auth.register(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registration failed')));
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _passwordCtrl.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade700),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      errorStyle: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: Colors.red),
    );
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
                      const LoginLogo(),

                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          "Create Account",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),

                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildField(
                                context,
                                controller: _nameCtrl,
                                focus: _nameFocus,
                                hint: "Full Name",
                                textInputAction: TextInputAction.next,
                                onSubmit: () => _emailFocus.requestFocus(),
                              ),
                              _buildField(
                                context,
                                controller: _emailCtrl,
                                focus: _emailFocus,
                                hint: "Email",
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onSubmit: () => _phoneFocus.requestFocus(),
                                validator: (v) =>
                                    v!.contains('@') ? null : 'Invalid email',
                              ),
                              _buildField(
                                context,
                                controller: _phoneCtrl,
                                focus: _phoneFocus,
                                hint: "Phone",
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                onSubmit: () => _addressFocus.requestFocus(),
                              ),
                              _buildField(
                                context,
                                controller: _addressCtrl,
                                focus: _addressFocus,
                                hint: "Address",
                                textInputAction: TextInputAction.next,
                                onSubmit: () => _passwordFocus.requestFocus(),
                              ),
                              _buildField(
                                context,
                                controller: _passwordCtrl,
                                focus: _passwordFocus,
                                hint: "Password",
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                validator: (v) => v!.length < 6
                                    ? 'Minimum 6 characters'
                                    : null,
                                onSubmit: () => _submit(auth),
                              ),
                            ],
                          ),
                        ),
                      ),

                      FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: ElevatedButton(
                          onPressed: () => _submit(auth),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.orange,
                            ),
                          ),
                          child: const Text("Register"),
                        ),
                      ),

                      FadeInUp(
                        duration: const Duration(milliseconds: 2000),
                        child: TextButton(
                          onPressed: () => context.go(RoutesUrl.login),
                          child: Text(
                            "Already have an account? Login",
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
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focus,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    String? Function(String?)? validator,
    VoidCallback? onSubmit,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        focusNode: focus,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: _inputDecoration(context, hint),
        validator:
            validator ??
            (v) => v == null || v.isEmpty ? 'Required field' : null,
        onFieldSubmitted: (_) => onSubmit?.call(),
        onTapOutside: (_) => focus.unfocus(),
        onChanged: (_) => _formKey.currentState?.validate(),
      ),
    );
  }
}
