import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:intl/intl.dart';
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
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => OperationTimeBloc()
        ..add(OperationTimeEvent.defaultValueAddInListEvent(context: context)),
      child: OperationTimeScreenWidget(id: args![AppStrings.idString]),
    );
  }
}

class OperationTimeScreenWidget extends StatelessWidget {
  String id = '';
  OperationTimeScreenWidget({super.key,required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OperationTimeBloc, OperationTimeState>(
      listener: (context, state) {
        if (state.isRegisterSuccess) {
          Navigator.pushNamed(context, RouteDefine.fileUploadScreen.name);
        }
        if (state.isRegisterFail) {
          showSnackBar(
              context: context,
              title: state.errorMessage,
              bgColor: AppColors.redColor);
        }
      },
      child: BlocBuilder<OperationTimeBloc, OperationTimeState>(
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
                      size: AppConstants.smallFont,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor)),
              leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.blackColor,
                  )),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.padding_5,
                      vertical: AppConstants.padding_5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          50.height,
                          12.width,
                          SizedBox(
                              width: getScreenWidth(context) * 0.245,
                              height: 40,
                              child: Text(
                                AppLocalizations.of(context)!.from_an_hour,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w400),
                              )),
                          SizedBox(
                              width: getScreenWidth(context) * 0.245,
                              height: 40,
                              child: Text(
                                AppLocalizations.of(context)!.to_an_hour,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w400),
                              )),
                          10.height,
                        ],
                      ),
                      ListView.builder(
                        itemCount: state.OperationTimeList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding_3),
                            child: OperationTimeRow(
                              dayString: state.OperationTimeList[index].dayString,
                              rowIndex: index,
                            ),
                          );
                        },
                      ),
                      20.height,
                      Padding(
                        padding:
                        EdgeInsets.only(top: getScreenWidth(context) * 0.3,
                            left: getScreenWidth(context) * 0.08, right:getScreenWidth(context) * 0.08),
                        child: ButtonWidget(
                          buttonText: AppLocalizations.of(context)!.continued,
                          fontColors: AppColors.whiteColor,
                          onPressed: () {
                            context.read<OperationTimeBloc>().add(
                                OperationTimeEvent.operationTimeApiEvent(
                                    context: context,
                                  id: id,

                                ));

                            /*Navigator.pushNamed(
                              context, RouteDefine.fileUploadScreen.name);*/
                          },
                          bGColor: AppColors.mainColor,
                        ),
                      ),
                      20.height,
                      Padding(
                        padding:
                        EdgeInsets.only(left: getScreenWidth(context) * 0.08, right:getScreenWidth(context) * 0.08),
                        child: ButtonWidget(
                          buttonText: AppLocalizations.of(context)!.skip,
                          fontColors: AppColors.mainColor,
                          borderColor: AppColors.mainColor,
                          onPressed: () {
                             Navigator.pushNamed(
                              context, RouteDefine.fileUploadScreen.name);
                          },
                          bGColor: AppColors.whiteColor,
                        ),
                      ),
                      20.height,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            13.height,
            Container(
                width: getScreenWidth(context) * 0.15,
                child: Text(
                  dayString,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.normal),
                )),
            10.width,
            SizedBox(
              width: getScreenWidth(context) * 0.73,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.OperationTimeList.isNotEmpty
                    ? state.OperationTimeList[rowIndex].monday.length
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
                                    .monday[index].from!,
                              ),
                              21.width,
                              TimeContainer(
                                openingIndex: 0,
                                index: index,
                                dayString: dayString,
                                rowIndex: rowIndex,
                                time: state.OperationTimeList[rowIndex]
                                    .monday[index].until!,
                              ),
                              21.width,
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
                                                  rowIndex: rowIndex,
                                                  context: context,
                                                ));
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
          width: getScreenWidth(context) * 0.245,
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
                var datetime = '00:00';
                Duration initialTimer = const Duration();
                showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext c1) {
                      return Container(
                        height: getScreenHeight(context) * 0.33,
                        padding: const EdgeInsets.only(top: 6.0),
                        color: AppColors.whiteColor,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 22.0,
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: SafeArea(
                              top: false,
                              child: Column(
                                children: [
                                  CupertinoTimerPicker(
                                      mode: CupertinoTimerPickerMode.hm,
                                      minuteInterval: 30,
                                      initialTimerDuration: initialTimer,
                                      onTimerDurationChanged:
                                          (Duration changeTimer) {
                                        initialTimer = changeTimer;
                                        String  time = '${changeTimer.inHours}:${changeTimer.inMinutes % 60}';
                                        var format = DateFormat("HH:mm");
                                        var start = format.parse(time);
                                         datetime = DateFormat.Hm().format(start);
                                      }),
                                  GestureDetector(
                                      onTap: () async {
                                        context.read<OperationTimeBloc>().add(
                                            OperationTimeEvent.timePickerEvent(
                                                context: context,
                                                rowIndex: rowIndex,
                                                timeIndex: index,
                                                openingIndex: openingIndex,
                                                time: datetime,
                                                timePickerContext: c1
                                            ));
                                      },
                                      child: Text('ok')),
                                ],
                              ),
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
                    child: Text(time ==  '00:00' ? '' :time,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.mediumFont,
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
