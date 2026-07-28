import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../ui/widget/more_details_screen_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/more_details/more_details_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

class MoreDetailsRoute {
  static Widget get route => const MoreDetailsScreen();
}

class MoreDetailsScreen extends StatelessWidget {
  const MoreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
        create: (context) => MoreDetailsBloc()
          ..add(MoreDetailsEvent.getProfileMoreDetailsEvent(
              context: context, isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false ? true : false))
          ..add(MoreDetailsEvent.getProfileModelEvent(profileModel: args?[AppStrings.profileParamString] ?? const ProfileModel(), context: context)),
        child: MoreDetailsScreenWidget());
  }
}

class MoreDetailsScreenWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  MoreDetailsScreenWidget({super.key});

  static const double _horizontalPadding = 16;
  static const double _fieldRadius = 12;

  @override
  Widget build(BuildContext context) {
    final listNotifier = ValueNotifier<List<String>>([]);

    MoreDetailsBloc bloc = context.read<MoreDetailsBloc>();
    return BlocBuilder<MoreDetailsBloc, MoreDetailsState>(
        buildWhen: (previous, current) =>
            previous.isShimmering != current.isShimmering ||
            previous.isLoading != current.isLoading ||
            previous.isUpdating != current.isUpdating ||
            previous.isUpdate != current.isUpdate ||
            previous.selectCity != current.selectCity ||
            previous.cityList != current.cityList ||
            previous.filterList != current.filterList ||
            previous.approveForSMS != current.approveForSMS ||
            previous.streetNameController != current.streetNameController ||
            previous.streetNumberController != current.streetNumberController ||
            previous.emailController != current.emailController ||
            previous.zipController != current.zipController ||
            previous.cityController != current.cityController,
        builder: (context, state) {
          if (listNotifier.value.isEmpty) {
            listNotifier.value = [...state.cityList];
          }

          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                  bgColor: AppColors.pageColor,
                  title: AppLocalizations.of(context)!.more_details,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  trailingWidget: _buildAppBarIcon(),
                  onTap: () => Navigator.pop(context)),
            ),
            body: SafeArea(child:  state.isShimmering
                ? const MoreDetailsScreenShimmerWidget()
                : Stack(children: [
                    SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 32),
                      child: Form(
                        key: _formKey,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          _buildFormCard(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            _buildFieldLabel(context, AppLocalizations.of(context)!.city),
                            _buildCityField(context: context, bloc: bloc, state: state, listNotifier: listNotifier),
                            14.height,
                            _buildFieldLabel(context, AppLocalizations.of(context)!.street_name),
                            streetNameField(state, context),
                            14.height,
                            _buildFieldLabel(context, AppLocalizations.of(context)!.street_number),
                            streetNumberField(state, context),
                            14.height,
                            _buildFieldLabel(context, AppLocalizations.of(context)!.email, required: false),
                            emailField(state, context),
                            14.height,
                            _buildFieldLabel(context, AppLocalizations.of(context)!.zip, required: false),
                            zipField(state, context),
                            16.height,
                            Divider(height: 1, color: AppColors.lightBorderColor.withValues(alpha: 0.6)),
                            12.height,
                            _buildSmsSwitchRow(context, bloc, state)
                          ])),
                          24.height,
                          saveButtonWidget(context, bloc, state),
                        ]),
                      ),
                    ),
                    if (state.isUpdating)
                      Positioned.fill(
                        child: ColoredBox(
                            color: Colors.black.withValues(alpha: 0.04),
                            child: Center(child: CupertinoActivityIndicator(color: AppColors.mainColor, radius: AppConstants.radius_20))),
                      ),
                  ]),
          ),);
        });
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
        padding: const EdgeInsets.all(16),
        child: child);
  }

  Widget _buildAppBarIcon() {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.storefront_outlined, size: 21, color: AppColors.mainColor));
  }

  Widget _buildFieldLabel(BuildContext context, String label, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (required) Text('* ', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.redColor)),
        Expanded(
          child: Text(label,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_13, color: AppColors.blackColor.withValues(alpha: 0.55), fontWeight: FontWeight.w500)),
        ),
      ]),
    );
  }

  Widget _buildCityField(
      {required BuildContext context,
      required MoreDetailsBloc bloc,
      required MoreDetailsState state,
      required ValueNotifier<List<String>> listNotifier}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showCityPicker(context: context, bloc: bloc, state: state, listNotifier: listNotifier),
        borderRadius: BorderRadius.circular(_fieldRadius),
        child: Container(
          height: AppConstants.textFormFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: AppColors.pageColor, borderRadius: BorderRadius.circular(_fieldRadius), border: Border.all(color: AppColors.lightBorderColor)),
          child: Row(children: [
            Expanded(
              child: Text(state.selectCity.isEmpty ? AppLocalizations.of(context)!.city : state.selectCity,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: state.selectCity.isEmpty ? AppColors.blackColor.withValues(alpha: 0.4) : AppColors.blackColor)),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.blackColor.withValues(alpha: 0.45)),
          ]),
        ),
      ),
    );
  }

  void _showCityPicker(
      {required BuildContext context,
      required MoreDetailsBloc bloc,
      required MoreDetailsState state,
      required ValueNotifier<List<String>> listNotifier}) {
    showModalBottomSheet(
        backgroundColor: AppColors.whiteColor,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context1) {
          return ValueListenableBuilder(
              valueListenable: listNotifier,
              builder: (context, content, child) {
                return Padding(
                  padding: const EdgeInsets.all(AppConstants.padding_15),
                  child: SizedBox(
                    height: getScreenHeight(context) * 0.9,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(AppLocalizations.of(context)!.city,
                            style: AppStyles.rkBoldTextStyle(size: AppConstants.font_17, color: AppColors.blackColor)),
                        IconButton(onPressed: () => Navigator.pop(context1), icon: const Icon(Icons.close_rounded)),
                      ]),
                      12.height,
                      CustomFormField(
                          context: context,
                          prefixIcon: Icon(Icons.search_rounded, color: AppColors.blackColor.withValues(alpha: 0.4)),
                          onChangeValue: (value) {
                            bloc.add(MoreDetailsEvent.citySearchEvent(search: value));
                            listNotifier.value = state.cityList.where((city) => city.contains(value)).toList();
                          },
                          controller: state.cityController,
                          keyboardType: TextInputType.text,
                          hint: AppLocalizations.of(context)!.city,
                          fillColor: AppColors.pageColor,
                          textInputAction: TextInputAction.next,
                          validator: '',
                          textCapitalization: TextCapitalization.words,
                          autofocus: true,
                          cursorColor: AppColors.mainColor,
                          border: _fieldRadius),
                      12.height,
                      listNotifier.value.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(AppLocalizations.of(context)!.cities_not_available,
                                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor)),
                              ),
                            )
                          : Expanded(
                              child: ListView.separated(
                                  itemCount: listNotifier.value.length,
                                  separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.lightBorderColor.withValues(alpha: 0.6)),
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(listNotifier.value[index],
                                            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_15, color: AppColors.blackColor)),
                                        onTap: () {
                                          bloc.add(MoreDetailsEvent.selectCityEvent(city: listNotifier.value[index], context: context));
                                          Navigator.pop(context1);
                                        });
                                  }),
                            ),
                    ]),
                  ),
                );
              });
        });
  }

  Widget _buildTextField(
      {required BuildContext context,
      required TextEditingController controller,
      required TextInputType keyboardType,
      required String validator,
      TextInputAction? textInputAction,
      List<TextInputFormatter>? inputFormat,
      TextDirection? textDirection}) {
    return CustomFormField(
        context: context,
        controller: controller,
        keyboardType: keyboardType,
        hint: '',
        fillColor: AppColors.pageColor,
        textInputAction: textInputAction,
        validator: validator,
        inputFormat: inputFormat,
        textDirection: textDirection,
        border: _fieldRadius,
        cursorColor: AppColors.mainColor);
  }

  Widget streetNameField(MoreDetailsState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.streetNameController,
      inputFormat: [LengthLimitingTextInputFormatter(50)],
      keyboardType: TextInputType.text,
      validator: AppStrings.streetNameValString,
      textInputAction: TextInputAction.next);

  Widget streetNumberField(MoreDetailsState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.streetNumberController,
      inputFormat: [LengthLimitingTextInputFormatter(50)],
      keyboardType: TextInputType.number,
      validator: AppStrings.streetNumberValString,
      textInputAction: TextInputAction.next);

  Widget emailField(MoreDetailsState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: state.emailController.text.toString().isNotEmpty ? AppStrings.emailValString : '',
      textInputAction: TextInputAction.next);

  Widget zipField(MoreDetailsState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.zipController,
      inputFormat: [FilteringTextInputFormatter.digitsOnly],
      textDirection: context.rtl ? TextDirection.ltr : null,
      keyboardType: TextInputType.number,
      validator: state.zipController.text.toString().isNotEmpty ? AppStrings.zipValString : '',
      textInputAction: TextInputAction.done);

  Widget _buildSmsSwitchRow(BuildContext context, MoreDetailsBloc bloc, MoreDetailsState state) {
    return Row(children: [
      Expanded(
        child: Text(AppLocalizations.of(context)!.approve_for_promotional_info,
            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor.withValues(alpha: 0.75))),
      ),
      8.width,
      Transform.scale(
        scale: 0.88,
        child: CupertinoSwitch(
            value: state.approveForSMS,
            onChanged: (newVal) {
              bloc.add(MoreDetailsEvent.setApprovalSMSSwitchEvent(context: context, updatedVal: newVal));
            },
            activeTrackColor: AppColors.mainColor,
            thumbColor: AppColors.whiteColor,
            inactiveTrackColor: AppColors.lightBorderColor),
      ),
    ]);
  }

  Widget saveButtonWidget(BuildContext context, MoreDetailsBloc bloc, MoreDetailsState state) => CustomButtonWidget(
      buttonText: state.isUpdate ? AppLocalizations.of(context)!.save.toUpperCase() : AppLocalizations.of(context)!.next.toUpperCase(),
      bGColor: AppColors.mainColor,
      isLoading: state.isLoading,
      radius: 14,
      fontColors: AppColors.whiteColor,
      onPressed: state.isLoading
          ? null
          : () {
              if (state.selectCity != '') {
                if (_formKey.currentState?.validate() ?? false) {
                  bloc.add(MoreDetailsEvent.registrationApiEvent(context: context));
                }
              } else {
                CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_city, type: SnackBarType.failure);
              }
            });
}
