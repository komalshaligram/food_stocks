import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import '../../bloc/message_content/message_content_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageContentRoute {
  static Widget get route => MessageContentScreen();
}

class MessageContentScreen extends StatelessWidget {
  const MessageContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => MessageContentBloc()
        ..add(MessageContentEvent.getMessageDataEvent(
            messageData: args?[AppStrings.messageDataString],
            isReadMore: args?[AppStrings.isReadMoreString] ?? false))
        ..add(MessageContentEvent.MessageUpdateEvent(
          messageId: args?[AppStrings.messageIdString] ?? '',
          context: context,
        )),
      child: MessageContentScreenWidget(),
    );
  }
}

class MessageContentScreenWidget extends StatelessWidget {
  const MessageContentScreenWidget({super.key});

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
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(0), child: SizedBox())
                  : PreferredSize(
                      preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                      child: CommonAppBar(
                        bgColor: AppColors.pageColor,
                        title: AppLocalizations.of(context)!.message,
                        iconData: Icons.arrow_back_ios_sharp,
                        onTap: () {
                          Navigator.pop(context, {
                            AppStrings.messageIdString: state.message.id,
                            AppStrings.messageReadString:
                                !(state.message.isRead ?? true),
                            AppStrings.messageDeleteString: false,
                          });
                        },
                        trailingWidget: Center(
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pop(context, {
                              //   AppStrings.messageIdString: state.message.id,
                              //   AppStrings.messageReadString: !(state.message.isRead ?? true),
                              //   AppStrings.messageDeleteString: true,
                              // });
                              showDialog(
                                context: context,
                                builder: (context1) => CommonAlertDialog(
                                  directionality: state.language,
                                  title:
                                      '${AppLocalizations.of(context)!.delete}',
                                  subTitle:
                                      '${AppLocalizations.of(context)!.are_you_sure}',
                                  positiveTitle:
                                      '${AppLocalizations.of(context)!.yes}',
                                  negativeTitle:
                                      '${AppLocalizations.of(context)!.no}',
                                  negativeOnTap: () {
                                    Navigator.pop(context1);
                                  },
                                  positiveOnTap: () async {
                                    bloc.add(
                                        MessageContentEvent.MessageDeleteEvent(
                                      messageId: state.message.id ?? '',
                                      context: context,
                                      dialogContext: context1,
                                    ));
                                  },
                                ),
                              );
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
                            child: state.message.message?.messageImage !=
                                        null &&
                                    state.message.message?.messageImage != ''
                                ? Image.network(
                                    '${AppUrls.baseFileUrl}${state.message.message?.messageImage ?? ''}',
                                    height: getScreenHeight(context),
                                    width: double.maxFinite,
                                    fit: BoxFit.contain,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
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
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            shape: BoxShape.circle),
                                        alignment: Alignment.center,
                                        child: Image.asset(AppImagePath.imageNotAvailable5)
                                        /*Text(
                                          AppStrings.failedToLoadString,
                                          textAlign: TextAlign.center,
                                          style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.font_14,
                                              color: AppColors.textColor),
                                        ),*/
                                      );
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Positioned(
                            right: state.language == AppStrings.englishString ? 20 : getScreenWidth(context) - 50,
                           top: 50,
                            child: GestureDetector(
                              onTap: () {
                                bloc.add(
                                    MessageContentEvent.ImagePreviewEvent());
                              },
                              child: Icon(Icons.close,color: AppColors.mainColor,),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(
                              left: AppConstants.padding_10,
                              right: AppConstants.padding_10,
                              top: AppConstants.padding_15),
                          padding: EdgeInsets.symmetric(
                              vertical: AppConstants.padding_15,
                              horizontal: AppConstants.padding_30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConstants.radius_5)),
                              color: AppColors.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColors.shadowColor.withOpacity(0.15),
                                    blurRadius: AppConstants.blur_10)
                              ]),
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    bloc.add(MessageContentEvent
                                        .ImagePreviewEvent());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: state.message.message
                                                    ?.messageImage !=
                                                null &&
                                            state.message.message
                                                    ?.messageImage !=
                                                ''
                                        ? Image.network(
                                            '${AppUrls.baseFileUrl}${state.message.message?.messageImage ?? ''}',
                                            fit: BoxFit.contain,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    color: AppColors.blackColor,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    shape: BoxShape.circle),
                                                alignment: Alignment.center,
                                                child:Image.asset(AppImagePath.imageNotAvailable5)
                                                /* Text(
                                                  AppStrings.failedToLoadString,
                                                  textAlign: TextAlign.center,
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .font_14,
                                                          color: AppColors
                                                              .textColor),
                                                ),*/
                                              );
                                            },
                                          )
                                        : SizedBox(),
                                  ),
                                ),
                                5.height,
                                Text(
                                  state.message.message?.title ?? '',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                5.height,
                                Text(
                                  state.message.createdAt ?? '',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_12,
                                      color: AppColors.textColor),
                                ),
                                5.height,
                                Text(
                                  parse(state.message.message?.body ?? '')
                                          .body
                                          ?.text ??
                                      '',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_14,
                                      color: AppColors.blackColor),
                                ),
                                Text(
                                  parse(state.message.message?.summary ?? '')
                                          .body
                                          ?.text ??
                                      '',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_14,
                                      color: AppColors.blackColor),
                                ),
                              ],
                            ),
                          ),
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
