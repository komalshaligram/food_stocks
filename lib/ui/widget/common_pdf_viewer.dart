import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';

class CommonPdfViewer extends StatelessWidget {
  final String url;
  const CommonPdfViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    printData('invoiceLink:$url');
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
        child: CommonAppBar(
          title: '',
          iconData: Icons.arrow_back_ios_sharp,
          onTap: (){
            Navigator.pop(context);
          },
          bgColor: Colors.transparent,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SfPdfViewer.network(
          url,
        ),
      ),
    );
  }
}
