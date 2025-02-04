import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../bloc/return/return_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScanReturnProductRoute {
  static Widget get route => const ScanReturnProductScreen();
}

class ScanReturnProductScreen extends StatelessWidget {
  const ScanReturnProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReturnBloc()..add(ReturnEvent.openScannerEvent(context: context)),
      child: const ScanReturnProduct(),
    );
  }
}

class ScanReturnProduct extends StatelessWidget {
  const ScanReturnProduct({super.key});

  @override
  Widget build(BuildContext context) {
    ReturnBloc bloc = context.read<ReturnBloc>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
        child: CommonAppBar(
          bgColor: AppColors.pageColor,
          title: AppLocalizations.of(context)!.scan_return_product,
          iconData: Icons.arrow_back_ios_sharp,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<ReturnBloc, ReturnState>(
    builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
               bloc.add(ReturnEvent.openScannerEvent(context: context));
              },
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SvgPicture.asset(
                      AppImagePath.scan,
                      height: 80,
                    )),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            padding: EdgeInsets.all(20),
            color: AppColors.greyColor.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(AppLocalizations.of(context)!.enter_product_barcode, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: Colors.black)),
                10.height,
                CustomFormField(
                  inputFormat: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  context: context,
                  controller: state.barCodeController,
                  keyboardType: TextInputType.phone,
                  hint: '',
                  fillColor: AppColors.whiteColor,
                  textInputAction: TextInputAction.done,
                  validator: '',
                ),
                30.height,
                CustomButtonWidget(
                  buttonText: AppLocalizations.of(context)!.next,
                  bGColor: AppColors.mainColor,
                   isLoading: state.isLoading,
                  onPressed: () {
                    bloc.add(ReturnEvent.scanProductEvent(context: context,barCode: state.barCodeController.text));
                  },
                  fontColors: AppColors.whiteColor,
                ),
                30.height,
              ],
            ),
          ),
        ],
      );
    }
      ),
    );
  }
}
