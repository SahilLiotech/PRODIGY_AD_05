import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/qrscanner_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Scanner',
      home: QRScanner(),
    );
  }
}
