import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/bloc/qr_scan/qr_scan_bloc.dart';

class QrScanRoute {
  static Widget get route => QrScanScreen();
}

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrScanBloc(),
      child: QrScanScreenWidget(),
    );
  }
}

class QrScanScreenWidget extends StatelessWidget {
  const QrScanScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
            alignment: Alignment.center,
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () => scanBarcodeNormal(context: context),
                      child: Text('Start barcode scan')),
                  // ElevatedButton(
                  //     onPressed: () => scanQR(),
                  //     child: Text('Start QR scan')),
                  // ElevatedButton(
                  //     onPressed: () => startBarcodeScanStream(),
                  //     child: Text('Start barcode scan stream')),
                  // Text('Scan result : $_scanBarcode\n',
                  //     style: TextStyle(fontSize: 20))
                ]));
      }),
    );
  }

  Future<void> scanBarcodeNormal({required BuildContext context}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff20BF6B', AppLocalizations.of(context).cancel, true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    debugPrint('barcode = $barcodeScanRes');
  }
}

// class QrScanScreenWidget extends StatefulWidget {
//   const QrScanScreenWidget({super.key});
//
//   @override
//   State<QrScanScreenWidget> createState() => _QrScanScreenWidgetState();
// }
//
// class _QrScanScreenWidgetState extends State<QrScanScreenWidget> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<QrScanBloc, QrScanState>(
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: AppColors.pageColor,
//           body: Stack(
//             children: [
//               QRView(
//                 key: qrKey,
//                 onQRViewCreated: _onQRViewCreated,
//                 overlay: QrScannerOverlayShape(
//                     borderRadius: AppConstants.radius_20,
//                     borderWidth: 10,
//                     borderLength: 70,
//                     borderColor: AppColors.whiteColor),
//                 cameraFacing: CameraFacing.back,
//               ),
//               Positioned(
//                   bottom: 30,
//                   left: getScreenWidth(context) / 2 - 30,
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     borderRadius: BorderRadius.all(
//                         Radius.circular(AppConstants.radius_100)),
//                     child: Container(
//                       height: 60,
//                       width: 60,
//                       decoration: BoxDecoration(
//                         color: AppColors.blackColor,
//                         shape: BoxShape.circle,
//                       ),
//                       alignment: Alignment.center,
//                       child: Icon(
//                         Icons.close_sharp,
//                         color: AppColors.whiteColor,
//                         size: 40,
//                       ),
//                     ),
//                   ))
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((barcode) {
//       debugPrint('barcode = $barcode');
//     });
//   }
//
//   @override
//   void dispose() {
//     controller!.dispose();
//     super.dispose();
//   }
// }
