/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../widget/container_widget.dart';

class ProfileRoute {
  static Widget get route => const ProfileScreen();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child:  const ProfileScreenWidget(),
    );
  }
}


class ProfileScreenWidget extends StatelessWidget {
  const ProfileScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
            title: Text(AppStrings.businessDetailsString,
              style: AppStyles.rkRegularTextStyle(
                  size: 16, color: Colors.black, fontWeight: FontWeight.w400),
            ),
            backgroundColor: Colors.white,
            titleSpacing: 0,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 38, right: 38),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 80,
                      width: screenWidth,
                      alignment: Alignment.center,
                      child:
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: AppColors.mainColor.withOpacity(0.1),

                        ),
                        child: const Icon(Icons.person),

                      ),
                    ),
                    Positioned(
                      left: 188,
                      top: 45,
                      child: Container(
                        width: 29,
                        height: 29,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.borderColor)
                        ),
                        child: Icon(Icons.camera_alt_rounded,
                          color: AppColors.blueColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  width: screenWidth,
                  alignment: Alignment.center,
                  child: Text(
                    AppStrings.profilePictureString,
                    style: AppStyles.rkRegularTextStyle(
                        size: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                    height: 40,
                    alignment: Alignment.centerRight,
                    child: Text(AppStrings.typeOfBusinessString,
                      style: AppStyles.rkRegularTextStyle(size: 16),
                    )),
                DropdownButtonFormField<String>(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                            color: AppColors.borderColor,
                            ),
                      ),
                    
                  ),
                  isExpanded: true,
                  elevation: 0,
                  borderRadius: BorderRadius.circular(20),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  dropdownColor: AppColors.mainColor.withOpacity(0.1),
                  value: state.selectedIndex,
                  hint: const Text(
                    'select tag',
                  ),
                  items: state.institutionalList.map((tag) {
                    return DropdownMenuItem<String>(
                      value: tag,
                      child: Text(tag),
                    );
                  }).toList(),
                  onChanged: (tag) {
                    var temp = state.selectedIndex;
                    temp = tag;
                  },
                ),
                ContainerScreen(name: AppStrings.businessNameString,),
`

              ],
            ),
          ),
        );
      },
    );
  }
}
*/
