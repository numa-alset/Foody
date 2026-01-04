import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Supabase Flutter Demo', home: MyWidget());
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  User? _user;
  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  Future<void> _getAuth() async {
    setState(() {
      _user = Supabase.instance.client.auth.currentUser;
    });
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _user = data.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Example')),
      body: _user == null ? const _LoginForm() : const _ProfileForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  bool _loading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(label: Text('Email')),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(label: Text('Password')),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  final ScaffoldMessengerState scaffoldMessenger =
                      ScaffoldMessenger.of(context);
                  try {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    await Supabase.instance.client.auth.signInWithPassword(
                      email: email,
                      password: password,
                    );
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Login failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  final ScaffoldMessengerState scaffoldMessenger =
                      ScaffoldMessenger.of(context);
                  try {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    await Supabase.instance.client.auth.signUp(
                      email: email,
                      password: password,
                    );
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Signup failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                child: const Text('Signup'),
              ),
            ],
          );
  }
}

class _ProfileForm extends StatefulWidget {
  const _ProfileForm();

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  bool _loading = true;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUser();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final user = Supabase.instance.client.auth.currentUser!;
      final data = await Supabase.instance.client
          .from('users')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (data != null) {
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
      } else {
        // Create row if it doesn't exist
        await Supabase.instance.client.from('users').insert({
          'user_id': user.id,
          'email': user.email,
        });
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to load user'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveUser() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      setState(() => _loading = true);

      final user = Supabase.instance.client.auth.currentUser!;

      await Supabase.instance.client.from('users').upsert({
        'user_id': user.id,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
      });

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Error saving profile'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Phone'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Address'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: _saveUser, child: const Text('Save')),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Supabase.instance.client.auth.signOut(),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
