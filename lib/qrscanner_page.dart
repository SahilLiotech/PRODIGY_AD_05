import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  QRViewController? controller;
  final GlobalKey key = GlobalKey(debugLabel: 'QR');
  String? qrText;
  bool isScanning = true;

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          qrText = scanData.code;
          isScanning = false;
        });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _resetScanner() {
    setState(() {
      qrText = null;
      isScanning = true;
    });
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        centerTitle: true,
        elevation: 5.0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (isScanning)
            Expanded(
              flex: 5,
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blue,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: QRView(
                      key: key,
                      onQRViewCreated: onQRViewCreated,
                    ),
                  ),
                ),
              ),
            )
          else
            Expanded(
              flex: 5,
              child: Center(
                child: qrText != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Scanned data: $qrText',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (Uri.tryParse(qrText!)?.hasAbsolutePath ?? false)
                            ElevatedButton(
                              onPressed: () {
                                _launchURL(qrText!);
                              },
                              child: const Text('Open Content'),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: _resetScanner,
                            child: const Text('Cancel'),
                          ),
                        ],
                      )
                    : const Text("Scan QR code"),
              ),
            ),
          Expanded(
            flex: 1,
            child: Center(
              child: isScanning
                  ? const Text("Scan QR code")
                  : const Text("Scanned Details"),
            ),
          ),
        ],
      ),
    );
  }
}
