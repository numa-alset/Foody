import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/user.dart';
import 'package:foody/core/ui/app_error_view.dart';
import 'package:foody/core/ui/app_loading_view.dart';
import 'package:foody/features/profile/bloc/profile_cubit.dart';
import 'package:foody/features/profile/bloc/profile_state.dart';
import 'package:foody/features/profile/widgets/profile_content.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController addressCtrl;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  void _initControllers(User user) {
    nameCtrl = TextEditingController(text: user.name);
    phoneCtrl = TextEditingController(text: user.phone);
    addressCtrl = TextEditingController(text: user.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return AppLoadingView(message: state.msg);
          }

          if (state is ProfileError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<ProfileCubit>().fetchProfile(),
            );
          }

          if (state is ProfileLoaded) {
            _initControllers(state.profile);
            return SafeArea(
              child: ProfileContent(
                user: state.profile,
                formKey: _formKey,
                nameCtrl: nameCtrl,
                phoneCtrl: phoneCtrl,
                addressCtrl: addressCtrl,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
