import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/bloc/home/home_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/custom_text_icon_button_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeRoute {
  static Widget get route => const HomeScreen();
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomeScreenWidget(),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
  //   HomeBloc bloc = context.read<HomeBloc>();
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {},
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Column(
                children: [
                  //appbar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor
                                          .withOpacity(0.3),
                                      blurRadius: 10)
                                ],
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.asset(
                                AppImagePath.profileImage,
                              ),
                            ),
                            Image.asset(
                              AppImagePath.companyLogo,
                              height: 60,
                            ),
                          ],
                        ),
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColors.shadowColor.withOpacity(0.3),
                                    blurRadius: 10)
                              ],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppConstants.radius_100))),
                          clipBehavior: Clip.hardEdge,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 54,
                                width: 54,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.iconBGColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppConstants.radius_100)),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppConstants.radius_100)),
                                  onTap: () {
                                    Navigator.pushNamed(context, RouteDefine.messageScreen.name);
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      SvgPicture.asset(
                                        AppImagePath.message,
                                        height: 26,
                                        width: 24,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      Positioned(
                                          right: 7,
                                          top: 8,
                                          child: Container(
                                            height: 16,
                                            width: 16,
                                            decoration: BoxDecoration(
                                                color: AppColors.mainColor,
                                                border: Border.all(
                                                    color: AppColors.whiteColor,
                                                    width: 1),
                                                shape: BoxShape.circle),
                                            alignment: Alignment.center,
                                            child: Text('4',
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                        size:
                                                            AppConstants.font_8,
                                                        color: AppColors
                                                            .whiteColor)),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_100)),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteDefine.menuScreen.name);
                                },
                                child: SvgPicture.asset(
                                  AppImagePath.menuVertical,
                                  fit: BoxFit.scaleDown,
                                  width: 54,
                                  height: 54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.height,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          10.height,
                          //dashboard stats
                          Container(
                            width: getScreenWidth(context),
                            clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_10),
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding_10,
                                horizontal: AppConstants.padding_10),
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor
                                          .withOpacity(0.15),
                                      blurRadius: 10)
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0))),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .balance_status,
                                          style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont,
                                            color: AppColors.blackColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        6.height,
                                        SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: SfRadialGauge(
                                            backgroundColor: Colors.transparent,
                                            animationDuration: 300,
                                            axes: [
                                              RadialAxis(
                                                minimum: 0,
                                                maximum: 10000,
                                                showLabels: false,
                                                showTicks: false,
                                                startAngle: 270,
                                                endAngle: 270,
                                                // radiusFactor: 0.8,
                                                axisLineStyle: AxisLineStyle(
                                                    thicknessUnit:
                                                        GaugeSizeUnit.factor,
                                                    thickness: 0.2,
                                                    color:
                                                        AppColors.borderColor),
                                                annotations: [
                                                  GaugeAnnotation(
                                                    angle: 270,
                                                    widget: Text(
                                                      '7550\n${AppLocalizations.of(context)!.currency}',
                                                      style: AppStyles
                                                          .rkRegularTextStyle(
                                                              size: AppConstants
                                                                  .font_14,
                                                              color: AppColors
                                                                  .blackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                                pointers: [
                                                  RangePointer(
                                                    color: AppColors.mainColor,
                                                    enableAnimation: true,
                                                    cornerStyle:
                                                        CornerStyle.bothCurve,
                                                    value: 7550,
                                                    width: 6,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                5.width,
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: dashboardStatsWidget(
                                                context: context,
                                                image: AppImagePath.credits,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .general_framework,
                                                value:
                                                    '20,000${AppLocalizations.of(context)!.currency}'),
                                          ),
                                          10.width,
                                          Flexible(
                                            child: dashboardStatsWidget(
                                                context: context,
                                                image: AppImagePath.expense,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .this_months_expenses,
                                                value:
                                                    '7,550${AppLocalizations.of(context)!.currency}'),
                                          ),
                                        ],
                                      ),
                                      10.height,
                                      Row(
                                        children: [
                                          Flexible(
                                            child: dashboardStatsWidget(
                                                context: context,
                                                image: AppImagePath.expense,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .last_months_expenses,
                                                value:
                                                    '18,360${AppLocalizations.of(context)!.currency}'),
                                          ),
                                          10.width,
                                          Flexible(
                                            child: dashboardStatsWidget(
                                                context: context,
                                                image: AppImagePath.orders,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .this_months_orders,
                                                value: '23'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          20.height,
                          titleRowWidget(
                              context: context,
                              title: AppLocalizations.of(context)!.promotions,
                              allContentTitle:
                                  AppLocalizations.of(context)!.all_promotions,
                              onTap: () {}),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: 10,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => productListItem(
                                  index: index, context: context),
                            ),
                          ),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: CustomTextIconButtonWidget(
                                  title:
                                      AppLocalizations.of(context)!.new_order,
                                  onPressed: () {},
                                  svgImage: AppImagePath.add,
                                ),
                              ),
                              Flexible(
                                child: CustomTextIconButtonWidget(
                                  title:
                                      AppLocalizations.of(context)!.my_basket,
                                  onPressed: () {},
                                  svgImage: AppImagePath.cart,
                                  cartCount: 12,
                                ),
                              ),
                            ],
                          ),
                          30.height,
                          titleRowWidget(
                              context: context,
                              title: AppLocalizations.of(context)!.messages,
                              allContentTitle:
                                  AppLocalizations.of(context)!.all_messages,
                              onTap: () {
                                Navigator.pushNamed(context, RouteDefine.messageScreen.name);
                              }),
                          10.height,
                          ListView.builder(
                            itemCount: 2,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                messageListItem(index: index, context: context),
                          ),
                          85.height,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget titleRowWidget(
      {required BuildContext context,
      required title,
      required allContentTitle,
      required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.blackColor),
          ),
          InkWell(
            onTap: onTap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              allContentTitle,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget productListItem({required int index, required BuildContext context}) =>
      Container(
        width: 140,
        padding: const EdgeInsets.symmetric(
            vertical: 5.0, horizontal: AppConstants.padding_10),
        margin: const EdgeInsets.symmetric(
            horizontal: 5.0, vertical: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: 10,
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  AppImagePath.product2,
                  width: 70,
                  height: 70,
                ),
              ),
              5.height,
              Text(
                AppLocalizations.of(context)!.enrollment,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_12,
                    color: AppColors.redColor,
                    fontWeight: FontWeight.w600),
              ),
              5.height,
              Text(
                "Buy 2 units of a variety of flat salted pretzels for a price of 250 grams",
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_10, color: AppColors.blackColor),
                maxLines: 3,
                overflow: TextOverflow.clip,
              ),
              5.height,
              CustomButtonWidget(
                  buttonText: "20${AppLocalizations.of(context)!.currency}",
                  bGColor: AppColors.mainColor,
                  height: 30,
                  radius: AppConstants.radius_3,
                  onPressed: () {}),
            ],
          ),
        ),
      );

  Widget dashboardStatsWidget(
      {required BuildContext context,
      required String image,
      required String title,
      required String value}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color: AppColors.iconBGColor),
      padding: const EdgeInsets.symmetric(
          horizontal: 7.0, vertical: AppConstants.padding_10),
      child: Row(
        children: [
          SvgPicture.asset(image),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_10, color: AppColors.mainColor),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  value,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messageListItem({required int index, required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppImagePath.message,
            fit: BoxFit.scaleDown,
            height: 16,
            width: 16,
            colorFilter:
                ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn),
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'כותרת של ההודעה',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_12,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500),
                ),
                5.height,
                Text(
                  'גולר מונפרר סוברט לורם שבצק יהול, לכנוץ בעריר גק ליץ, ושבעגט ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי מגמש. תרבנך וסתעד לכנו סתשם השמה - לתכי מורגם בורק? לתיג ישבעס.',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_10,
                      color: AppColors.blackColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '15.02.2023',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_12,
                          color: AppColors.blackColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteDefine.messageContentScreen.name, arguments: {AppStrings.messageContentString: index});
                      },
                      child: Text(
                        AppLocalizations.of(context)!.read_more,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_12,
                            color: AppColors.mainColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
