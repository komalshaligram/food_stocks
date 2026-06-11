import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// תווית צ'יפ פשוטה למסך הסינון (UI בלבד, ללא מצב נבחר).
/// נשמרת כווידג'ט נפרד כדי שנוכל לעשות בה שימוש חוזר.
class FilterChipLabel extends StatelessWidget {
  const FilterChipLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

