import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../bloc/verify_client_data/verify_client_data_bloc.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/widget/common_app_bar.dart';
import '../../ui/widget/custom_form_field_widget.dart';
import '../../ui/widget/sized_box_widget.dart';

/// Client data verification screen shown after first-order-from-supplier dialog.
/// See docs/en/FIRST-ORDER-AND-CLIENT-VERIFICATION.md
class VerifyClientDataRoute {
  static Widget get route => const VerifyClientDataScreen();
}

class VerifyClientDataScreen extends StatelessWidget {
  const VerifyClientDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (_) => VerifyClientDataBloc()
        ..add(VerifyClientDataEvent.initEvent(
          context: context,
          nextRouteName: args?[AppStrings.verifyClientNextRoute],
          nextRouteArgs: args?[AppStrings.verifyClientNextArgs],
        )),
      child: const VerifyClientDataScreenWidget(),
    );
  }
}

class VerifyClientDataScreenWidget extends StatelessWidget {
  const VerifyClientDataScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final listNotifier = ValueNotifier<List<String>>([]);
    final bloc = context.read<VerifyClientDataBloc>();
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<VerifyClientDataBloc, VerifyClientDataState>(builder: (context, state) {
      if (listNotifier.value.isEmpty && state.cityList.isNotEmpty) {
        listNotifier.value = [...state.cityList];
      }

      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: l10n.verify_data_correct,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: state.isShimmering
            ? Center(child: CircularProgressIndicator(color: AppColors.mainColor))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _HeaderBanner(subtitle: l10n.verify_form_subtitle),
                            20.height,
                            _FormSectionCard(
                              icon: Icons.storefront_rounded,
                              iconColor: AppColors.blueColor,
                              title: l10n.business_details_section,
                              children: [
                                _ModernField(
                                  label: l10n.business_name,
                                  required: true,
                                  child: CustomFormField(
                                    context: context,
                                    controller: state.businessNameController,
                                    keyboardType: TextInputType.text,
                                    hint: l10n.business_name,
                                    fillColor: AppColors.iconBGColor,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.businessNameValString,
                                    isBorderVisible: false,
                                    border: 12,
                                  ),
                                ),
                                14.height,
                                _ModernField(
                                  label: l10n.contact_name,
                                  required: true,
                                  child: CustomFormField(
                                    context: context,
                                    controller: state.contactNameController,
                                    keyboardType: TextInputType.name,
                                    hint: l10n.contact_name,
                                    fillColor: AppColors.iconBGColor,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.contactNameValString,
                                    isBorderVisible: false,
                                    border: 12,
                                  ),
                                ),
                              ],
                            ),
                            16.height,
                            _FormSectionCard(
                              icon: Icons.location_on_rounded,
                              iconColor: AppColors.mainColor,
                              title: l10n.address_section,
                              children: [
                                _ModernField(
                                  label: l10n.city,
                                  required: true,
                                  child: _SelectField(
                                    value: state.selectCity,
                                    hint: l10n.city,
                                    onTap: () => _showCityPicker(context, bloc, state, listNotifier),
                                  ),
                                ),
                                14.height,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _ModernField(
                                        label: l10n.street_name,
                                        required: true,
                                        child: CustomFormField(
                                          context: context,
                                          controller: state.streetNameController,
                                          inputFormat: [LengthLimitingTextInputFormatter(50)],
                                          keyboardType: TextInputType.streetAddress,
                                          hint: l10n.street_name,
                                          fillColor: AppColors.iconBGColor,
                                          textInputAction: TextInputAction.next,
                                          validator: AppStrings.streetNameValString,
                                          isBorderVisible: false,
                                          border: 12,
                                        ),
                                      ),
                                    ),
                                    10.width,
                                    Expanded(
                                      flex: 2,
                                      child: _ModernField(
                                        label: l10n.street_number,
                                        required: true,
                                        child: CustomFormField(
                                          context: context,
                                          controller: state.streetNumberController,
                                          inputFormat: [LengthLimitingTextInputFormatter(50)],
                                          keyboardType: TextInputType.text,
                                          hint: l10n.street_number,
                                          fillColor: AppColors.iconBGColor,
                                          textInputAction: TextInputAction.next,
                                          validator: AppStrings.streetNumberValString,
                                          isBorderVisible: false,
                                          border: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                14.height,
                                _ModernField(
                                  label: l10n.verify_phone_number,
                                  required: true,
                                  child: CustomFormField(
                                    context: context,
                                    controller: state.phoneController,
                                    inputFormat: [FilteringTextInputFormatter.digitsOnly],
                                    keyboardType: TextInputType.phone,
                                    hint: l10n.verify_phone_number,
                                    fillColor: AppColors.iconBGColor,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.mobileValString,
                                    isBorderVisible: false,
                                    border: 12,
                                  ),
                                ),
                              ],
                            ),
                            16.height,
                            _FormSectionCard(
                              icon: Icons.local_shipping_rounded,
                              iconColor: AppColors.orangeColor,
                              title: l10n.delivery_section,
                              children: [
                                _ModernField(
                                  label: l10n.delivery_location_description,
                                  child: CustomFormField(
                                    context: context,
                                    controller: state.deliveryDescriptionController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 4,
                                    hint: l10n.delivery_location_description,
                                    fillColor: AppColors.iconBGColor,
                                    textInputAction: TextInputAction.newline,
                                    validator: '',
                                    isBorderVisible: false,
                                    border: 12,
                                  ),
                                ),
                                16.height,
                                _WazeActionCard(
                                  label: l10n.waze_delivery_location,
                                  buttonText: l10n.open_waze_to_set_location,
                                  savedLabel: l10n.waze_location_saved,
                                  wazeUrl: state.wazeUrl,
                                  onTap: () => bloc.add(const VerifyClientDataEvent.openWazeEvent()),
                                ),
                                16.height,
                                _PhotoUploadCard(
                                  label: l10n.delivery_location_photo,
                                  cameraLabel: l10n.camera,
                                  galleryLabel: l10n.gallery,
                                  isUploading: state.isImageUploading,
                                  imageFile: state.deliveryLocationImageFile,
                                  imageUrl: state.deliveryLocationImageUrl.isNotEmpty
                                      ? '${AppUrlEndPoints.baseFileUrl}${state.deliveryLocationImageUrl}'
                                      : null,
                                  onCamera: state.isImageUploading
                                      ? null
                                      : () => bloc.add(VerifyClientDataEvent.pickDeliveryImageEvent(context: context, isFromCamera: true)),
                                  onGallery: state.isImageUploading
                                      ? null
                                      : () => bloc.add(VerifyClientDataEvent.pickDeliveryImageEvent(context: context, isFromCamera: false)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _BottomContinueBar(
                    label: l10n.continues,
                    isLoading: state.isLoading,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (formKey.currentState?.validate() ?? false) {
                              bloc.add(VerifyClientDataEvent.submitEvent(context: context));
                            }
                          },
                  ),
                ],
              ),
      );
    });
  }

  void _showCityPicker(
    BuildContext context,
    VerifyClientDataBloc bloc,
    VerifyClientDataState state,
    ValueNotifier<List<String>> listNotifier,
  ) {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radius_20)),
      ),
      builder: (context1) {
        return ValueListenableBuilder(
          valueListenable: listNotifier,
          builder: (context, content, child) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppConstants.padding_15,
                right: AppConstants.padding_15,
                top: AppConstants.padding_15,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppConstants.padding_15,
              ),
              child: SizedBox(
                height: getScreenHeight(context) * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.borderColor,
                          borderRadius: BorderRadius.circular(AppConstants.radius_20),
                        ),
                      ),
                    ),
                    16.height,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.city,
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_17,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context1),
                          icon: Icon(Icons.close_rounded, color: AppColors.greyColor),
                        ),
                      ],
                    ),
                    CustomFormField(
                      context: context,
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.lightGreyColor),
                      onChangeValue: (value) {
                        bloc.add(VerifyClientDataEvent.citySearchEvent(search: value));
                        listNotifier.value = state.filterList.where((city) => city.contains(value)).toList();
                      },
                      controller: state.citySearchController,
                      keyboardType: TextInputType.text,
                      hint: AppLocalizations.of(context)!.city,
                      fillColor: AppColors.iconBGColor,
                      textInputAction: TextInputAction.search,
                      validator: '',
                      autofocus: true,
                      cursorColor: AppColors.mainColor,
                      isBorderVisible: false,
                      border: 12,
                    ),
                    12.height,
                    Expanded(
                      child: ListView.separated(
                        itemCount: listNotifier.value.length,
                        separatorBuilder: (_, __) => 8.height,
                        itemBuilder: (context, index) {
                          final city = listNotifier.value[index];
                          final isSelected = city == state.selectCity;
                          return Material(
                            color: isSelected ? AppColors.lightMainColor : AppColors.iconBGColor,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                bloc.add(VerifyClientDataEvent.selectCityEvent(city: city));
                                Navigator.pop(context1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.padding_15,
                                  vertical: AppConstants.padding_15,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_city_rounded,
                                      size: 20,
                                      color: isSelected ? AppColors.mainColor : AppColors.lightGreyColor,
                                    ),
                                    12.width,
                                    Expanded(
                                      child: Text(
                                        city,
                                        style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_15,
                                          color: AppColors.blackColor,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    if (isSelected) Icon(Icons.check_circle_rounded, color: AppColors.mainColor, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  final String subtitle;

  const _HeaderBanner({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding_20),
      decoration: BoxDecoration(
        gradient: AppColors.appMainGradientColor,
        borderRadius: BorderRadius.circular(AppConstants.radius_15),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueColor.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.padding_11),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.verified_user_rounded, color: AppColors.whiteColor, size: 28),
          ),
          16.width,
          Expanded(
            child: Text(
              subtitle,
              style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_14,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<Widget> children;

  const _FormSectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding_15),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppConstants.radius_15),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.padding_8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radius_10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              12.width,
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          18.height,
          ...children,
        ],
      ),
    );
  }
}

class _ModernField extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;

  const _ModernField({
    required this.label,
    required this.child,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_13,
                color: AppColors.greyColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.redColor),
              ),
          ],
        ),
        8.height,
        child,
      ],
    );
  }
}

