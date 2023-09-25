import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
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
    OperationTimeBloc bloc = context.read<OperationTimeBloc>();
    return BlocBuilder<OperationTimeBloc, OperationTimeState>(
  builder: (context, state) {
    return Scaffold(
       backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 60,
        title: Text(AppStrings.operationTimeString,style: AppStyles.rkRegularTextStyle(size: 16,fontWeight: FontWeight.w400,color: AppColors.blackColor)),
        leading:  GestureDetector(
            onTap: ()=>Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios ,color: AppColors.blackColor, )),
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
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   const SizedBox(
                     width: 40,
                   ),
                   SizedBox(
                       width: 100,
                       height: 40,
                       child: Text(AppStrings.toAnHourString,style: AppStyles.rkRegularTextStyle(size: 16,color: AppColors.textColor,fontWeight: FontWeight.w400),)),
                   SizedBox(
                       width: 100,
                       height: 40,
                       child: Text(AppStrings.fromAnHourString,style: AppStyles.rkRegularTextStyle(size: 16,color: AppColors.textColor,fontWeight: FontWeight.w400),)),
                   const SizedBox(
                     width: 70,
                   ),

                 ],
               ),
                OperationTimeRow(dayString: AppStrings.sundayString),
                const SizedBox(
                  height: 15,
                ),

                OperationTimeRow(dayString: AppStrings.mondayString),
              const SizedBox(
                height: 15,
              ),

              OperationTimeRow(dayString: AppStrings.tuesdayString),
              const SizedBox(
                height: 15,
              ),

              OperationTimeRow(dayString: AppStrings.wednesdayString),
              const SizedBox(
                height: 15,
              ),

              OperationTimeRow(dayString: AppStrings.thursdayString),
              const SizedBox(
                height: 15,
              ),

              OperationTimeRow(dayString: AppStrings.fridayAndHolidayEvesString),
              const SizedBox(
                height: 15,
              ),

              OperationTimeRow(dayString: AppStrings.saturdayAndHolidaysString),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                buttonText:AppLocalizations.of(context)!.continued,
                fontColors: AppColors.whiteColor,
                onPressed: (){
                  Navigator.pushNamed(context, RouteDefine.fileUploadScreen.name);

                },
                bGColor: AppColors.mainColor,
              ),
              const SizedBox(
                height: 10,
              ),

              ButtonWidget(
                buttonText:AppLocalizations.of(context)!.skip,
                fontColors: AppColors.mainColor,
                borderColor: AppColors.mainColor,
                onPressed: (){
                  Navigator.pushNamed(context, RouteDefine.fileUploadScreen.name);
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

 OperationTimeRow({super.key, required this.dayString});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<OperationTimeBloc, OperationTimeState>(
  builder: (context, state) {
    return Row(

      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.blueColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(Icons.add,color: AppColors.whiteColor),
        ),
        const SizedBox(
          width: 10,
        ),
        const TimeContainer(),

        const SizedBox(
          width: 10,
        ),
        const TimeContainer(),
        const SizedBox(
          width: 15,
        ),

        SizedBox(
            width: 100,
            child: Text(dayString,style: AppStyles.rkRegularTextStyle(size: 16,color: AppColors.textColor,fontWeight: FontWeight.normal),)),
      ],
    );
  },
);
  }

}


class TimeContainer extends StatelessWidget {
  const TimeContainer({super.key});

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: (){
                    context.read<OperationTimeBloc>().add(OperationTimeEvent.timePickerEvent(context: context));
                  },
                  child:  Icon(CupertinoIcons.clock , color: AppColors.greyColor,
                  )),
              Text(
                state.time,style: AppStyles.rkRegularTextStyle(size: 16 , color: AppColors.blackColor,fontWeight: FontWeight.normal)
              ),
            ],
          ),
        );
  },
);
  }
}

    




