import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// "Filtrar por:" Personagens / Localizações / Episódios.
class FilterChips extends StatelessWidget {
  const FilterChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final ResourceType selected;
  final ValueChanged<ResourceType> onSelected;

  static const _options = [
    (ResourceType.character, PhosphorIconsRegular.smiley),
    (ResourceType.location, PhosphorIconsRegular.planet),
    (ResourceType.episode, PhosphorIconsRegular.monitorPlay),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(AppStrings.filterBy, style: theme.textTheme.labelMedium),
          for (final (type, icon) in _options) ...[
            const SizedBox(width: 8),
            Semantics(
              selected: type == selected,
              button: true,
              child: PillButton(
                key: ValueKey('filter-${type.name}'),
                label: AppStrings.resourcePluralLabel(type),
                icon: icon,
                filled: type == selected,
                onPressed: () => onSelected(type),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
