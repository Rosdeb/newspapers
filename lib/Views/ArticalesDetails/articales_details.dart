import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newspapers/Models/NewspapersModels/newspapers.dart';
import 'package:newspapers/utils/AppColor/app_colors.dart';

import '../Base/AppText/appText.dart';
class ArticalesDetails extends StatelessWidget {
  final Article article;
  ArticalesDetails({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray0,
      appBar: AppBar(
        backgroundColor: AppColors.gray0,
        title: const Text('Article Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? '',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.blue50,height: 200,),
                errorWidget: (context, url, error) =>
                const SizedBox(
                  height: 200,
                  child: Center(
                    child: Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppText(
              article.title ?? 'No title',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    article.author?.trim().isNotEmpty == true
                        ? article.author!
                        : 'Unknown author',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 12),
                AppText(
                  article.publishedAt ?? '',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppText(
              article.description?.trim().isNotEmpty == true
                  ? article.description!
                  : 'No description available',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12),
            AppText(
              article.content?.trim().isNotEmpty == true
                  ? article.content!
                  : 'No content available',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
