import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/question_and_answer/question_and_answer_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:food_stock/ui/widget/question_and_answer_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class QuestionAndAnswerRoute {
  static Widget get route => QuestionAndAnswerScreen();
}

class QuestionAndAnswerScreen extends StatelessWidget {
  const QuestionAndAnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionAndAnswerBloc()
        ..add(QuestionAndAnswerEvent.getQNAListEvent(context: context)),
      child: QuestionAndAnswerScreenWidget(),
    );
  }
}

class QuestionAndAnswerScreenWidget extends StatelessWidget {
  const QuestionAndAnswerScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionAndAnswerBloc, QuestionAndAnswerState>(
      listener: (context, state) {},
      child: BlocBuilder<QuestionAndAnswerBloc, QuestionAndAnswerState>(
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: AppLocalizations.of(context)!.questions_and_answers,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding_5),
                child: NotificationListener<ScrollNotification>(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          state.isShimmering
                              ? QuestionAndAnswerScreenShimmerWidget()
                              : state.qnaList.isEmpty
                                  ? Container(
                                      height: getScreenHeight(context) - 80,
                                      width: getScreenWidth(context),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Right now no questions',
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont,
                                            color: AppColors.textColor),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: state.qnaList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return qnaItem(
                                            question:
                                                state.qnaList[index].question ??
                                                    '',
                                            answer:
                                                state.qnaList[index].answer ??
                                                    '');
                                      },
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
                        if (!state.isBottomOfQNA) {
                          context.read<QuestionAndAnswerBloc>().add(
                              QuestionAndAnswerEvent.getQNAListEvent(
                                  context: context));
                        }
                      }
                      return true;
                    }),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget qnaItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.15),
            blurRadius: AppConstants.blur_10,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
      ),
      clipBehavior: Clip.hardEdge,
      child: ExpansionTile(
        collapsedIconColor: AppColors.greyColor,
        iconColor: AppColors.mainColor,
        title: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppConstants.padding_8),
          child: Text(
            question,
            style: AppStyles.rkBoldTextStyle(
              size: AppConstants.smallFont,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          Container(
            color: AppColors.lightBorderColor.withOpacity(0.5),
            padding:
                const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
            child: ListTile(
              title: Text(
                answer,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14, color: AppColors.blackColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
