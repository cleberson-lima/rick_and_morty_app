import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../l10n/l10n.dart';
import 'failure_presentation.dart';

/// Centered illustration + message used for empty, not-found and error states.
class MessageView extends StatelessWidget {
  const MessageView({
    required IconData this.icon,
    required String this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : failure = null;

  /// Generic error with [message] and, when [onRetry] is given, "Tentar
  /// novamente".
  const MessageView.error({
    required String this.message,
    VoidCallback? onRetry,
    super.key,
  }) : icon = Icons.cloud_off_outlined,
       title = null,
       failure = null,
       actionLabel = null,
       onAction = onRetry;

  /// Error state whose title, icon and message come from [failure].
  const MessageView.failure({
    required Failure this.failure,
    VoidCallback? onRetry,
    super.key,
  }) : icon = null,
       title = null,
       message = null,
       actionLabel = null,
       onAction = onRetry;

  /// `null` only for [MessageView.failure], which takes [Failure.icon].
  final IconData? icon;

  /// `null` for the error constructors, which use the failure's title or
  /// "Ops! Algo deu errado".
  final String? title;
  final String? message;

  /// Defaults to "Tentar novamente" when [onAction] is set.
  final String? actionLabel;
  final VoidCallback? onAction;
  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final failure = this.failure;
    final icon = this.icon ?? failure!.icon;
    final title =
        this.title ?? failure?.title(l10n) ?? l10n.failureTitleGeneric;
    final message = this.message ?? failure?.message(l10n);
    final actionLabel = this.actionLabel ?? l10n.retry;
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
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (onAction != null) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.refresh),
                  label: Text(actionLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
