import 'package:flutter/material.dart';

import 'app_empty_view.dart';
import 'app_error_view.dart';
import 'app_loading_view.dart';

enum AppViewState { loading, empty, error, content }

class AppStateWrapper extends StatelessWidget {
  const AppStateWrapper({
    super.key,
    required this.state,
    required this.child,
    this.onRetry,
    this.emptyMessage,
    this.errorMessage,
  });

  final AppViewState state;
  final Widget child;
  final VoidCallback? onRetry;
  final String? emptyMessage;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AppViewState.loading:
        return const AppLoadingView();

      case AppViewState.empty:
        return AppEmptyView(subtitle: emptyMessage, onAction: onRetry);

      case AppViewState.error:
        return AppErrorView(message: errorMessage, onRetry: onRetry);

      case AppViewState.content:
        return child;
    }
  }
}