class _SelectField extends StatelessWidget {
  final String value;
  final String hint;
  final VoidCallback onTap;

  const _SelectField({
    required this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return Material(
      color: AppColors.iconBGColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_15),
          child: Row(
            children: [
              Icon(Icons.map_rounded, size: 20, color: hasValue ? AppColors.mainColor : AppColors.lightGreyColor),
              10.width,
              Expanded(
                child: Text(
                  hasValue ? value : hint,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_15,
                    color: hasValue ? AppColors.blackColor : AppColors.lightGreyColor,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.lightGreyColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _WazeActionCard extends StatelessWidget {
  final String label;
  final String buttonText;
  final String savedLabel;
  final String wazeUrl;
  final VoidCallback onTap;

  const _WazeActionCard({
    required this.label,
    required this.buttonText,
    required this.savedLabel,
    required this.wazeUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding_15),
      decoration: BoxDecoration(
        color: AppColors.iconBGColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.padding_8),
                decoration: BoxDecoration(
                  color: AppColors.blueColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radius_10),
                ),
                child: Icon(Icons.navigation_rounded, color: AppColors.blueColor, size: 22),
              ),
              12.width,
              Expanded(
                child: Text(
                  label,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          12.height,
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppConstants.radius_40),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.appMainGradientColor,
                borderRadius: BorderRadius.circular(AppConstants.radius_40),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.open_in_new_rounded, color: AppColors.whiteColor, size: 18),
                  8.width,
                  Text(
                    buttonText,
                    style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_14,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (wazeUrl.isNotEmpty) ...[
            12.height,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.padding_15,
                vertical: AppConstants.padding_11,
              ),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.mainColor.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.padding_6),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle_rounded, color: AppColors.mainColor, size: 22),
                  ),
                  12.width,
                  Expanded(
                    child: Text(
                      savedLabel,
                      style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_14,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhotoUploadCard extends StatelessWidget {
  final String label;
  final String cameraLabel;
  final String galleryLabel;
  final bool isUploading;
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback? onCamera;
  final VoidCallback? onGallery;

  const _PhotoUploadCard({
    required this.label,
    required this.cameraLabel,
    required this.galleryLabel,
    required this.isUploading,
    this.imageFile,
    this.imageUrl,
    this.onCamera,
    this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.rkRegularTextStyle(
            size: AppConstants.font_13,
            color: AppColors.greyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        8.height,
        if (hasImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: imageFile != null
                      ? Image.file(imageFile!, width: double.infinity, fit: BoxFit.fitWidth)
                      : CachedNetworkImage(imageUrl: imageUrl!, width: double.infinity, fit: BoxFit.fitWidth),
                ),
                if (isUploading)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.blackColor.withValues(alpha: 0.35),
                      child: Center(child: CircularProgressIndicator(color: AppColors.whiteColor)),
                    ),
                  ),
              ],
            ),
          )
        else
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.iconBGColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor, width: 1.5),
            ),
            child: isUploading
                ? Center(child: CircularProgressIndicator(color: AppColors.mainColor))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 36, color: AppColors.lightGreyColor),
                      8.height,
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.lightGreyColor),
                      ),
                    ],
                  ),
          ),
        if (!isUploading) ...[
          12.height,
          Row(
            children: [
              Expanded(
                child: _MediaChip(icon: Icons.photo_camera_rounded, label: cameraLabel, onTap: onCamera),
              ),
              10.width,
              Expanded(
                child: _MediaChip(icon: Icons.photo_library_rounded, label: galleryLabel, onTap: onGallery),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MediaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MediaChip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightBorderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: AppColors.blueColor),
              8.width,
              Text(
                label,
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomContinueBar extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _BottomContinueBar({
    required this.label,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppConstants.radius_40),
          child: Ink(
            decoration: BoxDecoration(
              gradient: onPressed == null ? AppColors.disableGradientColor : AppColors.appMainGradientColor,
              borderRadius: BorderRadius.circular(AppConstants.radius_40),
            ),
            height: 52,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.whiteColor),
                    )
                  : Text(
                      label,
                      style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
