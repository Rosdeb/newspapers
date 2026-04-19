import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newspapers/Router/route_names.dart';
import 'package:newspapers/Utils/AppImage/app_image.dart';
import 'package:newspapers/Views/Base/AppText/appText.dart';
import 'package:newspapers/utils/AppColor/app_colors.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    return Scaffold(
      backgroundColor: AppColors.gray0,
      body: SafeArea(
        child: Center(
          child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImage.offline,
                    height: isTablet ? 140 : 110,
                    width: isTablet ? 140 : 110,
                  ),
                  const SizedBox(height: 20),
                  AppText(
                    "You're Offline",
                    fontSize: isTablet ? 26 : 22,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
           ),
      ),
    );
  }
}