import 'dart:io';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../bloc/client_form_details/client_form_details_bloc.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../widget/form_data_screen_shimmer_widget.dart';

class ClientFormDetailsRoute {
  static Widget get route => const ClientFormDetailsScreen();
}

class ClientFormDetailsScreen extends StatelessWidget {
  const ClientFormDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
        create: (context) => ClientFormDetailsBloc()
          ..add(ClientFormDetailsEvent.getProfileDetailsEvent(context: context))
          ..add(ClientFormDetailsEvent.getBusinessTypeEvent(context: context))
          ..add(ClientFormDetailsEvent.getBankNameEvent(context: context))
          ..add(ClientFormDetailsEvent.getPdfDataEvent(
              context: context,
              pdfData: args?[AppStrings.privacyPolicyPdfString] ?? '',
              termsConditionReqModel: args?[AppStrings.termsConditionParamString] ?? const TermsConditionReqModel())),
        child: const ClientFormDetailsScreenWidget());
  }
}

class ClientFormDetailsScreenWidget extends StatefulWidget {
  const ClientFormDetailsScreenWidget({super.key});

  @override
  State<ClientFormDetailsScreenWidget> createState() => _ClientFormDetailsScreenWidgetState();
}

class _ClientFormDetailsScreenWidgetState extends State<ClientFormDetailsScreenWidget> {
  ui.Image? image;
  bool isImage = false;
  PdfFormFieldFocusChangeDetails? details;
  final _formKey = GlobalKey<FormState>();
  String ownerName = '';

