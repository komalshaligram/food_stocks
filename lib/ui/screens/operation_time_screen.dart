import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import '../../bloc/operation_time/operation_time_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Scaffold(
       backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 60,
        title: Text(AppLocalizations.of(context)!.operation_time,style: AppStyles.rkRegularTextStyle(size: 16,fontWeight: FontWeight.w400,color: AppColors.blackColor)),
        leading:  Icon(Icons.arrow_back_ios ,color: AppColors.blackColor, ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: screenWidth * 0.1, right: screenWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: AppConstants.padding_20,
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [

                 SizedBox(
                     width: 100,
                     height: 40,
                     child: Text(AppLocalizations.of(context)!.to_an_hour,style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont,color: AppColors.textColor),)),
                 SizedBox(
                     width: 100,
                     height: 40,
                     child: Text(AppLocalizations.of(context)!.from_an_hour,style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont,color: AppColors.textColor),))
               ],
             ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Icon(Icons.add,color: AppColors.whiteColor),
                ),

                Text(AppLocalizations.of(context)!.from_an_hour,style: AppStyles.rkRegularTextStyle(size: 16,color: AppColors.textColor,fontWeight: FontWeight.w400),)
              ],
            ),
          ],
        ),
      ),

    );
  }
}
