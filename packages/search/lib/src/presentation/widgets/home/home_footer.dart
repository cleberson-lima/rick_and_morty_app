import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Logo and "Voltar ao topo" at the end of the home page.
class HomeFooter extends StatelessWidget {
  const HomeFooter({required this.onBackToTop, super.key});

  final VoidCallback onBackToTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 8, 24),
      child: Row(
        children: [
          const Expanded(child: AppLogo()),
          TextButton.icon(
            onPressed: onBackToTop,
            iconAlignment: IconAlignment.end,
            icon: const Icon(PhosphorIconsRegular.arrowUp, size: 16),
            label: const Text(AppStrings.backToTop),
          ),
        ],
      ),
    );
  }
}
