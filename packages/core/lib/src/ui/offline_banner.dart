import 'package:flutter/material.dart';

import '../network/offline_status.dart';
import '../strings/app_strings.dart';

/// Puts [child] above a strip that reads "Sem conexão. Mostrando os dados
/// salvos." while [status] says the data on screen came from the offline
/// cache. The strip slides in and out on its own; used once, at the app root.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({required this.status, required this.child, super.key});

  final OfflineStatus status;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        ValueListenableBuilder<bool>(
          valueListenable: status,
          builder: (context, showingSavedData, _) => AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: showingSavedData
                ? const _Strip()
                : const SizedBox(width: double.infinity),
          ),
        ),
      ],
    );
  }
}

class _Strip extends StatelessWidget {
  const _Strip();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Material(
        color: scheme.inverseSurface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 18,
                color: scheme.onInverseSurface,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.offlineBanner,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onInverseSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
