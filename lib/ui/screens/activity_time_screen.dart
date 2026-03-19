import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/activity_time/activity_time_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_strings.dart';
import '../widget/custom_button_widget.dart';
import '../widget/activity_time_screen_shimmer_widget.dart';

class ActivityTimeScreenRoute {
  static Widget get route => const ActivityTimeScreen();
}

class ActivityTimeScreen extends StatelessWidget {
  const ActivityTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => ActivityTimeBloc()
        ..add(ActivityTimeEvent.getActivityTimeDetailsEvent(
          isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false ? true : false,
        ))
        ..add(ActivityTimeEvent.defaultValueAddInListEvent(
          context: context,
        ))
        ..add(ActivityTimeEvent.getActivityTimeListEvent(
          context: context,
        )),
      child: const ActivityTimeScreenWidget(),
    );
  }
}

class ActivityTimeScreenWidget extends StatelessWidget {
  const ActivityTimeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityTimeBloc, ActivityTimeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            surfaceTintColor: AppColors.whiteColor,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            leadingWidth: 60,
            title: Align(
              alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(AppLocalizations.of(context)!.activity_time,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont,
                    color: AppColors.blackColor,
                  )),
            ),
            leading: GestureDetector(
                onTap: () {
                  if (!state.isUpdate) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.pop(context);
                  }
                },
                child: Icon(Icons.arrow_back_ios, color: AppColors.blackColor)),
          ),
          body: state.isShimmering
              ? const ActivityTimeScreenShimmerWidget()
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5, vertical: AppConstants.padding_5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              50.height,
                              SizedBox(
                                width: getScreenWidth(context) < 380
                                    ? getScreenWidth(context) * 0.25
                                    : getScreenWidth(context) >= 700
                                        ? getScreenWidth(context) * 0.35
                                        : getScreenWidth(context) * 0.27,
                              ),
                              SizedBox(
                                  width: getScreenWidth(context) >= 700 ? getScreenWidth(context) * 0.27 : getScreenWidth(context) * 0.25,
                                  height: getScreenHeight(context) >= 1000 ? 30 : 20,
                                  child: Text(
                                    AppLocalizations.of(context)!.from_time,
                                    style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor,
                                    ),
                                  )),
                              18.width,
                              SizedBox(
                                  width: getScreenWidth(context) >= 700 ? getScreenWidth(context) * 0.27 : getScreenWidth(context) * 0.25,
                                  height: getScreenHeight(context) >= 1000 ? 30 : 20,
                                  child: Text(
                                    AppLocalizations.of(context)!.until_time,
                                    style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor,
                                    ),
                                  )),
                              10.height,
                            ],
                          ),
                          state.operationTimeList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: state.operationTimeList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_3),
                                      child: ActivityTimeRow(
                                        dayString: state.operationTimeList[index].dayString,
                                        rowIndex: index,
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                          40.height,
                          Padding(
                            padding: EdgeInsets.only(left: getScreenWidth(context) * 0.08, right: getScreenWidth(context) * 0.08),
                            child: CustomButtonWidget(
                              buttonText: state.isUpdate ? AppLocalizations.of(context)!.save.toUpperCase() : AppLocalizations.of(context)!.next.toUpperCase(),
                              fontColors: AppColors.whiteColor,
                              isLoading: state.isLoading,
                              onPressed: () {
                                context.read<ActivityTimeBloc>().add(ActivityTimeEvent.activityTimeApiEvent(
                                      context: context,
                                    ));
                              },
                              bGColor: AppColors.mainColor,
                            ),
                          ),
                          20.height,
                          state.isUpdate
                              ? const SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(left: getScreenWidth(context) * 0.08, right: getScreenWidth(context) * 0.08),
                                  child: CustomButtonWidget(
                                    buttonText: AppLocalizations.of(context)!.skip.toUpperCase().toUpperCase(),
                                    fontColors: AppColors.mainColor,
                                    borderColor: AppColors.mainColor,
                                    isFromConnectScreen: true,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      Navigator.pushNamed(context, RouteDefine.formDataScreen.name);
                                    },
                                    bGColor: AppColors.whiteColor,
                                  ),
                                ),
                          20.height
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class ActivityTimeRow extends StatelessWidget {
  final String dayString;
  final int rowIndex;

  const ActivityTimeRow({super.key, required this.dayString, required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityTimeBloc, ActivityTimeState>(
      builder: (context, state) {
        return Row(
          children: [
            13.height,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                child: state.operationTimeList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.operationTimeList.isNotEmpty ? state.operationTimeList[rowIndex].monday.length : 0,
                        itemBuilder: (context, index) {
                          return state.operationTimeList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: AppConstants.padding_10),
                                  child: Row(
                                    children: [
                                      index == 0
                                          ? Expanded(
                                              child: Text(
                                                dayString,
                                                style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor),
                                              ),
                                            )
                                          : Expanded(
                                              child: Container(),
                                            ),
                                      SizedBox(
                                        width: getScreenWidth(context) < 380 ? getScreenWidth(context) * 0.001 : getScreenWidth(context) * 0.03,
                                      ),
                                      TimeContainer(
                                        openingIndex: 1,
                                        index: index,
                                        rowIndex: rowIndex,
                                        dayString: dayString,
                                        time: state.operationTimeList[rowIndex].monday[index].from ?? AppStrings.timeString,
                                      ),
                                      15.width,
                                      TimeContainer(
                                        openingIndex: 0,
                                        index: index,
                                        dayString: dayString,
                                        rowIndex: rowIndex,
                                        time: state.operationTimeList[rowIndex].monday[index].until ?? AppStrings.timeString,
                                      ),
                                      15.width,
                                      index == 0
                                          ? Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(color: AppColors.blueColor, borderRadius: BorderRadius.circular(AppConstants.radius_3)),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    context.read<ActivityTimeBloc>().add(ActivityTimeEvent.addMoreTimeZoneEvent(rowIndex: rowIndex, context: context));
                                                  },
                                                  child: Icon(Icons.add, color: AppColors.whiteColor)),
                                            )
                                          : Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(AppConstants.radius_3)),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    context.read<ActivityTimeBloc>().add(ActivityTimeEvent.deleteTimeZoneEvent(rowIndex: rowIndex, timeIndex: index));
                                                  },
                                                  child: Icon(Icons.delete, color: AppColors.whiteColor)),
                                            ),
                                    ],
                                  ),
                                )
                              : const CupertinoActivityIndicator();
                        },
                      )
                    : const CupertinoActivityIndicator(),
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

  const TimeContainer({super.key, required this.openingIndex, required this.index, required this.dayString, required this.time, required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityTimeBloc, ActivityTimeState>(
      builder: (context, state) {
        return Container(
          height: 40,
          width: getScreenWidth(context) * 0.26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radius_3),
            border: Border.all(color: AppColors.borderColor),
            color: AppColors.whiteColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
            child: GestureDetector(
              onTap: () {
                var datetime = '';
                final DateFormat formatter = DateFormat('HH:mm');
                datetime = formatter.format(
                  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30)),
                );
                showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext c1) {
                      return Container(
                        padding: const EdgeInsets.only(top: 6.0),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppConstants.radius_20),
                                topRight: Radius.circular(
                                  AppConstants.padding_20,
                                ))),
                        child: DefaultTextStyle(
                          style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: getScreenWidth(context) <= 370 ? AppConstants.font_14 : AppConstants.font_22),
                          child: SafeArea(
                            top: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: getScreenHeight(context) * 0.25,
                                  child: CupertinoDatePicker(
                                      minuteInterval: 30,
                                      initialDateTime: DateTime.now().add(
                                        Duration(minutes: 30 - DateTime.now().minute % 30),
                                      ),
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      onDateTimeChanged: (value) {
                                        final DateTime time = value;
                                        final DateFormat formatter = DateFormat('HH:mm');
                                        datetime = formatter.format(time);
                                      }),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      context.read<ActivityTimeBloc>().add(ActivityTimeEvent.timePickerEvent(
                                            context: context,
                                            rowIndex: rowIndex,
                                            timeIndex: index,
                                            openingIndex: openingIndex,
                                            time: datetime,
                                            previousTime: time,
                                            timePickerContext: c1,
                                          ));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.borderColor.withValues(alpha: 0.6),
                                            borderRadius: const BorderRadius.all(Radius.circular(
                                              AppConstants.radius_5,
                                            ))),
                                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_30, vertical: AppConstants.padding_5),
                                        child: Text(AppLocalizations.of(context)!.ok))),
                                10.height,
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                        time == AppStrings.timeString
                            ? ''
                            : time == '24:59'
                                ? ''
                                : time,
                        style: AppStyles.rkRegularTextStyle(size: getScreenWidth(context) <= 370 ? AppConstants.smallFont : AppConstants.mediumFont, color: AppColors.blackColor)),
                  ),
                  Icon(CupertinoIcons.clock, color: AppColors.greyColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
