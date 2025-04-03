import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/message_content/message_content_bloc.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../main.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/custom_button_widget.dart';

class MessageContentRoute {
  static Widget get route => const MessageContentScreen();
}

class MessageContentScreen extends StatelessWidget {
  const MessageContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => MessageContentBloc()
        ..add(MessageContentEvent.getMessageDataEvent(messageData: args?[AppStrings.messageDataString], isReadMore: args?[AppStrings.isReadMoreString] ?? false))
        ..add(MessageContentEvent.messageUpdateEvent(
          messageId: args?[AppStrings.messageIdString] ?? '',
          context: context,
        )),
      child: MessageContentScreenWidget(),
    );
  }
}

class MessageContentScreenWidget extends StatelessWidget {
   MessageContentScreenWidget({super.key});
  var inputFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    MessageContentBloc bloc = context.read<MessageContentBloc>();
    return BlocListener<MessageContentBloc, MessageContentState>(
      listener: (context, state) {},
      child: BlocBuilder<MessageContentBloc, MessageContentState>(

        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              Navigator.pop(context, {
                AppStrings.messageIdString: state.message.id,
                AppStrings.messageReadString: !(state.message.isRead ?? true),
                AppStrings.messageDeleteString: false,
              });
              return Future.value(false);
            },
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              appBar: state.isPreview
                  ? const PreferredSize(preferredSize: Size.fromHeight(0), child: SizedBox())
                  : PreferredSize(
                      preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
                      child: CommonAppBar(
                        bgColor: AppColors.pageColor,
                        title: AppLocalizations.of(context)!.messages,
                        iconData: Icons.arrow_back_ios_sharp,
                        onTap: () {
                          Navigator.pop(context, {
                            AppStrings.messageIdString: state.message.id,
                            AppStrings.messageReadString: !(state.message.isRead ?? true),
                            AppStrings.messageDeleteString: false,
                          });
                        },
                        trailingWidget: Center(
                          child: GestureDetector(
                            onTap: () {
                              deleteMessageDialog(context: context,messageId: state.message.id ?? '');
                            },
                            child: Text(
                              AppLocalizations.of(context)!.delete,
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              body: state.isPreview
                  ? SafeArea(
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: state.message.message?.messageImage != null && state.message.message?.messageImage != ''
                                ? Image.network(
                                    '${AppUrlEndPoints.baseFileUrl}${state.message.message?.messageImage ?? ''}',
                                    height: getScreenHeight(context),
                                    width: double.maxFinite,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CupertinoActivityIndicator(
                                            color: AppColors.blackColor,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(decoration: BoxDecoration(color: AppColors.whiteColor, shape: BoxShape.circle), alignment: Alignment.center, child: Image.asset(AppImagePath.imageNotAvailable5));
                                    },
                                  )
                                : const SizedBox(),
                          ),
                          Positioned(
                            right: state.language == AppStrings.englishString ? 20 : getScreenWidth(context) - 50,
                            top: 50,
                            child: GestureDetector(
                              onTap: () {
                                bloc.add(const MessageContentEvent.imagePreviewEvent());
                              },
                              child: Icon(
                                Icons.close,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              margin: const EdgeInsets.only(left: AppConstants.padding_10, right: AppConstants.padding_10, top: AppConstants.padding_15),
                              padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_30),
                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)), color: AppColors.whiteColor, boxShadow: [BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10)]),
                              child: Container(
                                color: AppColors.whiteColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        bloc.add(const MessageContentEvent.imagePreviewEvent());
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: state.message.message?.messageImage != null && state.message.message?.messageImage != ''
                                            ? Image.network(
                                                '${AppUrlEndPoints.baseFileUrl}${state.message.message?.messageImage ?? ''}',
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return Center(
                                                      child: CupertinoActivityIndicator(
                                                        color: AppColors.blackColor,
                                                      ),
                                                    );
                                                  }
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(decoration: BoxDecoration(color: AppColors.whiteColor, shape: BoxShape.circle), alignment: Alignment.center, child: Image.asset(AppImagePath.imageNotAvailable5));
                                                },
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                    5.height,
                                    Row(
                                      children: [
                                        Text(
                                          state.message.message?.title ?? '',
                                          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.w500),
                                        ),
                                        10.width,
                                        Text(
                                          (state.message.createdAt ?? '').split(" ").first.toString(),
                                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor,fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),

                                    5.height,
                                    Html(
                                      data: state.message.message?.body ?? '',
                                      shrinkWrap: true,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6,right :6),
                                      child: Text(
                                        parse(state.message.message?.summary ?? '').body?.text ?? '',
                                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor),
                                      ),
                                    ),
                                    10.height,
                                  ],
                                ),
                              ),
                            ),
                            40.height,
                            (state.message.message?.mainPage?.isNotEmpty ?? false)
                                ? CustomButtonWidget(
                                    buttonText: AppLocalizations.of(context)!.open.toUpperCase(),
                                    bGColor: AppColors.mainColor,
                                    width: getScreenWidth(context) - 100,
                                    onPressed: () async {
                                      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                                      if (preferences.getSubUser()) {
                                        navigationToScreen(id: state.message.message?.subUserId.toString() ?? '', mainPage: state.message.message?.subUserMainPage.toString() ?? '', subPage: state.message.message?.subUserSubPage.toString() ?? '');
                                      } else {
                                        navigationToScreen(id: state.message.message?.navigationId.toString() ?? '', mainPage: state.message.message?.mainPage.toString() ?? '', subPage: state.message.message?.subPage.toString() ?? '');
                                      }
                                    },
                                    fontColors: AppColors.whiteColor,
                                  )
                                : const SizedBox(),
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

  void navigationToScreen({
    required String mainPage,
    required String subPage,
    required String id,
  }) {
    if (subPage == '') {
      if (mainPage == 'companyScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.companyScreen.name, arguments: {AppStrings.companyIdString: id});
      }
      if (mainPage == 'saleScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.productSaleScreen.name, arguments: {AppStrings.companyIdString: id});
      }
      if (mainPage == 'supplierScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.supplierScreen.name, arguments: {AppStrings.companyIdString: id});
      }
      if (mainPage == 'storeScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.companyIdString: id, AppStrings.pushNavigationString: 'storeScreen'});
      }
    } else {
      if (subPage == 'companyProductsScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.companyProductsScreen.name, arguments: {AppStrings.companyIdString: id});
      } else if (subPage == 'supplierProductsScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.supplierIdString: id});
      } else if (subPage == 'catagoryScreen' || subPage == 'storeCategoryScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.companyIdString: id});
      } else if (subPage == 'planogramScreen' || subPage == 'planogramProductScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.storeCategoryScreen.name, arguments: {
          AppStrings.companyIdString: id,
          AppStrings.isSubCategory: 'false',
        });
      } else if (subPage == 'saleProductScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context, RouteDefine.productSaleScreen.name, arguments: {AppStrings.companyIdString: id});
      }
    }
  }

  void deleteMessageDialog({
 required BuildContext context,
    required String messageId
}) {
     showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
        value:  context.read<MessageContentBloc>(),
        child: BlocBuilder<MessageContentBloc, MessageContentState>(
  builder: (context, state) {
    MessageContentBloc bloc = context.read<MessageContentBloc>();
    return CommonAlertDialog(
          isLogOutProcess: state.isLoading,
          directionality: state.language,
          title: AppLocalizations.of(context)!.delete,
          subTitle: AppLocalizations.of(context)!.are_you_sure,
          positiveTitle: AppLocalizations.of(context)!.yes,
          negativeTitle: AppLocalizations.of(context)!.no,
          negativeOnTap: () {
            Navigator.pop(context1);
          },
          positiveOnTap: () async {
            bloc.add(MessageContentEvent.messageDeleteEvent(
              messageId: state.message.id ?? '',
              context: context,
              dialogContext: context1,
            ));
          },
        );
  },
),
      ),
    );

  }
}
