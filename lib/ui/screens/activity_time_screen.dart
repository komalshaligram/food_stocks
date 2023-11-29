import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/activity_time/activity_time_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_strings.dart';
import '../widget/custom_button_widget.dart';
import '../widget/activity_time_screen_shimmer_widget.dart';

class ActivityTimeScreenRoute {
  static Widget get route => const ActivityTimeScreen();
}

class ActivityTimeScreen extends StatelessWidget {
  const ActivityTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint(
        "isUpdate : ${args?.containsKey(AppStrings.isUpdateParamString)}}");
    return BlocProvider(
      create: (context) => ActivityTimeBloc()
        ..add(ActivityTimeEvent.getActivityTimeDetailsEvent(
          isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
              ? true
              : false,
        ))
        ..add(ActivityTimeEvent.defaultValueAddInListEvent(
          context: context,
        ))
        ..add(ActivityTimeEvent.getActivityTimeListEvent(
          context: context,
        )),
      child: ActivityTimeScreenWidget(),
    );
  }
}

class ActivityTimeScreenWidget extends StatelessWidget {
  ActivityTimeScreenWidget();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityTimeBloc, ActivityTimeState>(
      listener: (context, state) {},
      child: BlocBuilder<ActivityTimeBloc, ActivityTimeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              leadingWidth: 60,
              title: Text(AppLocalizations.of(context)!.activity_time,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: AppColors.blackColor)),
              leading: GestureDetector(
                  onTap: () {
                    if (!state.isUpdate) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.pushNamed(
                          context, RouteDefine.connectScreen.name);
                    } else {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.blackColor,
                  )),
            ),
            body: state.isShimmering
                ? ActivityTimeScreenShimmerWidget()
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_5,
                            vertical: AppConstants.padding_5),
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
                                      : getScreenWidth(context) * 0.27,
                                ),
                                Container(
                                    width: getScreenWidth(context) * 0.25,
                                    height: 20,
                                    child: Text(
                                      AppLocalizations.of(context)!.from_time,
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.smallFont,
                                        color: AppColors.textColor,
                                      ),
                                    )),
                                18.width,
                                Container(
                                    width: getScreenWidth(context) * 0.25,
                                    height: 20,
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
                            state.OperationTimeList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: state.OperationTimeList.length,
                                    shrinkWrap: true,
                                    // scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: AppConstants.padding_3),
                                        child: ActivityTimeRow(
                                          dayString: state
                                              .OperationTimeList[index]
                                              .dayString,
                                          rowIndex: index,
                                        ),
                                      );
                                    },
                                  )
                                : SizedBox(),
                            // SizedBox(
                            //   height: getScreenHeight(context) * 0.20,
                            // ),
                            40.height,
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getScreenWidth(context) * 0.08,
                                  right: getScreenWidth(context) * 0.08),
                              child: CustomButtonWidget(
                                buttonText: state.isUpdate
                                    ? AppLocalizations.of(context)!
                                        .save
                                        .toUpperCase()
                                    : AppLocalizations.of(context)!
                                        .next
                                        .toUpperCase(),
                                fontColors: AppColors.whiteColor,
                                isLoading: false,
                                onPressed: () {
                                  context.read<ActivityTimeBloc>().add(
                                          ActivityTimeEvent
                                              .activityTimeApiEvent(
                                        context: context,
                                      ));
                                },
                                bGColor: AppColors.mainColor,
                              ),
                            ),
                            20.height,
                            state.isUpdate
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(
                                        left: getScreenWidth(context) * 0.08,
                                        right: getScreenWidth(context) * 0.08),
                                    child: CustomButtonWidget(
                                      buttonText: AppLocalizations.of(context)!
                                          .skip
                                          .toUpperCase()
                                          .toUpperCase(),
                                      fontColors: AppColors.mainColor,
                                      borderColor: AppColors.mainColor,
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        Navigator.pushNamed(context,
                                            RouteDefine.fileUploadScreen.name);
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
            // bottomSheet: BottomSheet(
            //   backgroundColor: AppColors.whiteColor,
            //   onClosing: () {},
            //   builder: (BuildContext context) {
            //     return Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         10.height,
            //         Padding(
            //           padding: EdgeInsets.only(
            //               left: getScreenWidth(context) * 0.08,
            //               right: getScreenWidth(context) * 0.08),
            //           child: ButtonWidget(
            //             buttonText: state.isUpdate
            //                 ? AppLocalizations.of(context)!.save
            //                 : AppLocalizations.of(context)!.next,
            //             fontColors: AppColors.whiteColor,
            //             width: double.maxFinite,
            //             onPressed: () {
            //               context
            //                   .read<ActivityTimeBloc>()
            //                   .add(ActivityTimeEvent.activityTimeApiEvent(
            //                     context: context,
            //                   ));
            //             },
            //             bGColor: AppColors.mainColor,
            //           ),
            //         ),
            //         20.height,
            //         state.isUpdate
            //             ? SizedBox()
            //             : Padding(
            //                 padding: EdgeInsets.only(
            //                     left: getScreenWidth(context) * 0.08,
            //                     right: getScreenWidth(context) * 0.08),
            //                 child: ButtonWidget(
            //                   buttonText: AppLocalizations.of(context)!
            //                       .skip.toUpperCase()
            //                       .toUpperCase(),
            //                   fontColors: AppColors.mainColor,
            //                   borderColor: AppColors.mainColor,
            //                   width: double.maxFinite,
            //                   onPressed: () {
            //                     Navigator.pushNamed(
            //                         context, RouteDefine.fileUploadScreen.name);
            //                   },
            //                   bGColor: AppColors.whiteColor,
            //                 ),
            //               ),
            //         20.height
            //       ],
            //     );
            //   },
            // ),
          );
        },
      ),
    );
  }
}

