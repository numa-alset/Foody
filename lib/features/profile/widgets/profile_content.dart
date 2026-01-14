import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/constatnt/app_colors.dart';
import 'package:foody/core/models/user.dart';
import 'package:foody/features/profile/bloc/profile_cubit.dart';

class ProfileContent extends StatelessWidget {
  final User user;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;

  const ProfileContent({
    super.key,
    required this.user,
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _Header(user: user),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Group fields in a modern card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _InputField(
                      label: "Full Name",
                      controller: nameCtrl,
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 20),
                    _InputField(
                      label: "Phone Number",
                      controller: phoneCtrl,
                      icon: Icons.phone_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    _InputField(
                      label: "Delivery Address",
                      controller: addressCtrl,
                      icon: Icons.location_on_rounded,
                    ),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: "Email", value: user.email),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _SaveButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  final updated = user.copyWith(
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    address: addressCtrl.text.trim(),
                  );
                  context.read<ProfileCubit>().updateProfile(updated);
                },
              ),

              const SizedBox(height: 32),

              _LogoutButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final User user;
  const _Header({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     colors: [AppColors.darkOrange, AppColors.orange],
      //   ),
      //   borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
      // ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 54,
                backgroundColor: Colors.orange.shade300,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.orange,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  margin: EdgeInsets.fromLTRB(60, 0, 0, 0),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.orange, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: label == "Full Name"
          ? TextCapitalization.words
          : TextCapitalization.none,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return '$label is required';
        if (label == "Phone Number" && v.length < 7) {
          return 'Invalid phone number 7+ digits';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.orange.withOpacity(0.8)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.orange, width: 2),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text("Save Changes", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<ProfileCubit>().logout(context),
      child: const Text("Logout", style: TextStyle(color: Colors.red)),
    );
  }
}
