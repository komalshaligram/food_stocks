import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/product_return_info/product_return_info_bloc.dart';
import '/ui/widget/file_selection_option_widget.dart';
import '/ui/widget/sized_box_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
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
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => ProductReturnInfoBloc()
        ..add(ProductReturnInfoEvent.getArgumentEvent(
            arguments: args ?? {}, context: context)),
      child: const ReturnListWidget(),
    );
  }
}

class ReturnListWidget extends StatelessWidget {
  const ReturnListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductReturnInfoBloc, ProductReturnInfoState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.product_return_info,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () => Navigator.pop(context),
            trailingWidget: state.mainIndex != -1
                ? _deleteButton(context, state)
                : const SizedBox(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding_15),
            child: state.isShimmer
                ? const ProductReturnShimmerWidget()
                : SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _productCard(state),
                          10.height,
                          _quantitySection(context, state),
                          15.height,
                          _radioSection(state),
                          15.height,
                          _imageSection(context, state),
                          15.height,
                          _noteField(context, state),
                          20.height,
                          _saveButton(context),
                        ]),
                  ),
          ),
        ),
      );
    });
  }

  Widget _deleteButton(BuildContext context, ProductReturnInfoState state) {
    return InkWell(
      onTap: () {
        deleteProductDialog(
            context: context, returnProductId: state.returnProductId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppConstants.padding_3,
            horizontal: AppConstants.padding_8),
        decoration: BoxDecoration(
            color: AppColors.redColor,
            borderRadius: BorderRadius.circular(AppConstants.radius_5)),
        child: Text(AppLocalizations.of(context)!.delete,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.whiteColor)),
      ),
    );
  }

  void deleteProductDialog(
      {required BuildContext context, required String returnProductId}) {
    showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
        value: context.read<ProductReturnInfoBloc>(),
        child: BlocBuilder<ProductReturnInfoBloc, ProductReturnInfoState>(
            builder: (c, state) {
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
                  bloc.add(ProductReturnInfoEvent.removeProductEvent(
                      context: context, returnProductId: returnProductId));
                } else {
                  bloc.add(
                      ProductReturnInfoEvent.deleteEvent(context: context));
                  Navigator.pop(c);
                  Navigator.pop(context);
                }
              });
        }),
      ),
    );
  }

  Widget _productCard(ProductReturnInfoState state) {
    return Card(
      color: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding_8),
        child: Row(children: [
          _productImage(state.productImg),
          10.width,
          Expanded(
              child: Text(state.productName,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.mediumFont))),
        ]),
      ),
    );
  }

  Widget _productImage(String url) {
    if (url.isEmpty) {
      return Image.asset(AppImagePath.imageNotAvailable5,
          width: AppConstants.containerHeight_80,
          height: AppConstants.containerHeight_80,
          fit: BoxFit.cover);
    }
    return Image.network(
      url,
      width: AppConstants.containerHeight_80,
      height: AppConstants.containerHeight_80,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Image.asset(AppImagePath.imageNotAvailable5,
          width: AppConstants.containerHeight_80,
          height: AppConstants.containerHeight_80),
    );
  }

  Widget _quantitySection(BuildContext context, ProductReturnInfoState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      state.scaleType == 'מארזים'
          ? Text(AppLocalizations.of(context)!.no_of_unit_for_return,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont))
          : Text(AppLocalizations.of(context)!.no_of_kg_for_return,
              style:
                  AppStyles.rkRegularTextStyle(size: AppConstants.smallFont)),
      5.height,
      Row(children: [
        Card(
          color: AppColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding_10),
            child: Row(children: [
              _qtyButton(
                icon: Icons.add,
                onTap: () => context.read<ProductReturnInfoBloc>().add(
                    ProductReturnInfoEvent.productIncrementEvent(
                        productQuantity: state.productQty, context: context)),
              ),
              15.width,
              Text(state.productQty.toString(),
                  style: AppStyles.rkBoldTextStyle(
                      color: AppColors.blackColor,
                      size: AppConstants.smallFont)),
              15.width,
              _qtyButton(
                icon: Icons.remove,
                onTap: () => context.read<ProductReturnInfoBloc>().add(
                    ProductReturnInfoEvent.productDecrementEvent(
                        productQuantity: state.productQty, context: context)),
              )
            ]),
          ),
        ),
      ])
    ]);
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(4),
            gradient: AppColors.appMainGradientColor),
        child: Icon(icon, color: AppColors.whiteColor, size: 18),
      ),
    );
  }

  Widget _radioSection(ProductReturnInfoState state) {
    if (state.radioList.isEmpty) return const SizedBox();

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.radioList.length,
        itemBuilder: (context, index) {
          final item = state.radioList[index];
          return Container(
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppConstants.radius_10))),
            margin: const EdgeInsets.only(
                top: AppConstants.padding_10, bottom: AppConstants.padding_5),
            child: Row(children: [
              Radio(
                value: item.id,
                fillColor: WidgetStateColor.resolveWith(
                    (states) => AppColors.mainColor),
                groupValue: state.selectedRadioTile,
                onChanged: (val) {
                  context.read<ProductReturnInfoBloc>().add(
                      ProductReturnInfoEvent.radioButtonEvent(
                          selectRadioTile: val!, reason: item.text));
                },
              ),
              5.width,
              Text(item.text,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_14, color: AppColors.blackColor)),
            ]),
          );
        });
  }

  Widget _imageSection(BuildContext context, ProductReturnInfoState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context)!.add_proof_img,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont)),
      10.height,
      Row(children: [
        _imageTile(context, state.proofFile, 1, state),
        8.width,
        _imageTile(context, state.proofFile1, 2, state),
        8.width,
        _imageTile(context, state.proofFile2, 3, state),
      ])
    ]);
  }

  Widget _imageTile(BuildContext context, File file, int index,
      ProductReturnInfoState state) {
    final isNetwork = file.path.contains("http");
    final exists = file.existsSync();

    return InkWell(
      onTap: () {
        if (exists || isNetwork) {
          uploadProofBottomSheet(
              context: context,
              file: file,
              index: index,
              language: state.language);
        } else {
          cameraEvent(context: context, index: index);
        }
      },
      child: Container(
          height: 120,
          width: 120,
          color: AppColors.whiteColor,
          child: isNetwork
              ? Image.network(file.path, fit: BoxFit.cover)
              : exists
                  ? Image.file(file, fit: BoxFit.cover)
                  : const Icon(Icons.add, size: 50)),
    );
  }

  uploadProofBottomSheet(
      {required BuildContext context,
      required File file,
      required int index,
      required String language}) {
    return showModalBottomSheet(
        context: context,
        builder: (context1) => Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(AppConstants.radius_20),
                    topLeft: Radius.circular(AppConstants.radius_20)),
              ),
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.padding_30,
                  vertical: AppConstants.padding_20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  AppLocalizations.of(context)!.upload_photo,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.normalFont,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600),
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
                    iconColor: AppColors.redColor,
                    onTap: () async {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context2) => CommonAlertDialog(
                            directionality: language,
                            title: AppLocalizations.of(context)!.remove,
                            subTitle:
                                AppLocalizations.of(context)!.are_you_sure,
                            positiveTitle: AppLocalizations.of(context)!.yes,
                            negativeTitle: AppLocalizations.of(context)!.no,
                            negativeOnTap: () {
                              Navigator.pop(context2);
                            },
                            positiveOnTap: () async {
                              context.read<ProductReturnInfoBloc>().add(
                                  ProductReturnInfoEvent.deleteFileEvent(
                                      context: context, index: index));
                              Navigator.pop(context2);
                            }),
                      );
                    })
              ]),
            ),
        backgroundColor: Colors.transparent);
  }

  Widget _noteField(BuildContext context, ProductReturnInfoState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context)!.add_notes,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont)),
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
    ]);
  }

  Widget _saveButton(BuildContext context) {
    return CustomButtonWidget(
        buttonText: AppLocalizations.of(context)!.save,
        onPressed: () {
          context.read<ProductReturnInfoBloc>().add(
              ProductReturnInfoEvent.navigateReturnEvent(context: context));
        });
  }

  cameraEvent({required BuildContext context, required int index}) async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera].request();
    if (Platform.isAndroid) {
      if (!statuses[Permission.camera]!.isGranted) {
        Navigator.pop(context);
        CustomSnackBar.showSnackBar(
            context: context,
            title: AppLocalizations.of(context)!.camera_permission,
            type: SnackBarType.failure);
        return;
      }
    } else if (Platform.isIOS) {}
    context.read<ProductReturnInfoBloc>().add(
        ProductReturnInfoEvent.pickDocumentEvent(
            context: context, isFromCamera: true, value: index));
  }
}
