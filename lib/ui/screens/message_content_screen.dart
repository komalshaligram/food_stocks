import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import '../../bloc/message_content/message_content_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
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
            messageData: args?[AppStrings.messageDataString])),
      child: MessageContentScreenWidget(),
    );
  }
}

class MessageContentScreenWidget extends StatelessWidget {
  const MessageContentScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageContentBloc, MessageContentState>(
      listener: (context, state) {},
      child: BlocBuilder<MessageContentBloc, MessageContentState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: AppLocalizations.of(context)!.message,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                trailingWidget: Center(
                  child: GestureDetector(
                    onTap: () {},
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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
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
                            color: AppColors.shadowColor.withOpacity(0.15),
                            blurRadius: AppConstants.blur_10)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.message.title ?? '',
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500),
                      ),
                      5.height,
                      Text(
                        state.message.updatedAt ?? '',
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_10,
                            color: AppColors.textColor),
                      ),
                      5.height,
                      Text(
                        parse(state.message.fulltext ?? '').body?.text ?? '',
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_12,
                            color: AppColors.blackColor),
                      )
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
}
