import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewScreenRoute {
  static Widget get route => const PreviewScreen();
}

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Form'),
      ),
      body: Container(
        child: SfPdfViewer.network('https://filesamples.com/samples/document/pdf/sample3.pdf'),
      ),
    );
  }
}
