import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../bloc/connect_screen/connect_bloc.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/login/log_in_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../widget/custom_form_field_widget.dart';

class ConnectRoute {
  static Widget get route => const ConnectScreen();
}

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ConnectBloc()), BlocProvider(create: (context) => LogInBloc())],
      child: const ConnectScreenWidget(),
    );
  }
}

const Gradient _brandGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color(0xff1D5499), Color(0xff8BC53F)],
);

class ConnectScreenWidget extends StatefulWidget {
  const ConnectScreenWidget({super.key});

  @override
  State<ConnectScreenWidget> createState() => _ConnectScreenWidgetState();
}

class _ConnectScreenWidgetState extends State<ConnectScreenWidget> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_syncCooldown);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncCooldown();
      scheduleScreenUpdateCheck(null);
    });
  }

  void _syncCooldown() {
    if (!mounted) return;
    context.read<LogInBloc>().add(LogInEvent.syncCooldown(contactNumber: phoneController.text));
  }

  @override
  void dispose() {
    phoneController.removeListener(_syncCooldown);
    phoneController.dispose();
    super.dispose();
  }

  void _submitPhone(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LogInBloc>().add(LogInEvent.logInApiDataEvent(contactNumber: phoneController.text, context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = getScreenHeight(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(gradient: _brandGradient),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Column(children: [_buildHero(context), Expanded(child: _buildCard(context))]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Stack(children: [
      Positioned(top: -40, left: -50, child: _decorCircle(160, Colors.white.withOpacity(0.08))),
      Positioned(top: 70, right: -60, child: _decorCircle(140, Colors.white.withOpacity(0.06))),
      Padding(
        padding: EdgeInsets.only(top: topPadding + 34, left: 28, right: 28, bottom: 26),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 26),
            decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(28), boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 8)),
            ]),
            child: SvgPicture.asset(AppImagePath.splashLogo, height: 110, fit: BoxFit.contain),
          ),
          22.height,
          Text(AppLocalizations.of(context)!.welcome_title,
              textAlign: TextAlign.center, style: AppStyles.rkBoldTextStyle(size: 24, color: AppColors.whiteColor, fontWeight: FontWeight.w700)),
          12.height,
          Text(AppLocalizations.of(context)!.app_slogan,
              textAlign: TextAlign.center,
              style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont,
                color: AppColors.whiteColor.withOpacity(0.92),
                fontWeight: FontWeight.w400,
              ).copyWith(height: 1.5)),
        ]),
      ),
    ]);
  }

  Widget _buildCard(BuildContext context) {
    return BlocBuilder<LogInBloc, LogInState>(builder: (context, loginState) {
      return Container(
        width: double.maxFinite,
        padding: EdgeInsets.fromLTRB(28, 20, 28, 30 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(34), topRight: Radius.circular(34)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 24, offset: const Offset(0, -6)),
            ]),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            22.height,
            Text(AppLocalizations.of(context)!.login,
                style: AppStyles.rkBoldTextStyle(size: 22, color: AppColors.blackColor, fontWeight: FontWeight.w700)),
            8.height,
            Text(AppLocalizations.of(context)!.login_subtitle,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.greyColor, fontWeight: FontWeight.w400)),
            24.height,
            Text(
              AppLocalizations.of(context)!.enter_your_phone,
              style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_14,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            10.height,
            CustomFormField(
              inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              context: context,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              hint: AppStrings.hintNumberString,
              fillColor: AppColors.whiteColor,
              textInputAction: TextInputAction.done,
              validator: AppStrings.mobileValString,
              border: 12,
              contentPaddingTop: 16,
              contentPaddingBottom: 16,
              onFieldSubmitted: (_) => _submitPhone(context),
              postIconBtn: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12), child: Icon(Icons.phone_outlined, color: AppColors.mainColor, size: 22)),
            ),
            24.height,
            _buildPrimaryButton(context, isLoading: loginState.isLoading, otpCooldown: loginState.otpCooldown),
            22.height,
            _buildOrDivider(context),
            18.height,
            CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!.login_as_guest,
                fontColors: AppColors.mainColor,
                borderColor: AppColors.mainColor,
                isFromConnectScreen: true,
                isLoading: context.watch<ConnectBloc>().state.isLoading,
                loadingColor: AppColors.mainColor,
                fontSize: 16,
                enable: !loginState.isLoading,
                onPressed: context.watch<ConnectBloc>().state.isLoading
                    ? null
                    : () {
                        context.read<ConnectBloc>().add(ConnectEvent.logInAsGuest(context: context));
                      }),
          ]),
        ),
      );
    });
  }

  String _formatCountdown(BuildContext context, int seconds) {
    if (seconds < 60) {
      return '$seconds ${AppLocalizations.of(context)!.seconds_short}';
    }
    return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  Widget _buildPrimaryButton(BuildContext context, {required bool isLoading, required int otpCooldown}) {
    final bool isCoolingDown = otpCooldown > 0;
    return Container(
      height: AppConstants.buttonHeight,
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          gradient: isCoolingDown ? null : _brandGradient,
          color: isCoolingDown ? AppColors.iconBGColor : null,
          border: isCoolingDown ? Border.all(color: AppColors.borderColor, width: 1.2) : null,
          borderRadius: BorderRadius.circular(AppConstants.radius_10),
          boxShadow: isCoolingDown
              ? null
              : [
                  BoxShadow(color: AppColors.blueColor.withOpacity(0.30), blurRadius: 14, offset: const Offset(0, 6)),
                ]),
      child: MaterialButton(
        onPressed: (isLoading || isCoolingDown) ? null : () => _submitPhone(context),
        padding: EdgeInsets.zero,
        child: isLoading
            ? const Center(child: SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)))
            : isCoolingDown
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_outlined, size: 20, color: AppColors.greyColor),
                      10.width,
                      Flexible(
                        child: Text(
                          '${AppLocalizations.of(context)!.resend_code_in} ${_formatCountdown(context, otpCooldown)}',
                          textAlign: TextAlign.center,
                          style: AppStyles.rkBoldTextStyle(size: 16, color: AppColors.greyColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                : Stack(alignment: Alignment.center, children: [
                    Center(
                      child: Text(AppLocalizations.of(context)!.next,
                          style: AppStyles.rkBoldTextStyle(size: 17, color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
                    ),
                    const Positioned(
                      left: 18,
                      child: Directionality(
                          textDirection: TextDirection.ltr, child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 15)),
                    ),
                  ]),
      ),
    );
  }

  Widget _buildOrDivider(BuildContext context) {
    return Row(children: [
      Expanded(child: Divider(color: AppColors.borderColor, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child:
            Text(AppLocalizations.of(context)!.or, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.lightGreyColor)),
      ),
      Expanded(child: Divider(color: AppColors.borderColor, thickness: 1)),
    ]);
  }

  Widget _decorCircle(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}
