import 'package:flutter/material.dart';

import 'app_network_image.dart';

/// Card used by search results and favorites: leading image or icon,
/// title, subtitle lines and an optional trailing widget (e.g. favorite).
class ResultCard extends StatelessWidget {
  const ResultCard({
    required this.title,
    this.subtitle,
    this.caption,
    this.imageUrl,
    this.fallbackIcon = Icons.public,
    this.footer,
    this.trailing,
    this.onTap,
    super.key,
  });

  static const height = 104.0;

  final String title;
  final String? subtitle;
  final String? caption;
  final String? imageUrl;
  final IconData fallbackIcon;
  final Widget? footer;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              SizedBox.square(
                dimension: height,
                child: imageUrl != null
                    ? AppNetworkImage(url: imageUrl!, width: height)
                    : ColoredBox(
                        color: theme.colorScheme.primaryContainer,
                        child: Icon(
                          fallbackIcon,
                          size: 40,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (caption != null)
                        Text(
                          caption!,
                          style: muted,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (footer != null) ...[
                        const SizedBox(height: 4),
                        footer!,
                      ],
                    ],
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
