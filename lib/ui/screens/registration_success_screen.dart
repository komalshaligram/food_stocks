import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/registration_success/registration_success_bloc.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../widget/confetti.dart';

class RegistrationSuccessRoute {
  static Widget get route => const RegistrationSuccessScreen();
}

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationSuccessBloc()
        ..add(const RegistrationSuccessEvent.celebrationEvent())
        ..add(RegistrationSuccessEvent.generalSettings(context: context)),
      child: const RegistrationSuccessScreenWidget(),
    );
  }
}

class RegistrationSuccessScreenWidget extends StatefulWidget {
  const RegistrationSuccessScreenWidget({super.key});

  @override
  State<RegistrationSuccessScreenWidget> createState() => _RegistrationSuccessScreenWidgetState();
}

class _RegistrationSuccessScreenWidgetState extends State<RegistrationSuccessScreenWidget> {
  final player = AudioPlayer();
  SharedPreferencesHelper? preferencesHelper;

  @override
  void initState() {
    super.initState();
    player.play(AssetSource(AppStrings.successSound));
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      preferencesHelper = SharedPreferencesHelper(prefs: prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationSuccessBloc, RegistrationSuccessState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: AppColors.pageColor,
          body: FocusDetector(
            onFocusGained: () {
              RegistrationSuccessBloc().add(RegistrationSuccessEvent.generalSettings(context: context));
            },
            child: SafeArea(
              child: Stack(children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_50),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(AppConstants.radius_10),
                          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.10), blurRadius: AppConstants.blur_10)],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [SizedBox(height: 180, width: 180, child: Image.asset(AppImagePath.successIcon))],
                        ),
                      ),
                      75.height,
                      Center(
                        child: Text(
                          state.registrationSuccessMessage,
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_22, color: AppColors.blackColor, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(flex: 5, child: SizedBox()),
                      20.height,
                      GestureDetector(
                          onTap: () async {
                            if (preferencesHelper != null) {
                              await preferencesHelper!.setUserLoggedIn(isLoggedIn: true);
                              Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_50),
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.20), blurRadius: AppConstants.blur_10)],
                              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_40)),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(AppConstants.padding_10),
                              height: AppConstants.containerHeight_60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_40)),
                              child: Text(AppLocalizations.of(context)!.continues, style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.whiteColor)),
                            ),
                          )),
                    ]),
                  ),
                ),
                SizedBox.expand(
                  child: Visibility(visible: state.duringCelebration, child: IgnorePointer(child: Confetti(isStopped: !state.duringCelebration, snippingCount: 200, snipSize: 7.0))),
                ),
              ]),
            ),
          ),
        ),
      );
    });
  }
}
