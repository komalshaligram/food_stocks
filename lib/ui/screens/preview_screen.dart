import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';

class PreviewScreenRoute {
  static Widget get route =>  const PreviewScreen();
}

class PreviewScreen extends StatelessWidget {
   const PreviewScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return Scaffold(
      appBar: AppBar(
        title: Text(args?[AppStrings.clientFormString],
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.normalFont,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500)
        ),
      ),
      body: SfPdfViewer.network(
        '${AppUrlEndPoints.baseFileUrl}${args?[AppStrings.privacyPolicyPdfString]}'
      ),
    );
  }
}
