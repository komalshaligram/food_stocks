import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class AddCreditCardRoute {
  static Widget get route => AddCreditCard();
}

class AddCreditCard extends StatelessWidget {
  const AddCreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageColor,
      appBar: AppBar(
        surfaceTintColor: AppColors.pageColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: Align(
          alignment:
          context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)!.manage_credit_card,
            style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: AppColors.pageColor,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: SafeArea(child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomButtonWidget(
                buttonText:'Add Credit Card',

                fontColors: AppColors.mainColor,
                borderColor: AppColors.mainColor,
                isFromConnectScreen: true,
                onPressed: () {

                },
              ),
            ),
          ],
        ),
      ),),
    );
  }
}
