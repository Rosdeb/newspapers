import 'package:flutter/material.dart';
import 'package:newspapers/Views/HomeScreen/Base/shimmetEffected.dart';
import 'newsShimmer.dart';

class NewsListShimmer extends StatelessWidget {
  const NewsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => const NewsCardShimmer(),
    );
  }
}