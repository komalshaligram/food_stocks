import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/bloc/message/message_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../widget/question_and_answer_screen_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

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
    MessageBloc bloc = context.read<MessageBloc>();
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {},
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              Navigator.pop(context, {
                AppStrings.messageIdListString: state.deletedMessageList,
              });
              return Future.value(false);
            },
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: CommonAppBar(
                  bgColor: AppColors.pageColor,
                  title: AppLocalizations.of(context)!.messages,
                  iconData: Icons.arrow_back_ios_sharp,
                  onTap: () {
                    Navigator.pop(context, {
                      AppStrings.messageIdListString: state.deletedMessageList,
                    });
                  },
                ),
              ),
              body: SafeArea(
                child:
                    SmartRefresher(
                  enablePullDown: true,
                  controller: state.refreshController,
                  header: RefreshWidget(),
                  footer: CustomFooter(
                    builder: (context, mode) =>
                        QuestionAndAnswerScreenShimmerWidget(),
                  ),
                  enablePullUp: !state.isBottomOfMessage,
                  onRefresh: () {
                    context
                        .read<MessageBloc>()
                        .add(MessageEvent.refreshListEvent(context: context));
                  },
                  onLoading: () {
                    context.read<MessageBloc>().add(
                        MessageEvent.getMessageListEvent(context: context));
                  },
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
                                      '${AppLocalizations.of(context)!.messages_not_found}',
                                      style: AppStyles.pVRegularTextStyle(
                                          size: AppConstants.font_26,
                                          color: AppColors.blackColor),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: state.messageList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_10),
                                    itemBuilder: (context, index) {
                                      return Dismissible(
                                        key: Key(state.messageList.toString()),
                                        direction: DismissDirection.startToEnd,
                                        background: Container(
                                          alignment: state.language == AppStrings.englishString
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          margin: EdgeInsets.symmetric(
                                              vertical: AppConstants.padding_5,
                                              horizontal: AppConstants.padding_10),
                                          decoration: BoxDecoration(
                                            color: AppColors.redColor,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: SvgPicture.asset(
                                              AppImagePath.delete,
                                              color: AppColors.whiteColor,
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                        ),
                                        confirmDismiss: (DismissDirection direction) async {
                                          if (direction == DismissDirection.startToEnd) {
                                            return await showDialog(
                                              context: context,
                                              builder: (BuildContext context1) {
                                                return BlocProvider.value(
                                                  value: context.read<MessageBloc>(),
                                                  child: BlocBuilder<MessageBloc, MessageState>(
                                                    builder: (context, state) {
                                                      return AbsorbPointer(
                                                        absorbing: state.isRemoveProcess ? true : false,
                                                        child: AlertDialog(
                                                          backgroundColor: AppColors.pageColor,
                                                          contentPadding: EdgeInsets.all(20.0),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20.0)),
                                                          title: Text(
                                                              '${AppLocalizations.of(context)!.are_you_sure}',
                                                              style: AppStyles.rkRegularTextStyle(
                                                                  size: AppConstants.mediumFont,
                                                                  color: AppColors.blackColor,
                                                                  fontWeight: FontWeight.w400)),
                                                          actionsPadding: EdgeInsets.only(
                                                              right: AppConstants.padding_20,
                                                              bottom: AppConstants.padding_20,
                                                              left: AppConstants.padding_20),
                                                          actions: [
                                                            InkWell(
                                                              highlightColor: Colors.transparent,
                                                              splashColor: Colors.transparent,
                                                              onTap: () {
                                                                bloc.add(MessageEvent.MessageDeleteEvent(
                                                                    messageId: state.messageList[index].id.toString(),
                                                                    context: context,
                                                                    dialogContext: context1
                                                                )
                                                                );
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal: 14.0, vertical: 10.0),
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(8.0)),
                                                                width: 80,
                                                                child: Text(
                                                                  '${AppLocalizations.of(context)!.yes}',
                                                                  style: AppStyles.rkRegularTextStyle(
                                                                      color: AppColors.mainColor
                                                                          .withOpacity(0.9),
                                                                      size: AppConstants.smallFont),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              highlightColor: Colors.transparent,
                                                              splashColor: Colors.transparent,
                                                              onTap: () {
                                                                Navigator.pop(context1);
                                                                /*bloc.add(MessageEvent.refreshListEvent(
                                                                    context: context1));*/
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal: 14.0, vertical: 10.0),
                                                                alignment: Alignment.center,
                                                                width: 80,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                    AppColors.mainColor.withOpacity(0.9),
                                                                    borderRadius: BorderRadius.circular(8.0)),
                                                                child: Text(
                                                                  '${AppLocalizations.of(context)!.no}',
                                                                  style: AppStyles.rkRegularTextStyle(
                                                                      color: AppColors.whiteColor,
                                                                      size: AppConstants.smallFont),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: messageListItem(
                                        index: index,
                                        context: context,
                                        title: state.messageList[index].message
                                                ?.title ??
                                            '',
                                        content: parse(state.messageList[index]
                                                        .message?.body ??
                                                    '')
                                                .body
                                                ?.text ??
                                            '',
                                        dateTime: state
                                                .messageList[index].updatedAt
                                                ?.replaceRange(16, 19, '') ??
                                            '',
                                        onTap: () async {
                                          dynamic messageNewData =
                                              await Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .messageContentScreen.name,
                                                  arguments: {
                                                AppStrings.messageDataString:
                                                    state.messageList[index],
                                                AppStrings.messageIdString:
                                                    state.messageList[index].id
                                              });
                                          debugPrint('message = $messageNewData');
                                          context.read<MessageBloc>().add(
                                              MessageEvent.removeOrUpdateMessageEvent(
                                                  messageId: messageNewData[
                                                      AppStrings.messageIdString],
                                                  isRead: messageNewData[
                                                      AppStrings
                                                          .messageReadString],
                                                  isDelete: messageNewData[
                                                      AppStrings
                                                          .messageDeleteString]));
                                        },
                                        isRead: state.messageList[index].isRead ??
                                            false,
                                                                              ),
                                      );
                                    },
                                  ),
                        // state.isLoadMore
                        //     ? QuestionAndAnswerScreenShimmerWidget()
                        //     : 0.width,
                      ],
                    ),
                  ),
                ),
                // onNotification: (notification) {
                //   if (notification.metrics.pixels ==
                //       notification.metrics.maxScrollExtent) {
                //     if (!state.isBottomOfMessage) {
                //       context.read<MessageBloc>().add(
                //           MessageEvent.getMessageListEvent(
                //               context: context));
                //     }
                //   }
                //   return true;
                // }),
              ),
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
    required bool isRead,
  }) {
    return DelayedWidget(
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
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Row(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRead ? Colors.transparent : AppColors.mainColor,
                ),
                margin: EdgeInsets.only(
                    left: context.rtl ? AppConstants.padding_10 : 0,
                    right: context.rtl ? 0 : AppConstants.padding_10),
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
                          size: AppConstants.font_10,
                          color: AppColors.textColor),
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
      ),
    );
  }

/*  void deleteDialog({
    required BuildContext context,
    required String messageId,
    required int listIndex,

  }) {
    MessageBloc bloc = context.read<MessageBloc>();
    showDialog(
        context: context,
        builder: (context1) => BlocProvider.value(
          value: context.read<MessageBloc>(),
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              return AbsorbPointer(
                absorbing: state.isRemoveProcess ? true : false,
                child: AlertDialog(
                  backgroundColor: AppColors.pageColor,
                  contentPadding: EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  title: Text(
                       '${AppLocalizations.of(context)!.you_want_delete_product}',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.mediumFont,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400)),
                  actionsPadding: EdgeInsets.only(
                      right: AppConstants.padding_20,
                      bottom: AppConstants.padding_20,
                      left: AppConstants.padding_20),
                  actions: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                      bloc.add(MessageEvent.MessageDeleteEvent(
                            context: context,
                            messageId: messageId,
                            dialogContext: context1,
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        width: 80,
                        child: Text(
                          '${AppLocalizations.of(context)!.yes}',
                          style: AppStyles.rkRegularTextStyle(
                              color: AppColors.mainColor.withOpacity(0.9),
                              size: AppConstants.smallFont),
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                       bloc.add(MessageEvent.refreshListEvent(
                            context: context1));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 10.0),
                        alignment: Alignment.center,
                        width: 80,
                        decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          '${AppLocalizations.of(context)!.no}',
                          style: AppStyles.rkRegularTextStyle(
                              color: AppColors.whiteColor,
                              size: AppConstants.smallFont),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }*/


}