  @override
  Widget build(BuildContext context) {
    ClientFormDetailsBloc bloc = context.read<ClientFormDetailsBloc>();
    return BlocBuilder<ClientFormDetailsBloc, ClientFormDetailsState>(builder: (context, state) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
              surfaceTintColor: AppColors.whiteColor,
              leading: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: AppColors.blackColor)),
              title: Align(
                alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.client_info,
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
              ),
              backgroundColor: AppColors.whiteColor,
              titleSpacing: 0,
              elevation: 0),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: state.isShimmering
                  ? const FormDataScreenShimmerWidget()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.1),
                      child: Form(
                        key: _formKey,
                        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          10.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.my_agent_code, star: ''),
                          CustomFormField(
                              inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                              context: context,
                              controller: state.agentCodeController,
                              keyboardType: TextInputType.number,
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              maxLimits: 6,
                              validator: AppStrings.agentCodeString),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.type_of_business, star: ''),
                          CommonDropDownButton(
                              items: state.businessTypeList.map((business) {
                                return DropdownMenuItem<String>(value: business.businessTypeName ?? '', child: Text(business.businessTypeName ?? ''));
                              }).toList(),
                              onChanged: (newBusiness) {
                                bloc.add(ClientFormDetailsEvent.selectBusinessTypeEvent(business: newBusiness ?? '', haveMultiple: true));
                              },
                              value: state.business),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.name_of_bank, star: ''),
                          CommonDropDownButton(
                              items: state.bankList.map((element) {
                                return DropdownMenuItem<String>(value: element.bankName ?? '', child: Text(element.bankName ?? ''));
                              }).toList(),
                              onChanged: (newBankName) {
                                final selectedBank = state.bankList.firstWhere((bank) => bank.bankName == newBankName);
                                bloc.add(
                                    ClientFormDetailsEvent.selectBankEvent(bankName: selectedBank.bankName ?? '', bankId: selectedBank.id ?? ''));
                              },
                              value: state.bankName),
                          CustomContainerWidget(name: AppLocalizations.of(context)!.branch_number, star: ''),
                          CustomFormField(
                              inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                              context: context,
                              controller: state.branchController,
                              keyboardType: TextInputType.number,
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              validator: AppStrings.branchValString),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.account_number, star: ''),
                          CustomFormField(
                              context: context,
                              inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                              controller: state.accountNumberController,
                              keyboardType: TextInputType.number,
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.done,
                              validator: ''),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.owner1_full_name, star: ''),
                          CustomFormField(
                              context: context,
                              controller: state.owner1NameController,
                              keyboardType: TextInputType.text,
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              validator: ''),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.owner_1_israel_id, star: ''),
                          CustomFormField(
                              context: context,
                              controller: state.owner1israelIdController,
                              keyboardType: TextInputType.number,
                              inputFormat: [FilteringTextInputFormatter.digitsOnly],
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              validator: ''),
                          7.height,
                          Column(children: [
                            CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_1_full_name, star: ''),
                            CustomFormField(
                                context: context,
                                controller: state.guarantee1NameController,
                                keyboardType: TextInputType.text,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: ''),
                            7.height,
                            CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_1_israel_id, star: ''),
                            CustomFormField(
                                context: context,
                                controller: state.guarantee1idController,
                                inputFormat: [FilteringTextInputFormatter.digitsOnly],
                                keyboardType: TextInputType.number,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: ''),
                            7.height,
                            CustomContainerWidget(
                                name: state.language == AppStrings.hebrewString
                                    ? '${AppLocalizations.of(context)!.guarantee_1_address}${1}'
                                    : AppLocalizations.of(context)!.guarantee_1_address,
                                star: ''),
                            CustomFormField(
                                context: context,
                                controller: state.guarantee1addressController,
                                keyboardType: TextInputType.text,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: ''),
                            7.height,
                            CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_1_phone_number, star: ''),
                            CustomFormField(
                                inputFormat: [LengthLimitingTextInputFormatter(10)],
                                context: context,
                                controller: state.guarantee1PhoneController,
                                keyboardType: TextInputType.number,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: ''),
                          ]),
                          CustomContainerWidget(name: AppLocalizations.of(context)!.owner2_full_name, star: ''),
                          CustomFormField(
                              context: context,
                              controller: state.owner2NameController,
                              keyboardType: TextInputType.text,
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              validator: '',
                              onChangeValue: (t) {
                                ownerName = t;
                              }),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.owner_2_israel_id, star: ''),
                          CustomFormField(
                              context: context,
                              controller: state.owner2israelIdController,
                              keyboardType: TextInputType.number,
                              inputFormat: [FilteringTextInputFormatter.digitsOnly],
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              validator: ''),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_2_full_name, star: ''),
                          CustomFormField(
                              context: context,
                              controller: state.guarantee2NameController,
                              keyboardType: TextInputType.text,
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              validator: ''),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_2_israel_id, star: ''),
                          CustomFormField(
                              context: context,
                              controller: state.guarantee2idController,
                              keyboardType: TextInputType.number,
                              inputFormat: [FilteringTextInputFormatter.digitsOnly],
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              validator: ''),
                          7.height,
                          CustomContainerWidget(
                              name: state.language == AppStrings.hebrewString
                                  ? '${AppLocalizations.of(context)!.guarantee_2_address}${2}'
                                  : AppLocalizations.of(context)!.guarantee_2_address,
                              star: ''),
                          CustomFormField(
                              context: context,
                              controller: state.guarantee2addressController,
                              keyboardType: TextInputType.text,
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              validator: ''),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_2_phone_number, star: ''),
                          CustomFormField(
                              inputFormat: [LengthLimitingTextInputFormatter(10)],
                              context: context,
                              controller: state.guarantee2PhoneController,
                              keyboardType: TextInputType.number,
                              hint: "",
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.done,
                              validator: ''),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.owner1_sign, star: ''),
                          Row(children: [
                            state.owner1Signature.isEmpty
                                ? const IgnorePointer()
                                : Stack(clipBehavior: Clip.none, children: [
                                    Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(AppConstants.radius_8),
                                            border: Border.all(color: AppColors.borderColor)),
                                        child: state.owner1SignatureLocal.isNotEmpty
                                            ? Image.file(File(state.owner1SignatureLocal))
                                            : Container(
                                                height: 120,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(AppConstants.radius_8),
                                                    border: Border.all(color: AppColors.borderColor)),
                                                child: CachedNetworkImage(
                                                    height: 100,
                                                    width: 100,
                                                    imageUrl: "${AppUrlEndPoints.baseFileUrl}${state.owner1Signature}",
                                                    fit: BoxFit.scaleDown,
                                                    alignment: Alignment.center,
                                                    placeholder: (context, url) =>
                                                        Center(child: CupertinoActivityIndicator(color: AppColors.blackColor)),
                                                    errorWidget: (context, url, error) {
                                                      return Center(
                                                        child: Text(AppStrings.failedToLoadString,
                                                            style: AppStyles.rkRegularTextStyle(
                                                                size: AppConstants.smallFont, color: AppColors.textColor)),
                                                      );
                                                    }),
                                              )),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: GestureDetector(
                                          onTap: () {
                                            bloc.add(ClientFormDetailsEvent.deleteFileEvent(
                                                context: context, fieldName: AppStrings.owner1SignatureString));
                                          },
                                          child: Icon(Icons.highlight_remove, color: AppColors.redColor, size: 24)),
                                    ),
                                  ]),
                            7.width,
                            CustomButtonWidget(
                                fontSize: AppConstants.font_13,
                                buttonText: AppLocalizations.of(context)!.owner1_sign.toCapitalized(),
                                height: 45,
                                bGColor: AppColors.whiteColor,
                                width: getScreenWidth(context) / 2.2,
                                onPressed: () {
                                  bloc.add(ClientFormDetailsEvent.signatureEvent(
                                      context: context,
                                      fieldName: AppStrings.owner1SignatureString,
                                      fieldNameForSign: AppLocalizations.of(context)!.owner1_sign));
                                },
                                fontColors: AppColors.whiteColor),
                          ]),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.owner2_sign, star: ''),
                          Row(children: [
                            state.owner2Signature.isEmpty
                                ? const IgnorePointer()
                                : Stack(clipBehavior: Clip.none, children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppConstants.radius_8),
                                          border: Border.all(color: AppColors.borderColor)),
                                      child: state.owner2SignatureLocal.isNotEmpty
                                          ? Image.file(File(state.owner2SignatureLocal))
                                          : Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(AppConstants.radius_8),
                                                  border: Border.all(color: AppColors.borderColor)),
                                              child: CachedNetworkImage(
                                                  height: 100,
                                                  width: 100,
                                                  imageUrl: "${AppUrlEndPoints.baseFileUrl}${state.owner2Signature}",
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                  placeholder: (context, url) =>
                                                      Center(child: CupertinoActivityIndicator(color: AppColors.blackColor)),
                                                  errorWidget: (context, url, error) {
                                                    return Center(
                                                      child: Text(AppStrings.failedToLoadString,
                                                          style:
                                                              AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor)),
                                                    );
                                                  }),
                                            ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: GestureDetector(
                                          onTap: () {
                                            bloc.add(ClientFormDetailsEvent.deleteFileEvent(
                                                context: context, fieldName: AppStrings.owner2SignatureString));
                                          },
                                          child: Icon(Icons.highlight_remove, color: AppColors.redColor, size: 24)),
                                    ),
                                  ]),
                            7.width,
                            CustomButtonWidget(
                                fontSize: AppConstants.font_13,
                                buttonText: AppLocalizations.of(context)!.owner2_sign.toCapitalized(),
                                height: 45,
                                bGColor: AppColors.whiteColor,
                                width: getScreenWidth(context) / 2.2,
                                onPressed: () {
                                  bloc.add(ClientFormDetailsEvent.signatureEvent(
                                      context: context,
                                      fieldName: AppStrings.owner2SignatureString,
                                      fieldNameForSign: AppLocalizations.of(context)!.owner2_sign));
                                },
                                fontColors: AppColors.whiteColor),
                          ]),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee1_sign, star: ''),
                          Row(children: [
                            state.guarantee1Signature.isEmpty
                                ? const IgnorePointer()
                                : Stack(clipBehavior: Clip.none, children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppConstants.radius_8),
                                          border: Border.all(color: AppColors.borderColor)),
                                      child: state.guarantee1SignatureLocal.isNotEmpty
                                          ? Image.file(File(state.guarantee1SignatureLocal))
                                          : Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(AppConstants.radius_8),
                                                  border: Border.all(color: AppColors.borderColor)),
                                              child: CachedNetworkImage(
                                                  height: 100,
                                                  width: 100,
                                                  imageUrl: "${AppUrlEndPoints.baseFileUrl}${state.guarantee1Signature}",
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                  placeholder: (context, url) =>
                                                      Center(child: CupertinoActivityIndicator(color: AppColors.blackColor)),
                                                  errorWidget: (context, url, error) {
                                                    return Center(
                                                      child: Text(AppStrings.failedToLoadString,
                                                          style:
                                                              AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor)),
                                                    );
                                                  }),
                                            ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: GestureDetector(
                                          onTap: () {
                                            bloc.add(ClientFormDetailsEvent.deleteFileEvent(
                                                context: context, fieldName: AppStrings.guarantee1SignatureString));
                                          },
                                          child: Icon(Icons.highlight_remove, color: AppColors.redColor, size: 24)),
                                    ),
                                  ]),
                            7.width,
                            CustomButtonWidget(
                                fontSize: AppConstants.font_13,
                                buttonText: AppLocalizations.of(context)!.guarantee1_sign.toCapitalized(),
                                height: 45,
                                bGColor: AppColors.whiteColor,
                                width: getScreenWidth(context) / 2.2,
                                onPressed: () {
                                  bloc.add(ClientFormDetailsEvent.signatureEvent(
                                      context: context,
                                      fieldName: AppStrings.guarantee1SignatureString,
                                      fieldNameForSign: AppLocalizations.of(context)!.guarantee1_sign));
                                },
                                fontColors: AppColors.whiteColor),
                          ]),
                          7.height,
                          CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee2_sign, star: ''),
                          Row(children: [
                            state.guarantee2Signature.isEmpty
                                ? const IgnorePointer()
                                : Stack(clipBehavior: Clip.none, children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppConstants.radius_8),
                                          border: Border.all(color: AppColors.borderColor)),
                                      child: state.guarantee2SignatureLocal.isNotEmpty
                                          ? Image.file(File(state.guarantee2SignatureLocal))
                                          : Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(AppConstants.radius_8),
                                                  border: Border.all(color: AppColors.borderColor)),
                                              child: CachedNetworkImage(
                                                  height: 100,
                                                  width: 100,
                                                  imageUrl: "${AppUrlEndPoints.baseFileUrl}${state.guarantee2Signature}",
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                  placeholder: (context, url) =>
                                                      Center(child: CupertinoActivityIndicator(color: AppColors.blackColor)),
                                                  errorWidget: (context, url, error) {
                                                    return Center(
                                                      child: Text(AppStrings.failedToLoadString,
                                                          style:
                                                              AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor)),
                                                    );
                                                  }),
                                            ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: GestureDetector(
                                          onTap: () {
                                            bloc.add(ClientFormDetailsEvent.deleteFileEvent(
                                                context: context, fieldName: AppStrings.guarantee2SignatureString));
                                          },
                                          child: Icon(Icons.highlight_remove, color: AppColors.redColor, size: 24)),
                                    ),
                                  ]),
                            7.width,
                            CustomButtonWidget(
                                fontSize: AppConstants.font_13,
                                buttonText: AppLocalizations.of(context)!.guarantee2_sign.toCapitalized(),
                                height: 45,
                                bGColor: AppColors.whiteColor,
                                width: getScreenWidth(context) / 2.2,
                                onPressed: () {
                                  bloc.add(ClientFormDetailsEvent.signatureEvent(
                                      context: context,
                                      fieldName: AppStrings.guarantee2SignatureString,
                                      fieldNameForSign: AppLocalizations.of(context)!.guarantee2_sign));
                                },
                                fontColors: AppColors.whiteColor),
                          ]),
                          40.height,
                          CustomButtonWidget(
                              buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
                              bGColor: AppColors.mainColor,
                              isLoading: state.isLoading,
                              onPressed: () {
                                if (state.business != AppLocalizations.of(context)!.type_of_business) {
                                  bool success = validation(state, context);
                                  if (success) {
                                    bloc.add(ClientFormDetailsEvent.updateClientDataEvent(context: context));
                                  }
                                } else {
                                  CustomSnackBar.showSnackBar(
                                      context: context, title: AppLocalizations.of(context)!.select_business_type, type: SnackBarType.failure);
                                }
                              },
                              fontColors: AppColors.whiteColor),
                          20.height
                        ]),
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }

  bool validation(ClientFormDetailsState state, BuildContext context) {
    if (state.haveMultiple) {
      if (isValidIsraeliID(state.guarantee1idController.text.toString().trim())) {
        return true;
      } else {
        CustomSnackBar.showSnackBar(
            context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_guarantee1, type: SnackBarType.failure);
        return false;
      }
    } else {
      return true;
    }
  }
}
