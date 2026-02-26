import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../ui/widget/order_summary_screen_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/sub_users/sub_users_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
import '../widget/refresh_widget.dart';


class SubUsersRoute {
  static Widget get route => const SubUserScreen();
}

class SubUserScreen extends StatelessWidget {
  const SubUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubUsersBloc()..add(SubUsersEvent.getSubUserList(context: context)),
      child: const SubUserScreenWidget(),
    );
  }
}


class SubUserScreenWidget extends StatelessWidget {
  const SubUserScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SubUsersBloc bloc =  context.read<SubUsersBloc>();
    return BlocBuilder<SubUsersBloc, SubUsersState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.sub_user,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget:  !state.isShimmering ? CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!.new_user,
                height: 30,
                width: 70,
                radius: AppConstants.radius_5,
                fontSize: AppConstants.font_13,
                onPressed: () {
               bloc.add(SubUsersEvent.userApproveEvent(context: context));
                },
              ) : 0.width,
            ),
          ),
          body: FocusDetector(
            onFocusGained: (){
              context.read<SubUsersBloc>().add(SubUsersEvent.getSubUserList(context: context));
            },
            child: SafeArea(
              child: SmartRefresher(
                enablePullDown: true,
                controller: state.refreshController,
                header: const RefreshWidget(),
                footer: CustomFooter(
                    builder: (context, mode) => const OrderSummaryScreenShimmerWidget(
                      containerHeight: 40,itemCount: 10,
                    )),
                enablePullUp: !state.isBottomOfProducts,
                onRefresh: () {
                  context
                      .read<SubUsersBloc>()
                      .add(SubUsersEvent.refreshListEvent(context: context));
                },
                onLoading: () {
                  context
                      .read<SubUsersBloc>()
                      .add(SubUsersEvent.getSubUserList(context: context));
                },
                child: state.isShimmering ?
                    const OrderSummaryScreenShimmerWidget(containerHeight: 40,itemCount: 10,)
                    :  state.subUserList.isEmpty ?  SizedBox(
                  height: getScreenHeight(context) * 0.8,
                  child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_data,
                        style: AppStyles.pVRegularTextStyle(
                            size: AppConstants.normalFont,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400),
                      )),
                ):  ListView.builder(
                  itemCount: state.subUserList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return subUserTiles(
                        title:state.subUserList[index].contactName,
                        phoneNumber: state.subUserList[index].phoneNumber,
                        onTap: () {
                          bloc.add(SubUsersEvent.popEvent(context: context));
                          Navigator.pushNamed(context, RouteDefine.subUsersProfileScreen.name,
                          arguments: {
                            AppStrings.isUpdateParamString: true,
                            AppStrings.subUserIdString : state.subUserList[index].id ?? '',
                            AppStrings.subUserEmailString : state.subUserList[index].email ?? '',
                            AppStrings.subUserPhoneNumberString : state.subUserList[index].phoneNumber ?? '',
                            AppStrings.subUserIsraelIdString : state.subUserList[index].israelId ?? '',
                            AppStrings.subUserNameString : state.subUserList[index].contactName ?? '',
                            AppStrings.profileImageString : state.subUserList[index].profileImage ?? '',
                          }
                          ) ;
                        });

                  },),
              ),
            ),
          ),

        );
      },
    );
  }
  Widget subUserTiles({required title, required void Function() onTap,
  required phoneNumber
  }) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
          const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withValues(alpha:0.15),
                blurRadius: AppConstants.blur_10)
          ]),
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_5,
          horizontal: AppConstants.padding_10),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.padding_15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.blackColor),
                  ),
                  Text(
                    phoneNumber,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.blackColor),
                  ),

                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: AppConstants.smallFont,
                color:  AppColors.blackColor,
              ) ,
            ],
          ),
        ),
      ),
    );
  }
}
