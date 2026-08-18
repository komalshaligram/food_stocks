import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../routes/app_routes.dart';
import '/ui/utils/constants/app_img_path.dart';
import '/ui/widget/common_app_bar.dart';
import '/ui/widget/sized_box_widget.dart';
import '../../bloc/return/return_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

class ScanReturnProductRoute {
  static Widget get route => const ScanReturnProductScreen();
}

class ScanReturnProductScreen extends StatelessWidget {
  const ScanReturnProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return BlocProvider(
        create: (context) => ReturnBloc()..add(ReturnEvent.getArgumentEvent(context: context, list: args ?? {})), child: const ScanReturnProduct());
  }
}

class ScanReturnProduct extends StatelessWidget {
  const ScanReturnProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ReturnBloc>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
        child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.scan_return_product,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () {
              Navigator.pushReplacementNamed(context, RouteDefine.returnListScreen.name);
            }),
      ),
      body: BlocBuilder<ReturnBloc, ReturnState>(builder: (context, state) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_scannerSection(context, bloc), _bottomSection(context, state, bloc)]);
      }),
    );
  }

  Widget _scannerSection(BuildContext context, ReturnBloc bloc) {
    return Expanded(
      child: InkWell(
        onTap: () {
          bloc.add(ReturnEvent.openScannerEvent(context: context));
        },
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(AppImagePath.scan, height: 80),
            8.height,
            Text(AppLocalizations.of(context)!.click_to_scan,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.greyColor, fontWeight: FontWeight.w400)),
          ]),
        ),
      ),
    );
  }

  Widget _bottomSection(BuildContext context, ReturnState state, ReturnBloc bloc) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.5,
      padding: const EdgeInsets.all(AppConstants.padding_20),
      color: AppColors.greyColor.withValues(alpha: 0.2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
        Text(AppLocalizations.of(context)!.enter_product_barcode,
            style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: Colors.black)),
        10.height,
        CustomFormField(
            inputFormat: [FilteringTextInputFormatter.digitsOnly],
            context: context,
            controller: state.barCodeController,
            keyboardType: TextInputType.phone,
            hint: '',
            fillColor: AppColors.whiteColor,
            textInputAction: TextInputAction.done,
            validator: ''),
        30.height,
        CustomButtonWidget(
            buttonText: AppLocalizations.of(context)!.next,
            bGColor: AppColors.mainColor,
            isLoading: state.isLoading,
            onPressed: () {
              bloc.add(ReturnEvent.scanProductEvent(context: context, barCode: state.barCodeController.text));
            },
            fontColors: AppColors.whiteColor),
        10.height
      ]),
    );
  }
}
