import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/product_return_info/product_return_info_bloc.dart';
import '/ui/widget/file_selection_option_widget.dart';
import '/ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';
import '../widget/product_return_info_shimmer_widget.dart';

class ProductReturnInfoRoute {
  static Widget get route => const ProductReturnInfoScreen();
}

class ProductReturnInfoScreen extends StatelessWidget {
  const ProductReturnInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => ProductReturnInfoBloc()..add(ProductReturnInfoEvent.getArgumentEvent(arguments: args ?? {}, context: context)),
      child: const ReturnListWidget(),
    );
  }
}

class ReturnListWidget extends StatelessWidget {
  const ReturnListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductReturnInfoBloc, ProductReturnInfoState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.product_return_info,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () {
              Navigator.pop(context);
            },
            trailingWidget: state.mainIndex != -1
                ? InkWell(
                    onTap: () {
                      deleteProductDialog(context: context, returnProductId: state.returnProductId);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                      decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(AppConstants.radius_5)),
                      child: Text(AppLocalizations.of(context)!.delete, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor)),
                    ),
                  )
                : 0.width,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_15),
              child: state.isShimmer
                  ? const ProductReturnShimmerWidget()
                  : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
                      Card(
                        elevation: 1.5,
                        margin: EdgeInsets.zero,
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.padding_8),
                          child: Row(children: [
                            state.productImg != ''
                                ? Image.network(state.productImg, width: 100, height: 100, fit: BoxFit.contain, loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: SizedBox(
                                          width: AppConstants.containerHeight_80,
                                          height: AppConstants.containerHeight_80,
                                          child: CupertinoActivityIndicator(color: AppColors.blackColor),
                                        ),
                                      );
                                    }
                                  }, errorBuilder: (context, error, stackTrace) {
                                    return Container(width: 100, height: 100, color: AppColors.whiteColor, alignment: Alignment.center, child: Image.asset(AppImagePath.imageNotAvailable5));
                                  })
                                : Image.asset(
                                    AppImagePath.imageNotAvailable5,
                                    fit: BoxFit.cover,
                                    width: AppConstants.containerHeight_80,
                                    height: AppConstants.containerHeight_80,
                                  ),
                            10.width,
                            Expanded(
                              child: Text(state.productName, overflow: TextOverflow.ellipsis, maxLines: 4, style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont)),
                            )
                          ]),
                        ),
                      ),
                      8.height,
                      Text(AppLocalizations.of(context)!.no_of_unit_for_return, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont)),
                      5.height,
                      Row(children: [
                        Card(
                          margin: EdgeInsets.zero,
                          color: AppColors.whiteColor,
                          child: Padding(
                            padding: const EdgeInsets.all(AppConstants.padding_11),
                            child: Row(children: [
                              GestureDetector(
                                onTap: () {
                                  context.read<ProductReturnInfoBloc>().add(ProductReturnInfoEvent.productIncrementEvent(productQuantity: state.productQty, context: context));
                                },
                                child: Container(
                                  width: AppConstants.padding_30,
                                  height: AppConstants.padding_30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppConstants.radius_2),
                                    border: Border.all(color: AppColors.mainColor),
                                    gradient: AppColors.appMainGradientColor,
                                  ),
                                  child: Icon(Icons.add, size: 18, color: AppColors.whiteColor),
                                ),
                              ),
                              15.width,
                              Text(state.productQty.toString(), style: AppStyles.rkBoldTextStyle(color: AppColors.blackColor, size: AppConstants.smallFont)),
                              15.width,
                              GestureDetector(
                                onTap: () {
                                  context.read<ProductReturnInfoBloc>().add(ProductReturnInfoEvent.productDecrementEvent(productQuantity: state.productQty, context: context));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: AppConstants.padding_30,
                                  height: AppConstants.padding_30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppConstants.radius_3),
                                    border: Border.all(color: AppColors.mainColor),
                                    gradient: AppColors.appMainGradientColor,
                                  ),
                                  child: Icon(Icons.remove, size: 18, color: AppColors.whiteColor),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        Expanded(child: Container())
                      ]),
                      15.height,
                      Text(AppLocalizations.of(context)!.why_return_product, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont)),
                      5.height,
                      state.radioList.isNotEmpty ? radioList(state) : 0.height,
                      15.height,
                      Text(AppLocalizations.of(context)!.add_proof_img, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont)),
                      8.height,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                if (state.proofFile != null && await state.proofFile.exists() || state.proofFile.path.contains("https")) {
                                  uploadProofBottomSheet(context: context, file: state.proofFile, index: 1, language: state.language);
                                  return;
                                }
                                cameraEvent(context: context, index: 1);
                              },
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(color: AppColors.whiteColor),
                                alignment: Alignment.center,
                                child: state.proofFile.path.contains("https")
                                    ? Image.network(state.proofFile.path, loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: SizedBox(
                                              width: AppConstants.containerHeight_80,
                                              height: AppConstants.containerHeight_80,
                                              child: CupertinoActivityIndicator(color: AppColors.blackColor),
                                            ),
                                          );
                                        }
                                      }, errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: AppColors.whiteColor,
                                          alignment: Alignment.center,
                                          child: Image.asset(AppImagePath.imageNotAvailable5),
                                        );
                                      })
                                    : state.proofFile.existsSync()
                                        ? Image.file(state.proofFile, fit: BoxFit.cover, height: 120, width: 120)
                                        : const Icon(Icons.add, size: 60),
                              ),
                            ),
                            8.width,
                            InkWell(
                              onTap: () async {
                                if (state.proofFile1 != null && await state.proofFile1.exists() || state.proofFile1.path.contains("https")) {
                                  uploadProofBottomSheet(
                                    context: context,
                                    file: state.proofFile1,
                                    index: 2,
                                    language: state.language,
                                  );
                                  return;
                                }
                                cameraEvent(context: context, index: 2);
                              },
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(color: AppColors.whiteColor),
                                alignment: Alignment.center,
                                child: state.proofFile1.path.contains("https")
                                    ? Image.network(state.proofFile1.path, loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: SizedBox(
                                              width: AppConstants.containerHeight_80,
                                              height: AppConstants.containerHeight_80,
                                              child: CupertinoActivityIndicator(color: AppColors.blackColor),
                                            ),
                                          );
                                        }
                                      }, errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: AppColors.whiteColor,
                                          alignment: Alignment.center,
                                          child: Image.asset(AppImagePath.imageNotAvailable5),
                                        );
                                      })
                                    : state.proofFile1.existsSync()
                                        ? Image.file(state.proofFile1, fit: BoxFit.cover, height: 120, width: 120)
                                        : const Icon(Icons.add, size: 60),
                              ),
                            ),
                            8.width,
                            InkWell(
                              onTap: () async {
                                if (state.proofFile2 != null && await state.proofFile2.exists() || state.proofFile2.path.contains("https")) {
                                  uploadProofBottomSheet(
                                    context: context,
                                    file: state.proofFile2,
                                    index: 3,
                                    language: state.language,
                                  );
                                  return;
                                }
                                cameraEvent(context: context, index: 3);
                              },
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(color: AppColors.whiteColor),
                                alignment: Alignment.center,
                                child: state.proofFile2.path.contains("https")
                                    ? Image.network(state.proofFile2.path, loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: SizedBox(
                                              width: AppConstants.containerHeight_80,
                                              height: AppConstants.containerHeight_80,
                                              child: CupertinoActivityIndicator(color: AppColors.blackColor),
                                            ),
                                          );
                                        }
                                      }, errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: AppColors.whiteColor,
                                          alignment: Alignment.center,
                                          child: Image.asset(AppImagePath.imageNotAvailable5),
                                        );
                                      })
                                    : state.proofFile2.existsSync()
                                        ? Image.file(state.proofFile2, fit: BoxFit.cover, height: 120, width: 120)
                                        : const Icon(Icons.add, size: 60),
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.height,
                      Text(AppLocalizations.of(context)!.add_notes, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont)),
                      5.height,
                      CustomFormField(
                        context: context,
                        fillColor: AppColors.whiteColor,
                        validator: '',
                        inputFormat: [LengthLimitingTextInputFormatter(150)],
                        controller: state.addNoteController,
                        keyboardType: TextInputType.text,
                        hint: '',
                        maxLines: 4,
                        isBorderVisible: false,
                        textInputAction: TextInputAction.done,
                        contentPaddingTop: AppConstants.padding_10,
                      ),
                      20.height,
                      CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.save,
                        bGColor: AppColors.mainColor,
                        onPressed: () {
                          context.read<ProductReturnInfoBloc>().add(ProductReturnInfoEvent.navigateReturnEvent(context: context));
                        },
                        fontColors: AppColors.whiteColor,
                      ),
                    ]),
            ),
          ),
        ),
      );
    });
  }

  radioList(ProductReturnInfoState state) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return radioWidget(state.radioList[index].id, state.radioList[index].text, context, state.selectedRadioTile);
        },
        itemCount: state.radioList.length);
  }

  void deleteProductDialog({required BuildContext context, required String returnProductId}) {
    showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
        value: context.read<ProductReturnInfoBloc>(),
        child: BlocBuilder<ProductReturnInfoBloc, ProductReturnInfoState>(builder: (c, state) {
          ProductReturnInfoBloc bloc = context.read<ProductReturnInfoBloc>();
          return CommonAlertDialog(
              directionality: state.language,
              title: AppLocalizations.of(context)!.delete,
              subTitle: AppLocalizations.of(context)!.are_you_sure,
              positiveTitle: AppLocalizations.of(context)!.yes,
              negativeTitle: AppLocalizations.of(context)!.no,
              negativeOnTap: () {
                Navigator.pop(c);
              },
              positiveOnTap: () async {
                if (state.returnProductList.length > 1) {
                  bloc.add(ProductReturnInfoEvent.removeProductEvent(context: context, returnProductId: returnProductId));
                } else {
                  bloc.add(ProductReturnInfoEvent.deleteEvent(context: context));
                  Navigator.pop(c);
                  Navigator.pop(context);
                }
              });
        }),
      ),
    );
  }

  Widget radioWidget(int value, String text, BuildContext context, int radioValue) {
    return Card(
      margin: const EdgeInsets.only(top: AppConstants.padding_10, bottom: AppConstants.padding_5),
      color: AppColors.whiteColor,
      child: Row(children: [
        Radio(
            value: value,
            fillColor: WidgetStateColor.resolveWith((states) => AppColors.mainColor),
            groupValue: radioValue,
            onChanged: (val) {
              context.read<ProductReturnInfoBloc>().add(ProductReturnInfoEvent.radioButtonEvent(selectRadioTile: val!, reason: text));
            }),
        5.width,
        Text(text, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor)),
      ]),
    );
  }

  uploadProofBottomSheet({required BuildContext context, required File file, required int index, required String language}) {
    return showModalBottomSheet(
        context: context,
        builder: (context1) => Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(AppConstants.radius_20), topLeft: Radius.circular(AppConstants.radius_20)),
              ),
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_30, vertical: AppConstants.padding_20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  AppLocalizations.of(context)!.upload_photo,
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.w600),
                ),
                30.height,
                FileSelectionOptionWidget(
                    title: AppLocalizations.of(context)!.camera,
                    icon: Icons.camera_alt_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      cameraEvent(context: context, index: index);
                    }),
                FileSelectionOptionWidget(
                    title: AppLocalizations.of(context)!.delete,
                    icon: Icons.delete,
                    lastItem: true,
                    iconColor: Colors.red,
                    onTap: () async {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context2) => CommonAlertDialog(
                            directionality: language,
                            title: AppLocalizations.of(context)!.remove,
                            subTitle: AppLocalizations.of(context)!.are_you_sure,
                            positiveTitle: AppLocalizations.of(context)!.yes,
                            negativeTitle: AppLocalizations.of(context)!.no,
                            negativeOnTap: () {
                              Navigator.pop(context2);
                            },
                            positiveOnTap: () async {
                              context.read<ProductReturnInfoBloc>().add(ProductReturnInfoEvent.deleteFileEvent(context: context, index: index));
                              Navigator.pop(context2);
                            }),
                      );
                    })
              ]),
            ),
        backgroundColor: Colors.transparent);
  }

  cameraEvent({required BuildContext context, required int index}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (Platform.isAndroid) {
      if (!statuses[Permission.camera]!.isGranted) {
        Navigator.pop(context);
        CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.camera_permission, type: SnackBarType.failure);
        return;
      }
    } else if (Platform.isIOS) {}
    context.read<ProductReturnInfoBloc>().add(ProductReturnInfoEvent.pickDocumentEvent(context: context, isFromCamera: true, value: index));
  }
}
