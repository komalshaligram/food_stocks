import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../bloc/splash/splash_bloc.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/storage/shared_preferences_helper.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

class SplashRoute {
  static Widget get route => const SplashScreen();
}

const Gradient _brandGradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff1D5499), Color(0xff8BC53F)]);

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
        create: (context) => SplashBloc()..add(SplashEvent.splashLoaded(pushNavigation: args?[AppStrings.pushNavigationString] ?? '')),
        child: const SplashScreenWidget());
  }
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  void getVersion(SharedPreferencesHelper preferences) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    preferences.setAppVersion(version: version);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPad = MediaQuery.of(context).padding.bottom;
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) async {
        if (state.isRedirected) {
          SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
          getVersion(preferences);

          if (preferences.getUserLoggedIn()) {
            if (preferences.getRegistrationIncomplete()) {
              Navigator.pushReplacementNamed(context, RouteDefine.profileScreen.name,
                  arguments: {AppStrings.contactString: preferences.getPhoneNumber()});
            } else {
              Navigator.pushReplacementNamed(context, RouteDefine.bottomNavScreen.name,
                  arguments: {AppStrings.pushNavigationString: state.pushNavigation});
            }
          } else {
            Navigator.pushReplacementNamed(context, RouteDefine.connectScreen.name);
          }
        }
      },
      child: BlocBuilder<SplashBloc, SplashState>(builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(gradient: _brandGradient),
            child: Stack(children: [
              Positioned(top: -60, right: -70, child: _decorCircle(230, Colors.white.withValues(alpha: 0.07))),
              Positioned(top: 140, left: -90, child: _decorCircle(170, Colors.white.withValues(alpha: 0.05))),
              Positioned(bottom: -80, right: -60, child: _decorCircle(220, Colors.white.withValues(alpha: 0.06))),
              Center(
                child: AnimatedOpacity(
                  curve: Curves.decelerate,
                  opacity: state.isAnimate ? 1 : 0,
                  duration: const Duration(milliseconds: 900),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    AnimatedScale(
                      curve: Curves.decelerate,
                      scale: state.isAnimate ? 1 : 1.15,
                      duration: const Duration(milliseconds: 700),
                      child: SizedBox(
                        width: getScreenWidth(context) * 0.82,
                        height: getScreenWidth(context) * 0.82,
                        child: Stack(alignment: Alignment.center, children: [
                          const _PulseRings(),
                          Image.asset(AppImagePath.splashLogoWhite,
                              width: getScreenWidth(context) * 0.42, height: getScreenHeight(context) * 0.13, fit: BoxFit.contain),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(AppLocalizations.of(context)!.splash_tagline,
                        textAlign: TextAlign.center,
                        style: AppStyles.rkBoldTextStyle(size: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomPad + 26,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _loaderBar(),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.splash_brand,
                      textAlign: TextAlign.center,
                      style: AppStyles.rkRegularTextStyle(size: 13, color: AppColors.whiteColor.withValues(alpha: 0.85))),
                ]),
              ),
            ]),
          ),
        );
      }),
    );
  }

  Widget _decorCircle(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }

  Widget _loaderBar() {
    return Center(
      child: Container(
        width: 140,
        height: 5,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(10)),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
              widthFactor: 0.5, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)))),
        ),
      ),
    );
  }
}

class _PulseRings extends StatefulWidget {
  const _PulseRings();

  @override
  State<_PulseRings> createState() => _PulseRingsState();
}

class _PulseRingsState extends State<_PulseRings> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller, builder: (context, _) => CustomPaint(size: Size.infinite, painter: _RingsPainter(_controller.value)));
  }
}

class _RingsPainter extends CustomPainter {
  final double progress;
  static const int _count = 3;

  _RingsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxR = size.width / 2;
    for (int i = 0; i < _count; i++) {
      final double t = (progress + i / _count) % 1.0;
      final double r = maxR * (0.30 + 0.70 * t);
      final double opacity = (1.0 - t) * 0.35;
      final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) => oldDelegate.progress != progress;
}