class ActivityTimeRow extends StatelessWidget {
  final String dayString;
  final int rowIndex;

  ActivityTimeRow({super.key, required this.dayString, required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityTimeBloc, ActivityTimeState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            13.height,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_10),
                child: state.OperationTimeList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        //      scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.OperationTimeList.isNotEmpty
                            ? state.OperationTimeList[rowIndex].monday.length
                            : 0,
                        itemBuilder: (context, index) {
                          return state.OperationTimeList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: AppConstants.padding_10),
                                  child: Row(
                                    children: [
                                      index == 0
                                          ? Expanded(
                                            child: Container(
                                              /*  width: getScreenWidth(context) *
                                                    0.22,*/
                                                child: Text(
                                                  dayString,
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                    size: AppConstants.smallFont,
                                                    color: AppColors.textColor,
                                                  ),
                                                )),
                                          )
                                          : Container(
                                              width: getScreenWidth(context) *
                                                  0.22,
                                            ),
                                      SizedBox(
                                        width: getScreenWidth(context) < 380
                                            ? getScreenWidth(context) * 0.001
                                            : getScreenWidth(context) * 0.03,
                                      ),
                                      TimeContainer(
                                        openingIndex: 1,
                                        index: index,
                                        rowIndex: rowIndex,
                                        dayString: dayString,
                                        time: state.OperationTimeList[rowIndex]
                                            .monday[index].from!,
                                      ),
                                      15.width,
                                      TimeContainer(
                                        openingIndex: 0,
                                        index: index,
                                        dayString: dayString,
                                        rowIndex: rowIndex,
                                        time: state.OperationTimeList[rowIndex]
                                            .monday[index].until!,
                                      ),
                                      15.width,
                                      index == 0
                                          ? Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.blueColor,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            ActivityTimeBloc>()
                                                        .add(ActivityTimeEvent
                                                            .addMoreTimeZoneEvent(
                                                          rowIndex: rowIndex,
                                                          context: context,
                                                        ));
                                                  },
                                                  child: Icon(Icons.add,
                                                      color: AppColors
                                                          .whiteColor)),
                                            )
                                          : Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.redColor,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            ActivityTimeBloc>()
                                                        .add(ActivityTimeEvent
                                                            .deleteTimeZoneEvent(
                                                          rowIndex: rowIndex,
                                                          timeIndex: index,
                                                        ));
                                                  },
                                                  child: Icon(Icons.delete,
                                                      color: AppColors
                                                          .whiteColor)),
                                            ),
                                    ],
                                  ),
                                )
                              : CupertinoActivityIndicator();
                        },
                      )
                    : CupertinoActivityIndicator(),
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
    return BlocBuilder<ActivityTimeBloc, ActivityTimeState>(
      builder: (context, state) {
        return Container(
          height: 40,
          width: getScreenWidth(context) * 0.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppColors.borderColor),
              color: AppColors.whiteColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppConstants.padding_5,
                horizontal: AppConstants.padding_10),
            child: GestureDetector(
              onTap: () {
                var datetime = '';
                final DateFormat formatter = DateFormat('HH:mm');
                datetime = formatter.format(
                  DateTime.now().add(
                    Duration(minutes: 30 - DateTime.now().minute % 30),
                  ),
                );
                showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext c1) {
                      return Container(
                        // height: getScreenHeight(context) * 0.33,
                        padding: EdgeInsets.only(top: 6.0),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(AppConstants.radius_20),
                                topRight:
                                    Radius.circular(AppConstants.padding_20))),
                        child: DefaultTextStyle(
                          style: AppStyles.rkRegularTextStyle(
                            color: AppColors.blackColor,
                            size: getScreenWidth(context) <= 370
                                ? AppConstants.font_14
                                : AppConstants.font_22,
                          ),
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
                                        Duration(
                                            minutes: 30 -
                                                DateTime.now().minute % 30),
                                      ),
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      onDateTimeChanged: (value) {
                                        final DateTime time = value;
                                        final DateFormat formatter =
                                            DateFormat('HH:mm');
                                        if(openingIndex == 0 &&  datetime == AppStrings.timeString){
                                         datetime = AppStrings.hr24String;
                                        }
                                        else{
                                          datetime = formatter.format(time);
                                        }
                                      }),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      context.read<ActivityTimeBloc>().add(
                                          ActivityTimeEvent.timePickerEvent(
                                              context: context,
                                              rowIndex: rowIndex,
                                              timeIndex: index,
                                              openingIndex: openingIndex,
                                              time: datetime,
                                              timePickerContext: c1));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.borderColor
                                                .withOpacity(0.6),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    AppConstants.radius_5))),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: AppConstants.padding_30,
                                            vertical: AppConstants.padding_5),
                                        child: Text(
                                            AppLocalizations.of(context)!.ok))),
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
                    child: Text(time == AppStrings.timeString ? '' : time,
                        style: AppStyles.rkRegularTextStyle(
                          size: getScreenWidth(context) <= 370
                              ? AppConstants.smallFont
                              : AppConstants.mediumFont,
                          color: AppColors.blackColor,
                        )),
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

/*    CupertinoTimerPicker(
                                      mode: CupertinoTimerPickerMode.hm,
                                      minuteInterval: 30,
                                      initialTimerDuration: initialTimer,
                                      onTimerDurationChanged:
                                          (Duration changeTimer) {
                                        initialTimer = changeTimer;
                                        String time =
                                            '${changeTimer.inHours}:${changeTimer.inMinutes % 60}';
                                        var format = DateFormat("HH:mm");
                                        var start = format.parse(time);
                                        datetime =
                                            DateFormat.Hm().format(start);
                                      }),*/
