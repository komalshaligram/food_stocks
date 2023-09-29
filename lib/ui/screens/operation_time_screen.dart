import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import '../../bloc/operation_time/operation_time_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_strings.dart';
import '../widget/button_widget.dart';

class OperationTimeScreenRoute {
  static Widget get route => const OperationTimeScreen();
}

class OperationTimeScreen extends StatelessWidget {
  const OperationTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? data =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => OperationTimeBloc()
        ..add(OperationTimeEvent.defaultValueAddInListEvent())
        ..add(OperationTimeEvent.getProfileModelEvent(
            profileModel: data?[AppStrings.profileParamString])),
      child: OperationTimeScreenWidget(),
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
                  left: screenWidth * 0.04, right: screenWidth * 0.03),
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
                    rowIndex: 0,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString: AppLocalizations.of(context)!.monday,
                      rowIndex: 1),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString: AppLocalizations.of(context)!.tuesday,
                      rowIndex: 2),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString: AppLocalizations.of(context)!.wednesday,
                      rowIndex: 3),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString: AppLocalizations.of(context)!.thursday,
                      rowIndex: 4),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString:
                          AppLocalizations.of(context)!.friday_and_holiday_eves,
                      rowIndex: 5),
                  const SizedBox(
                    height: 15,
                  ),
                  OperationTimeRow(
                      dayString:
                          AppLocalizations.of(context)!.saturday_and_holidays,
                      rowIndex: 6),
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
  final int rowIndex;

  OperationTimeRow(
      {super.key, required this.dayString, required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperationTimeBloc, OperationTimeState>(
      builder: (context, state) {
        return Row(
          children: [
            const SizedBox(
              width: 13,
            ),
            SizedBox(
                width: 70,
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
            SizedBox(
              width: getScreenWidth(context) * 0.67,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.OperationTimeList.isNotEmpty
                    ? state.OperationTimeList[rowIndex].data.length
                    : 2,
                itemBuilder: (context, index) {
                  return state.OperationTimeList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              TimeContainer(
                                openingIndex: 1,
                                index: index,
                                rowIndex: rowIndex,
                                dayString: dayString,
                                time: state.OperationTimeList[rowIndex]
                                    .data[index].openingTime,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              TimeContainer(
                                openingIndex: 0,
                                index: index,
                                dayString: dayString,
                                rowIndex: rowIndex,
                                time: state.OperationTimeList[rowIndex]
                                    .data[index].closingTime,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              index == 0
                                  ? Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.blueColor,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<OperationTimeBloc>()
                                                .add(OperationTimeEvent
                                                    .addMoreTimeZoneEvent(
                                                        rowIndex: rowIndex));
                                          },
                                          child: Icon(Icons.add,
                                              color: AppColors.whiteColor)),
                                    )
                                  : Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.redColor,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<OperationTimeBloc>()
                                                .add(OperationTimeEvent
                                                    .deleteTimeZoneEvent(
                                                  rowIndex: rowIndex,
                                                  timeIndex: index,
                                                ));
                                          },
                                          child: Icon(Icons.delete,
                                              color: AppColors.whiteColor)),
                                    ),
                            ],
                          ),
                        )
                      : SizedBox();
                },
              ),
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
  final int rowIndex;
  final String dayString;
  final String time;

  TimeContainer(
      {super.key,
      required this.openingIndex,
      required this.index,
      required this.dayString,
      required this.time,
      required this.rowIndex});

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
            padding: const EdgeInsets.symmetric(
                vertical: AppConstants.padding_5,
                horizontal: AppConstants.padding_10),
            child: GestureDetector(
              onTap: () {
                context.read<OperationTimeBloc>().add(
                    OperationTimeEvent.timePickerEvent(
                        context: context,
                        rowIndex: rowIndex,
                        timeIndex: index,
                        openingIndex: openingIndex,
                        time: time));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(time == '0:0' ? '' : time,
                        style: AppStyles.rkRegularTextStyle(
                            size: 16,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400)),
                  ),
                  Icon(
                    CupertinoIcons.clock,
                    color: AppColors.greyColor,
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
