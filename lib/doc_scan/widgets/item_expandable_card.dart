import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../core/utils/number_utils.dart';
import '../models/invoice_item.dart';

/// כרטיס פריט מתרחב – מקופל: מס', תיאור, סה"כ; פתוח: כל השדות.
class ItemExpandableCard extends StatefulWidget {
  const ItemExpandableCard({
    super.key,
    required this.item,
  });

  final InvoiceItem item;

  @override
  State<ItemExpandableCard> createState() => _ItemExpandableCardState();
}

class _ItemExpandableCardState extends State<ItemExpandableCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedCrossFade(
          firstChild: _buildCollapsed(theme),
          secondChild: _buildExpanded(theme, l10n),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }

  Widget _buildCollapsed(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${widget.item.lineNumber}',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.item.description,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatCurrency(widget.item.totalPrice),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            CupertinoIcons.chevron_down,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.item.lineNumber}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.item.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_up,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row(l10n.itemNumber, widget.item.itemNumber ?? '—'),
          _row(l10n.itemDescription, widget.item.description),
          _row(l10n.quantity, widget.item.quantity.toString()),
          if (widget.item.packages != null) _row(l10n.packages, '${widget.item.packages}'),
          if (widget.item.units != null) _row(l10n.units, '${widget.item.units}'),
          _row(l10n.pricePerUnitNis, formatCurrency(widget.item.pricePerUnit)),
          _row(l10n.totalNis, formatCurrency(widget.item.totalPrice),
              isBold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
