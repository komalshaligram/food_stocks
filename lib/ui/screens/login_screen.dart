import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/custom_form_field_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../bloc/login/log_in_bloc.dart';

class LogInRoute {
  static Widget get route => LogInScreen();
}

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInBloc(),
      child: LogInScreenWidget(),
    );
  }
}

class LogInScreenWidget extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: CommonAppBar(
          title: AppLocalizations.of(context)!.connection,
          iconData: Icons.arrow_back_ios_sharp,
          onTap: () {
            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: getScreenWidth(context) * 0.1,
              right: getScreenWidth(context) * 0.1),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.enter_your_phone,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: Colors.black)),
              SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(AppLocalizations.of(context)!.phone,style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor),),
                          CustomFormField(
                              fillColor: AppColors.whiteColor,
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              // inputAction: TextInputAction.next,
                              hint: "152485",
                              validator: ''),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppConstants.radius_5),
                        ),
                        border: Border.all(color: AppColors.borderColor, width: 1)
                      ),
                      padding: EdgeInsets.only(top: AppConstants.padding_5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.country,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor),
                          ),
                          DropdownButtonFormField<String>(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            alignment: Alignment.bottomCenter,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 8, right: 8),
                                border: InputBorder.none),
                            isExpanded: true,
                            elevation: 0,
                            //  borderRadius: BorderRadius.circular(3),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            //dropdownColor: AppColors.mainColor.withOpacity(0.1),
                            value: '91',
                            hint: const Text(
                              'select tag',
                            ),
                            items: [],
                            onChanged: (tag) {
                              var temp = tag;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!.continued,
                bGColor: AppColors.mainColor,
                onPressed: () {
                  Navigator.pushNamed(context, RouteDefine.otpScreen.name);
                },
                fontColors: AppColors.whiteColor,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
