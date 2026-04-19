import 'package:flutter/material.dart';
import 'package:newspapers/Utils/AppImage/app_image.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Image.asset(AppImage.offline)]));
  }
}
