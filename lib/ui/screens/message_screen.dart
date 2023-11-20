import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/message/message_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';

import '../../routes/app_routes.dart';
import '../utils/themes/app_strings.dart';
import '../widget/question_and_answer_screen_shimmer_widget.dart';

class MessageRoute {
  static Widget get route => MessageScreen();
}

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageBloc()
        ..add(MessageEvent.getMessageListEvent(context: context)),
      child: MessageScreenWidget(),
    );
  }
}

class MessageScreenWidget extends StatelessWidget {
  const MessageScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {},
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: AppLocalizations.of(context)!.messages,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                // trailingWidget: Center(
                //   child: GestureDetector(
                //     onTap: () {},
                //     child: Text(
                //       AppLocalizations.of(context)!.editing,
                //       style: AppStyles.rkRegularTextStyle(
                //         size: AppConstants.smallFont,
                //         color: AppColors.mainColor,
                //       ),
                //     ),
                //   ),
                // ),
              ),
            ),
            body: SafeArea(
              child: NotificationListener<ScrollNotification>(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        state.isShimmering
                            ? QuestionAndAnswerScreenShimmerWidget()
                            : state.messageList.isEmpty
                                ? Container(
                                    height: getScreenHeight(context) - 80,
                                    width: getScreenWidth(context),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No Messages',
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.smallFont,
                                          color: AppColors.textColor),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: state.messageList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_10),
                                    itemBuilder: (context, index) =>
                                        messageListItem(
                                      index: index,
                                      context: context,
                                      title:
                                          state.messageList[index].title ?? '',
                                      content: parse(state.messageList[index]
                                                      .fulltext ??
                                                  '')
                                              .body
                                              ?.text ??
                                          '',
                                      dateTime:
                                          state.messageList[index].updatedAt ??
                                              '',
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .messageContentScreen.name,
                                            arguments: {
                                              AppStrings.messageDataString:
                                                  state.messageList[index]
                                            });
                                      },
                                    ),
                                  ),
                        state.isLoadMore
                            ? QuestionAndAnswerScreenShimmerWidget()
                            : 0.width,
                      ],
                    ),
                  ),
                  onNotification: (notification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      if (!state.isBottomOfMessage) {
                        context.read<MessageBloc>().add(
                            MessageEvent.getMessageListEvent(context: context));
                      }
                    }
                    return true;
                  }),
            ),
          );
        },
      ),
    );
  }

  Widget messageListItem({
    required int index,
    required BuildContext context,
    required String title,
    required String content,
    required String dateTime,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10),
          ],
        ),
        margin: EdgeInsets.symmetric(
            horizontal: AppConstants.padding_10,
            vertical: AppConstants.padding_5),
        padding: EdgeInsets.symmetric(
            vertical: AppConstants.padding_10,
            horizontal: AppConstants.padding_10),
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index.isEven ? Colors.transparent : AppColors.mainColor,
              ),
              margin: EdgeInsets.only(
                  left: isRTLContent(context: context)
                      ? AppConstants.padding_10
                      : 0,
                  right: isRTLContent(context: context)
                      ? 0
                      : AppConstants.padding_10),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500),
                  ),
                  5.height,
                  Text(
                    content,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.blackColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  5.height,
                  Text(
                    '${dateTime}',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_10, color: AppColors.textColor),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios_sharp,
                color: AppColors.blackColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
