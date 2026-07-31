import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/otp/otp_bloc.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_styles.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../widget/dialogs/otp_whatsapp_sent_dialog.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../utils/constants/app_strings.dart';

class OTPRoute {
  static Widget get route => const OTPScreen();
}

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final temp = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    return BlocProvider(
      create: (context) => OtpBloc()
        ..add(OtpEvent.setOtpTimer(contact: temp[AppStrings.contactString] ?? ''))
        ..add(OtpEvent.loadWhatsappOtpSettingEvent(context: context)),
      child: OTPScreenWidget(isRegister: temp[AppStrings.isRegisterString], contact: temp[AppStrings.contactString]),
    );
  }
}

class OTPScreenWidget extends StatefulWidget {
  final bool isRegister;
  final String contact;

  const OTPScreenWidget({super.key, required this.isRegister, required this.contact});

  @override
  State<OTPScreenWidget> createState() => _OTPScreenWidgetState();
}

class _OTPScreenWidgetState extends State<OTPScreenWidget> {
  String _code = "";
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void _verifyOtp(BuildContext context, OtpBloc bloc) {
    if (widget.isRegister == true) {
      bloc.add(OtpEvent.registerApiEvent(contact: widget.contact, otp: _code, isRegister: widget.isRegister, context: context));
    } else {
      bloc.add(OtpEvent.otpApiEvent(contact: widget.contact, otp: _code, isRegister: widget.isRegister, context: context));
    }
  }

