import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newspapers/Views/HomeScreen/Base/shimmetEffected.dart';
import 'package:newspapers/utils/AppColor/app_colors.dart';

class NewsCardShimmer extends StatelessWidget {
  const NewsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.gray0,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomShimmer(
            width: double.infinity,
            height: 150,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: CustomShimmer(
              width: double.infinity,
              height: 14,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: CustomShimmer(
              width: double.infinity,
              height: 14,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: CustomShimmer(
              width: 180,
              height: 12,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}