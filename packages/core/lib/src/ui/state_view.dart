import 'package:flutter/material.dart';

import '../error/failure.dart';
import 'failure_presentation.dart';

/// Centered illustration + message used for empty, not-found and error states.
class StateView extends StatelessWidget {
  const StateView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  const StateView.error({
    required String message,
    VoidCallback? onRetry,
    Key? key,
  }) : this(
         key: key,
         icon: Icons.cloud_off_outlined,
         title: 'Ops! Algo deu errado',
         message: message,
         actionLabel: onRetry == null ? null : 'Tentar novamente',
         onAction: onRetry,
       );

  /// Error state whose title, icon and message come from [failure].
  StateView.failure({required Failure failure, VoidCallback? onRetry, Key? key})
    : this(
        key: key,
        icon: failure.icon,
        title: failure.title,
        message: failure.message,
        actionLabel: onRetry == null ? null : 'Tentar novamente',
        onAction: onRetry,
      );

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.refresh),
                  label: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
