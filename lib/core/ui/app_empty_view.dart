import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    this.title,
    this.subtitle,
    this.onAction,
    this.actionText,
  });

  final String? title;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/empty.json', height: 220),
            const SizedBox(height: 16),
            Text(
              title ?? 'Nothing here',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? 'Try refreshing or come back later',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                // style: ButtonStyle(
                //   padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
                // ),
                onPressed: onAction,
                child: Text(actionText ?? 'Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
