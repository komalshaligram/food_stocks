import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bank_transfer/bank_transfer_bloc.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';

class BankTransferScreenRoute {
  static Widget get route => const BankTransferScreen();
}

class BankTransferScreen extends StatelessWidget {
  const BankTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankTransferBloc()..add(BankTransferEvent.getBankTransferInfoEvent(context: context)),
      child: const BankTransferWidget(),
    );
  }
}

class BankTransferWidget extends StatelessWidget {
  const BankTransferWidget({super.key});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<BankTransferBloc, BankTransferState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: l10n.bank_transfer_information,
            iconData: Icons.arrow_back_ios_new_rounded,
            trailingWidget: _buildAppBarIcon(),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 24),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.bank_transfer,
                          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.blackColor),
                        ),
                      ),
                      if (!state.isLoading && state.bankTransferDetails.isNotEmpty)
                        _buildCopyButton(context, state.bankTransferDetails, l10n),
                    ],
                  ),
                  16.height,
                  if (state.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CupertinoActivityIndicator(color: AppColors.mainColor)),
                    )
                  else if (state.bankTransferDetails.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          l10n.no_data,
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_15, color: AppColors.blackColor.withValues(alpha: 0.45)),
                        ),
                      ),
                    )
                  else
                    SelectableText(
                      state.bankTransferDetails,
                      style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_15,
                        color: AppColors.blackColor.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.account_balance_outlined, size: 21, color: AppColors.mainColor),
    );
  }

  Widget _buildCopyButton(BuildContext context, String details, AppLocalizations l10n) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: details)).then((_) {
            if (context.mounted) {
              CustomSnackBar.showSnackBar(context: context, title: l10n.copied, type: SnackBarType.success);
            }
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.mainColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_rounded, size: 16, color: AppColors.mainColor),
              const SizedBox(width: 4),
              Text(
                l10n.copy,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.mainColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
