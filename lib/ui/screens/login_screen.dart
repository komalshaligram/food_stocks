import 'package:flutter/material.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/custom_form_field_widget.dart';

class LogInRoute {
  static Widget get route => LogInScreen();
}

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LogInScreenWidget();
  }
}

class LogInScreenWidget extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteDefine.connectScreen.name);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: Text(
          AppLocalizations.of(context)!.connection,
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: getScreenWidth(context) * 0.1, right: getScreenWidth(context) * 0.1),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.enter_your_phone,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: Colors.black)),
              SizedBox(height: 50,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                       //   Text(AppLocalizations.of(context)!.phone),
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
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      alignment: Alignment.bottomCenter,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8,right:8),
                        border: InputBorder.none
                      ),
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
                  Navigator.pushNamed(
                      context, RouteDefine.otpScreen.name);
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