  void _onSubmitPressed(BuildContext context, OtpBloc bloc) {
    FocusScope.of(context).unfocus();
    if (_code.isEmpty) {
      CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_otp, type: SnackBarType.failure);
    } else if (_code.length != 4) {
      CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.enter_4digit_otp, type: SnackBarType.failure);
    } else {
      _verifyOtp(context, bloc);
    }
  }

  @override
  Widget build(BuildContext context) {
    final OtpBloc bloc = context.read<OtpBloc>();
    final double screenHeight = getScreenHeight(context);
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) async {
        await SmsAutoFill().listenForCode();
      },
      child: BlocBuilder<OtpBloc, OtpState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          resizeToAvoidBottomInset: true,
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(gradient: AppColors.appMainGradientColor),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildHero(context, bloc),
                      Expanded(child: _buildCard(context, bloc, state)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHero(BuildContext context, OtpBloc bloc) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        Positioned(top: -40, left: -50, child: _decorCircle(160, Colors.white.withValues(alpha:0.08))),
        Positioned(top: 60, right: -55, child: _decorCircle(130, Colors.white.withValues(alpha: 0.06))),
        Padding(
          padding: EdgeInsets.only(top: topPadding + 12, left: 24, right: 24, bottom: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    bloc.add(const OtpEvent.cancelOtpTimerSubscription());
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
                    child: const Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ),
              10.height,
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.smartphone_rounded, color: Colors.white, size: 32),
              ),
              16.height,
              Text(
                AppLocalizations.of(context)!.verify_phone_title,
                textAlign: TextAlign.center,
                style: AppStyles.rkBoldTextStyle(size: 23, color: AppColors.whiteColor, fontWeight: FontWeight.w700),
              ),
              8.height,
              Text(
                AppLocalizations.of(context)!.otp_sent_subtitle,
                textAlign: TextAlign.center,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor.withValues(alpha: 0.9)),
              ),
              6.height,
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  widget.contact,
                  style: AppStyles.rkBoldTextStyle(size: 18, color: AppColors.whiteColor, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, OtpBloc bloc, OtpState state) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(28, 20, 28, 30 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(34), topRight: Radius.circular(34)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 24, offset: const Offset(0, -6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(color: AppColors.borderColor, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          22.height,
          Text(
            AppLocalizations.of(context)!.enter_verification_code,
            style: AppStyles.rkBoldTextStyle(size: 18, color: AppColors.blackColor, fontWeight: FontWeight.w600),
          ),
          22.height,
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              height: 70,
              child: PinFieldAutoFill(
                keyboardType: TextInputType.number,
                decoration: BoxLooseDecoration(
                  radius: const Radius.circular(12),
                  strokeWidth: 1.5,
                  gapSpace: 12,
                  bgColorBuilder: FixedColorBuilder(AppColors.whiteColor),
                  textStyle: AppStyles.rkBoldTextStyle(size: AppConstants.font_30, color: AppColors.blackColor, fontWeight: FontWeight.w600),
                  strokeColorBuilder: FixedColorBuilder(AppColors.mainColor),
                ),
                currentCode: _code,
                autoFocus: true,
                focusNode: myFocusNode,
                enableInteractiveSelection: false,
                codeLength: 4,
                onCodeSubmitted: (code) {
                  bloc.add(OtpEvent.changeOtpEvent(otp: code));
                },
                onCodeChanged: (code) {
                  _code = code ?? '';
                  if (_code.length == 4) {
                    _verifyOtp(context, bloc);
                  }
                },
              ),
            ),
          ),
          26.height,
          _buildPrimaryButton(context, isLoading: state.isLoading, onPressed: () => _onSubmitPressed(context, bloc)),
          22.height,
          _buildResend(context, bloc, state),
          if (state.showWhatsappOtpOption) ...[
            18.height,
            _buildWhatsappFallback(context, bloc, state),
          ],
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context, {required bool isLoading, required VoidCallback onPressed}) {
    return Container(
      height: AppConstants.buttonHeight,
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: AppColors.appMainGradientColor,
        borderRadius: BorderRadius.circular(AppConstants.radius_10),
        boxShadow: [BoxShadow(color: AppColors.blueColor.withValues(alpha: 0.30), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        padding: EdgeInsets.zero,
        child: isLoading
            ? const Center(child: SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)))
            : Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context)!.verify_and_login,
                style: AppStyles.rkBoldTextStyle(size: 17, color: AppColors.whiteColor, fontWeight: FontWeight.w600),
              ),
            ),
            const Positioned(
              left: 18,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResend(BuildContext context, OtpBloc bloc, OtpState state) {
    final bool isCoolingDown = state.otpTimer != 0;
    final String label = isCoolingDown
        ? '${AppLocalizations.of(context)!.resend_code_in} ${_formatCountdown(context, state.otpTimer)}'
        : AppLocalizations.of(context)!.resend_code;
    final Color contentColor = isCoolingDown ? AppColors.greyColor : AppColors.whiteColor;

    return Container(
      width: double.maxFinite,
      height: AppConstants.buttonHeight,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isCoolingDown ? AppColors.iconBGColor : AppColors.blueColor,
        borderRadius: BorderRadius.circular(AppConstants.radius_10),
        border: isCoolingDown ? Border.all(color: AppColors.borderColor, width: 1.2) : null,
        boxShadow: isCoolingDown
            ? null
            : [BoxShadow(color: AppColors.blueColor.withValues(alpha: 0.28), blurRadius: 12, offset: const Offset(0, 5))],
      ),
      child: MaterialButton(
        onPressed: isCoolingDown
            ? null
            : () => bloc.add(OtpEvent.logInApiDataEvent(context: context, isRegister: widget.isRegister, contactNumber: widget.contact)),
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isCoolingDown ? Icons.timer_outlined : Icons.sms_outlined, size: 20, color: contentColor),
            10.width,
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppStyles.rkBoldTextStyle(size: 16, color: contentColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatsappFallback(BuildContext context, OtpBloc bloc, OtpState state) {
    final bool isCoolingDown = state.otpTimer != 0;
    final bool isDisabled = isCoolingDown || state.isWhatsappSending;
    final Color contentColor = isDisabled ? AppColors.greyColor : kWhatsappDarkGreen;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.borderColor, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                AppLocalizations.of(context)!.did_not_get_sms,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.greyColor),
              ),
            ),
            Expanded(child: Divider(color: AppColors.borderColor, thickness: 1)),
          ],
        ),
        14.height,
        Opacity(
          opacity: isDisabled ? 0.5 : 1,
          child: Container(
            width: double.maxFinite,
            height: AppConstants.buttonHeight,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(AppConstants.radius_10),
              border: Border.all(color: isDisabled ? AppColors.borderColor : kWhatsappGreen, width: 1.2),
            ),
            child: MaterialButton(
              onPressed: isDisabled
                  ? null
                  : () {
                FocusScope.of(context).unfocus();
                bloc.add(OtpEvent.sendOtpViaWhatsappEvent(context: context, contactNumber: widget.contact));
              },
              padding: EdgeInsets.zero,
              child: state.isWhatsappSending
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: kWhatsappDarkGreen),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImagePath.whatsapp,
                    height: 22,
                    width: 22,
                    color: isDisabled ? AppColors.greyColor : null,
                  ),
                  10.width,
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.send_code_via_whatsapp,
                      textAlign: TextAlign.center,
                      style: AppStyles.rkBoldTextStyle(
                        size: AppConstants.font_14 + 1,
                        color: contentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCountdown(BuildContext context, int seconds) {
    if (seconds < 60) {
      return '$seconds ${AppLocalizations.of(context)!.seconds_short}';
    }
    final String secs = (seconds % 60).toString().padLeft(2, '0');
    return '${seconds ~/ 60}:$secs';
  }

  Widget _decorCircle(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}