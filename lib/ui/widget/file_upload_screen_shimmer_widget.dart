import 'package:flutter/cupertino.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import 'common_shimmer_widget.dart';

class FileUploadScreenShimmerWidget extends StatelessWidget {
  const FileUploadScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            10.height,
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20),
              itemBuilder: (context, index) {
                return buildFileOrForm();
              },
            ),
            40.height,
            buildButton(),
            20.height,
          ],
        ),
      ),
    );
  }

  Widget buildFileOrForm() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextFieldTitle(),
            buildDownloadButton(),
          ],
        ),
        10.height,
        CommonShimmerWidget(
          child: Container(
            height: 130,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            ),
          ),
        ),
        20.height,
      ],
    );
  }

  Widget buildDownloadButton() {
    return CommonShimmerWidget(
      child: Container(
        height: 35,
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
      ),
    );
  }

  Widget buildTextFieldTitle() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.shimmerTextHeight,
        width: 140,
        margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_3)),
        ),
      ),
    );
  }

  Widget buildButton() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.buttonHeight,
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        ),
      ),
    );
  }
}
