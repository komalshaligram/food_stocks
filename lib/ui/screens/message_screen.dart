import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/message/message_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../routes/app_routes.dart';
import '../utils/themes/app_strings.dart';

class MessageRoute {
  static Widget get route => MessageScreen();
}

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageBloc(),
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
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: CommonAppBar(
                  title: AppLocalizations.of(context)!.messages,
                  iconData: Icons.arrow_back_ios_sharp,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  trailingWidget: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        AppLocalizations.of(context)!.editing,
                        style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                itemBuilder: (context, index) =>
                    messageListItem(index: index, context: context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget messageListItem({required int index, required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15), blurRadius: 10),
        ],
      ),
      margin: EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_5),
      padding: EdgeInsets.symmetric(vertical: AppConstants.padding_10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteDefine.messageContentScreen.name,
              arguments: {AppStrings.messageContentString: index});
        },
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == 1 ? Colors.transparent : AppColors.mainColor,
              ),
              margin: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'כותרת ההודעה שהגיע ללקוח',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500),
                  ),
                  5.height,
                  Text(
                    'לורם איפסום דולור סיט אמט, קונסקטורר אדיפיסינג אלית ושבעגט ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי...',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.blackColor),
                  ),
                  5.height,
                  Text(
                    '15.02.2023 15:35',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_10, color: AppColors.textColor),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.centerRight,
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
