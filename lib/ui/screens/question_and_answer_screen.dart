import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/question_and_answer/question_and_answer_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
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
      create: (context) => QuestionAndAnswerBloc(),
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
          return SafeArea(
            child: Scaffold(
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
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: 3,
                  itemBuilder: (context, index) => qnaItem(index: index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget qnaItem({required int index}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_5),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: 10,),
        ],
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
      ),
      clipBehavior: Clip.hardEdge,
      child: ExpansionTile(
        childrenPadding:
            const EdgeInsets.symmetric(vertical: 2.0),
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        title: Text(
          'ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי מגמש ?',
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont,
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold),
        ),
        children: [
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                "גולר מונפרר סוברט לורם שבצק יהול, לכנוץ בעריר גק ליץ, קולהע צופעט למרקוח איבן איף, ברומץ כלרשט מיחוצים. קלאצי מוסן מנת. להאמית קרהשק סכעיט דז מא, מנכםלמטכין נשואי מנורך. גולר מונפרר סוברט לורם שבצק יהול, לכנוץ בעריר גק ליץ, ושבעגט ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי מגמש. תרבנך וסתעד לכנו סתשם השמה -לתכי מורגם בורק? לתיג ישבעס.נולום ארווס סאפיאן - פוסיליס קוויס, אקווזמן נולום ארווס סאפיאן - פוסיליס קוויס, אקווזמן קוואזי במר מודוף. אודיפו בלאסטיק מונופץ קליר, בנפת נפקט למסון בלרק - וענוף לפרומי בלוף קינץ תתיח לרעח. לת צשחמי לורם איפסום דולור סיט אמט",
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_12,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
