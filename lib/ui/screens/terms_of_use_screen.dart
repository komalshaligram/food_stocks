import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/widget/common_static_content_container.dart';
import '../../bloc/terms_of_use/terms_of_use_bloc.dart';
import '../utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/themes/app_constants.dart';
import '../widget/common_app_bar.dart';

class TermsOfUseRoute {
  static Widget get route => TermsOfUseScreen();
}

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TermsOfUseBloc(),
      child: TermsOfUseScreenWidget(),
    );
  }
}

class TermsOfUseScreenWidget extends StatelessWidget {
  const TermsOfUseScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TermsOfUseBloc, TermsOfUseState>(
      listener: (context, state) {},
      child: BlocBuilder<TermsOfUseBloc, TermsOfUseState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: CommonAppBar(
                  title: AppLocalizations.of(context)!.terms_of_use,
                  iconData: Icons.arrow_back_ios_sharp,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: CommonStaticContentContainer(
                    content:
                        "לורם איפסום דולור סיט אמט, קונסקטורר אדיפיסינג אלית נולום ארווס סאפיאן - פוסיליס קוויס, אקווזמן קוואזי במר מודוף. אודיפו בלאסטיק מונופץ קליר, בנפת נפקט למסון בלרק - וענוף הועניב היושבב שערש שמחויט - שלושע ותלברו חשלו שעותלשך וחאית נובש ערששף. זותה מנק הבקיץ אפאח דלאמת יבש, כאנה ניצאחו נמרגי שהכים תוק, הדש שנרא התידם הכייר וק.ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי מגמש. תרבנך וסתעד לכנו סתשם השמה - לתכי מורגם בורק? לתיג ישבעס.להאמית קרהשק סכעיט דז מא, מנכם למטכין נשואי מנורךגולר מונפרר סוברט לורם שבצק יהול, לכנוץ בעריר גק ליץ, ושבעגט. ושבעגט ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי מגמש. תרבנך וסתעד לכנו סתשם השמה - לתכי מורגם בורק? לתיג ישבעס.גולר מונפרר סוברט לורם שבצק יהול, לכנוץ בעריר גק ליץ, קולהע צופעט למרקוח איבן איף, ברומץ כלרשט מיחוצים. קלאצי מוסן מנת. להאמית קרהשק סכעיט דז מא, מנכם למטכין נשואי מנורך. גולר מונפרר סוברט לורם שבצק יהול, לכנוץ בעריר גק ליץ, ושבעגט ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי מגמש. תרבנך וסתעד לכנו סתשם השמה - לתכי מורגם בורק? לתיג ישבעס.נולום ארווס סאפיאן - פוסיליס קוויס, אקווזמן נולום ארווס סאפיאן - פוסיליס קוויס, אקווזמן קוואזי במר מודוף. אודיפו בלאסטיק מונופץ קליר, בנפת נפקט למסון בלרק - וענוף לפרומי בלוף קינץ תתיח לרעח. לת צשחמי לורם איפסום דולור סיט אמט, קונסקטורר אדיפיסינג אלית. סת אלמנקום ניסי נון ניבאה. דס איאקוליס וולופטה דיאם. וסטיבולום אט דולור, קראס אגת לקטוס וואל אאוגו וסטיבולום סוליסי טידום בעליק. קונדימנטום קורוס בליקרה, נונסטי קלובר בריקנה סטום, לפריקך תצטריק לרטי.קונסקטורר אדיפיסינג אלית. סת אלמנקום ניסי נון ניבאה. דס איאקוליס וולופטה דיאם. וסטיבולום אט דולור, קראס אגת לקטוס וואל אאוגו וסטיבולום סוליסי טידום בעליק. קונדימנטום קורוס בליקרה, נונסטי קלובר בריקנה סטום, לפריקך תצטריק לרטי.לפרומי בלוף קינץ תתיח לרעח. לת צשחמי צש בליא, מנסוטו צמלח לביקו ננבי, צמוקו בלוקריה שיצמה ברורק. קולורס מונפרד אדנדום סילקוף, מרגשי ומרגשח. עמחליף"),
              ),
            ),
          );
        },
      ),
    );
  }
}
