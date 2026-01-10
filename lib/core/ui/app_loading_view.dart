import 'package:flutter/material.dart';
import 'package:foody/core/ui/animated_state_container.dart';
import 'package:lottie/lottie.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message, this.height = 220});

  final String? message;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedStateContainer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/cart_empty.json',
              height: height,
              repeat: true,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Loading...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
