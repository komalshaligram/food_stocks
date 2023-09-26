import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import '../../bloc/operation_time/operation_time_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../widget/button_widget.dart';

class OperationTimeScreenRoute {
  static Widget get route => const OperationTimeScreen();
}

class OperationTimeScreen extends StatelessWidget {
  const OperationTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OperationTimeBloc(),
      child: const OperationTimeScreenWidget(),
    );
  }
}

class OperationTimeScreenWidget extends StatelessWidget {
  const OperationTimeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<OperationTimeBloc, OperationTimeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            titleSpacing: 0,
            leadingWidth: 60,
            title: Text(AppLocalizations.of(context)!.operation_time,
                style: AppStyles.rkRegularTextStyle(
                    size: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor)),
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.blackColor,
                )),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.04, right: screenWidth * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 70,
                      ),
                      SizedBox(
                          width: 100,
                          height: 40,
                          child: Text(
                            AppLocalizations.of(context)!.from_an_hour,
                            style: AppStyles.rkRegularTextStyle(
                                size: 16,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w400),
                          )),
                      SizedBox(
                          width: 100,
                          height: 40,
                          child: Text(
                            AppLocalizations.of(context)!.to_an_hour,
                            style: AppStyles.rkRegularTextStyle(
                                size: 16,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w400),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  OperationTimeRow(
                    dayString: AppLocalizations.of(context)!.sunday,
                    index: 1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString: AppLocalizations.of(context)!.monday,
                      index: 2),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString: AppLocalizations.of(context)!.tuesday,
                      index: 3),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString: AppLocalizations.of(context)!.wednesday,
                      index: 4),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString: AppLocalizations.of(context)!.thursday,
                      index: 5),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString:
                          AppLocalizations.of(context)!.friday_and_holiday_eves,
                      index: 6),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString:
                          AppLocalizations.of(context)!.saturday_and_holidays,
                      index: 7),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    buttonText: AppLocalizations.of(context)!.continued,
                    fontColors: AppColors.whiteColor,
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouteDefine.fileUploadScreen.name);
                    },
                    bGColor: AppColors.mainColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    buttonText: AppLocalizations.of(context)!.skip,
                    fontColors: AppColors.mainColor,
                    borderColor: AppColors.mainColor,
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouteDefine.fileUploadScreen.name);
                    },
                    bGColor: AppColors.whiteColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OperationTimeRow extends StatelessWidget {
  final String dayString;
  final int index;

  OperationTimeRow({super.key, required this.dayString, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperationTimeBloc, OperationTimeState>(
      builder: (context, state) {
        return Row(
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  dayString,
                  style: AppStyles.rkRegularTextStyle(
                      size: 16,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.normal),
                )),
            const SizedBox(
              width: 15,
            ),
            TimeContainer(openingIndex: 1, index: index),
            const SizedBox(
              width: 10,
            ),
            TimeContainer(openingIndex: 0, index: index),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.blueColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.add, color: AppColors.whiteColor)),
            ),
          ],
        );
      },
    );
  }
}

class TimeContainer extends StatelessWidget {
  final int openingIndex;
  final int index;

  TimeContainer({super.key, required this.openingIndex, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperationTimeBloc, OperationTimeState>(
      builder: (context, state) {
        return Container(
          height: 40,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    index == 1 && openingIndex == 1
                        ? index == 1 && openingIndex == 0
                            ? state.time
                            : state.time
                        : "",
                    style: AppStyles.rkRegularTextStyle(
                        size: 16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400)),
                GestureDetector(
                    onTap: () {
                      context
                          .read<OperationTimeBloc>()
                          .add(OperationTimeEvent.timePickerEvent(
                            context: context,
                            index: index,
                            openingIndex: openingIndex,
                          ));
                    },
                    child: Icon(
                      CupertinoIcons.clock,
                      color: AppColors.greyColor,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
