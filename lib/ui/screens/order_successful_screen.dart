import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/order_successful/order_successful_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../widget/confetti.dart';

class OrderSuccessfulRoute {
  static Widget get route => const OrderSuccessfulScreen();
}

class OrderSuccessfulScreen extends StatelessWidget {
  const OrderSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => OrderSuccessfulBloc()
        ..add(OrderSuccessfulEvent.getDataEvent(
            context: context,
            showPreviousBtn: args?[AppStrings.showPreviousBtn] ?? false,
            totalSupplier: args?[AppStrings.totalSupplier]))
        ..add(const OrderSuccessfulEvent.celebrationEvent()),
      child: const OrderSuccessfulScreenWidget(),
    );
  }
}

class OrderSuccessfulScreenWidget extends StatefulWidget {
  const OrderSuccessfulScreenWidget({super.key});

  @override
  State<OrderSuccessfulScreenWidget> createState() =>
      _OrderSuccessfulScreenWidgetState();
}

class _OrderSuccessfulScreenWidgetState
    extends State<OrderSuccessfulScreenWidget> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.play(AssetSource(AppStrings.successSound));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSuccessfulBloc, OrderSuccessfulState>(
        builder: (context, state) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: AppColors.pageColor,
          body: FocusDetector(
            onFocusGained: () {
              OrderSuccessfulBloc()
                  .add(OrderSuccessfulEvent.generalSettings(context: context));
            },
            child: SafeArea(
              child: Stack(children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_10,
                        vertical: AppConstants.padding_50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius_10),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.shadowColor
                                        .withValues(alpha: 0.10),
                                    blurRadius: AppConstants.blur_10)
                              ],
                            ),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      height: 180,
                                      width: 180,
                                      child: Image.asset(
                                          AppImagePath.successIcon)),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .order_sent_successfully,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_22,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  70.height,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.padding_20),
                                    child: Text(
                                      context
                                          .read<OrderSuccessfulBloc>()
                                          .message,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_17,
                                          color: AppColors.greyColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  50.height
                                ]),
                          ),
                          20.height,
                          const Expanded(flex: 5, child: SizedBox()),
                          state.seePreviousBtn
                              ? GestureDetector(
                                  onTap: () {
                                    context.read<OrderSuccessfulBloc>().add(
                                        OrderSuccessfulEvent.goToOrderEvent(
                                            context: context));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.padding_50),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor
                                          .withValues(alpha: 0.95),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.shadowColor
                                                .withValues(alpha: 0.20),
                                            blurRadius: AppConstants.blur_10)
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                              AppConstants.radius_40)),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppConstants.padding_5,
                                          horizontal: AppConstants.padding_5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.radius_40),
                                          color: AppColors.whiteColor),
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                            AppConstants.padding_10),
                                        height: AppConstants.containerHeight_60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: AppColors.navSelectedColor,
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radius_40)),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .back_to_order,
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.normalFont,
                                                color: AppColors.whiteColor)),
                                      ),
                                    ),
                                  ))
                              : 0.height,
                          20.height,
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteDefine.bottomNavScreen.name);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: AppConstants.padding_50),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor
                                      .withValues(alpha: 0.95),
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.shadowColor
                                            .withValues(alpha: 0.20),
                                        blurRadius: AppConstants.blur_10)
                                  ],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppConstants.radius_40)),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppConstants.padding_5,
                                      horizontal: AppConstants.padding_5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radius_40),
                                      color: AppColors.whiteColor),
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        AppConstants.padding_10),
                                    height: AppConstants.containerHeight_60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.navSelectedColor,
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.radius_40)),
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .back_to_home_page,
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.normalFont,
                                            color: AppColors.whiteColor)),
                                  ),
                                ),
                              )),
                        ]),
                  ),
                ),
                SizedBox.expand(
                  child: Visibility(
                    visible: state.duringCelebration,
                    child: IgnorePointer(
                        child: Confetti(
                            isStopped: !state.duringCelebration,
                            snippingCount: 200,
                            snipSize: 7.0)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
    });
  }
}
