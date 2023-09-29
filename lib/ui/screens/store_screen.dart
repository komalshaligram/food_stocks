import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';

import '../../bloc/store/store_bloc.dart';
import '../utils/themes/app_colors.dart';

class StoreRoute {
  static Widget get route => const StoreScreen();
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreBloc(),
      child: StoreScreenWidget(),
    );
  }
}

class StoreScreenWidget extends StatelessWidget {
  const StoreScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {},
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
                child: Column(
              children: [
                Container(
                  height: 80,
                  width: getScreenWidth(context),
                  child: Container(
                    width: getScreenWidth(context),
                    height: 60,
                    margin: EdgeInsets.all(AppConstants.padding_10),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppConstants.radius_100)),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.3),
                            blurRadius: 10)
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              AppImagePath.filter,
                              colorFilter: ColorFilter.mode(
                                  AppColors.greyColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppConstants.radius_100)),
                                  borderSide:
                                      BorderSide(color: AppColors.greyColor),
                                ),
                                // icon: Icon(Icons.search, color: AppColors.greyColor,)
                                constraints: BoxConstraints(maxHeight: 46),
                                fillColor: AppColors.greyColor,
                                helperText: AppLocalizations.of(context)!.sear),
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset(
                            AppImagePath.scan,
                            colorFilter: ColorFilter.mode(
                                AppColors.greyColor, BlendMode.srcIn),
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            )),
          );
        },
      ),
    );
  }
}
