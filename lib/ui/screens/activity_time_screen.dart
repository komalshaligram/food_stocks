import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:intl/intl.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../bloc/activity_time/activity_time_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_strings.dart';
import '../widget/common_app_bar.dart';
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
          ..add(ActivityTimeEvent.getActivityTimeDetailsEvent(isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false ? true : false))
          ..add(ActivityTimeEvent.defaultValueAddInListEvent(context: context))
          ..add(ActivityTimeEvent.getActivityTimeListEvent(context: context)),
        child: const ActivityTimeScreenWidget());
  }
}

class ActivityTimeScreenWidget extends StatelessWidget {
  const ActivityTimeScreenWidget({super.key});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityTimeBloc, ActivityTimeState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.activity_time,
              iconData: Icons.arrow_back_ios_new_rounded,
              trailingWidget: _buildAppBarIcon(),
              onTap: () {
                if (!state.isUpdate) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pop(context);
                }
              }),
        ),
        body: state.isShimmering
            ? const ActivityTimeScreenShimmerWidget()
            : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  _buildFormCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [_buildTimeHeader(context), 12.height, operationTimeListWidget(state)])),
                  24.height,
                  CustomButtonWidget(
                      buttonText:
                          state.isUpdate ? AppLocalizations.of(context)!.save.toUpperCase() : AppLocalizations.of(context)!.next.toUpperCase(),
                      fontColors: AppColors.whiteColor,
                      isLoading: state.isLoading,
                      radius: 14,
                      onPressed: () {
                        context.read<ActivityTimeBloc>().add(ActivityTimeEvent.activityTimeApiEvent(context: context));
                      },
                      bGColor: AppColors.mainColor),
                  if (!state.isUpdate) ...[12.height, _buildSkipButton(context)]
                ]),
              ),
      );
    });
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
        padding: const EdgeInsets.all(_horizontalPadding),
        child: child);
  }

  Widget _buildAppBarIcon() {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.schedule_outlined, size: 21, color: AppColors.mainColor));
  }

  Widget _buildTimeHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_4),
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Text('',
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_13, color: AppColors.blackColor.withValues(alpha: 0.55), fontWeight: FontWeight.w500)),
        ),
        Expanded(
          flex: 3,
          child: Text(AppLocalizations.of(context)!.from_time,
              textAlign: TextAlign.center,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_13, color: AppColors.blackColor.withValues(alpha: 0.55), fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(AppLocalizations.of(context)!.until_time,
              textAlign: TextAlign.center,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_13, color: AppColors.blackColor.withValues(alpha: 0.55), fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 44)
      ]),
    );
  }

  Widget operationTimeListWidget(ActivityTimeState state) {
    if (state.operationTimeList.isEmpty) return const SizedBox();
    return ListView.separated(
        itemCount: state.operationTimeList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_4),
            child: Divider(height: 1, color: AppColors.lightBorderColor.withValues(alpha: 0.6))),
        itemBuilder: (context, index) {
          return ActivityTimeRow(dayString: state.operationTimeList[index].dayString, rowIndex: index);
        });
  }

  Widget _buildSkipButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pushNamed(context, RouteDefine.formDataScreen.name);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: AppConstants.buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.mainColor.withValues(alpha: 0.35))),
          child: Text(AppLocalizations.of(context)!.skip.toUpperCase(),
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_15, color: AppColors.mainColor, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}

class ActivityTimeRow extends StatelessWidget {
  final String dayString;
  final int rowIndex;

  const ActivityTimeRow({super.key, required this.dayString, required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityTimeBloc, ActivityTimeState>(builder: (context, state) {
      if (state.operationTimeList.isEmpty) {
        return const CupertinoActivityIndicator();
      }

      final slots = state.operationTimeList[rowIndex].monday;
      return Column(
        children: List.generate(slots.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < slots.length - 1 ? 10 : 0, top: index == 0 ? 0 : 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                  flex: 3,
                  child: index == 0
                      ? Text(dayString,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14, color: AppColors.blackColor.withValues(alpha: 0.88), fontWeight: FontWeight.w500))
                      : const SizedBox()),
              Expanded(
                flex: 3,
                child: TimeContainer(
                    openingIndex: 1, index: index, rowIndex: rowIndex, dayString: dayString, time: slots[index].from ?? AppStrings.timeString),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TimeContainer(
                    openingIndex: 0, index: index, dayString: dayString, rowIndex: rowIndex, time: slots[index].until ?? AppStrings.timeString),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                  context: context,
                  isAdd: index == 0,
                  onTap: () {
                    if (index == 0) {
                      context.read<ActivityTimeBloc>().add(ActivityTimeEvent.addMoreTimeZoneEvent(rowIndex: rowIndex, context: context));
                    } else {
                      context.read<ActivityTimeBloc>().add(ActivityTimeEvent.deleteTimeZoneEvent(rowIndex: rowIndex, timeIndex: index));
                    }
                  })
            ]),
          );
        }),
      );
    });
  }

  Widget _buildActionButton({required BuildContext context, required bool isAdd, required VoidCallback onTap}) {
    final color = isAdd ? AppColors.mainColor : AppColors.redColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(isAdd ? Icons.add_rounded : Icons.remove_rounded, color: color, size: 22)),
      ),
    );
  }
}

class TimeContainer extends StatelessWidget {
  final int openingIndex;
  final int index;
  final int rowIndex;
  final String dayString;
  final String time;

  const TimeContainer(
      {super.key, required this.openingIndex, required this.index, required this.dayString, required this.time, required this.rowIndex});

  static const double _fieldRadius = 12;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityTimeBloc, ActivityTimeState>(builder: (context, state) {
      final displayTime = time == AppStrings.timeString || time == '24:59' ? '' : time;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTimePicker(context),
          borderRadius: BorderRadius.circular(_fieldRadius),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_fieldRadius), border: Border.all(color: AppColors.lightBorderColor), color: AppColors.pageColor),
            child: Row(children: [
              Expanded(
                child: Text(displayTime,
                    textAlign: TextAlign.center, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor)),
              ),
              Icon(Icons.access_time_rounded, size: 18, color: AppColors.blackColor.withValues(alpha: 0.35))
            ]),
          ),
        ),
      );
    });
  }

  void _showTimePicker(BuildContext context) {
    var datetime = '';
    final DateFormat formatter = DateFormat('HH:mm');
    datetime = formatter.format(DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30)));
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext c1) {
          return Container(
            padding: const EdgeInsets.only(top: AppConstants.padding_5),
            decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
            child: DefaultTextStyle(
              style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.font_17),
              child: SafeArea(
                top: false,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    height: getScreenHeight(context) * 0.25,
                    child: CupertinoDatePicker(
                        minuteInterval: 30,
                        initialDateTime: DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30)),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (value) {
                          datetime = formatter.format(value);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_8),
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () {
                            context.read<ActivityTimeBloc>().add(ActivityTimeEvent.timePickerEvent(
                                context: context,
                                rowIndex: rowIndex,
                                timeIndex: index,
                                openingIndex: openingIndex,
                                time: datetime,
                                previousTime: time,
                                timePickerContext: c1));
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_11),
                            child: Text(AppLocalizations.of(context)!.ok,
                                textAlign: TextAlign.center,
                                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.whiteColor)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  8.height
                ]),
              ),
            ),
          );
        });
  }
}
