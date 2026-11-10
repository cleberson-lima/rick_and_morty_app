import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Search input: magnifying glass while empty, a clear button after typing.
class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: AppStrings.searchHint,
        suffixIcon: controller.text.isEmpty
            ? const Icon(PhosphorIconsRegular.magnifyingGlass)
            : IconButton(
                tooltip: AppStrings.clear,
                icon: const Icon(Icons.close),
                onPressed: onClear,
              ),
      ),
    );
  }
}
