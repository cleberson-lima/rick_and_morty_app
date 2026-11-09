import 'package:flutter/material.dart';

/// "Rick and Morty" wordmark. TODO(figma): replace with the exported LogoA.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // One line; scales down next to the "Lista de favoritos" button.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        'Rick and Morty',
        maxLines: 1,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
