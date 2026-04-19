import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newspapers/Utils/AppIcon/app_icon.dart';
import 'package:newspapers/Utils/AppImage/app_image.dart';
import 'package:newspapers/Utils/AppSpacing/app_spacing.dart';
import 'package:newspapers/Utils/Typography/app_typography.dart';
import 'package:newspapers/Views/Base/AppText/appText.dart';
import 'package:newspapers/Views/Base/CustomTextfield/CustomTextfield.dart';
import 'package:newspapers/Views/Base/IOSTapEffect/iosTapEffect.dart';
import 'package:newspapers/Views/HomeScreen/Base/newslist.dart';
import 'package:newspapers/bloc/home/home_bloc.dart';
import 'package:newspapers/bloc/home/home_event.dart';
import 'package:newspapers/bloc/home/home_state.dart';
import 'package:newspapers/utils/AppColor/app_colors.dart';

import '../../Router/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchcontroller = TextEditingController();

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray0,
      appBar: AppBar(
        backgroundColor: AppColors.gray0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImage.app_logo, height: 50, width: 50),
            AppText("Newspapers", fontSize: 16, fontWeight: FontWeight.w600),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[];
        },
        body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            CustomTextField(
              borderRadius: 12,
              height: 45,
              controller: searchcontroller,
              hintText: "search news",
              borderColor: AppColors.gray500,
              prefixIcon: AppIcons.search,
              onSubmitted: (value) {
                context.read<HomeBloc>().add(
                  HomeFetched(
                    query: value,
                    category: context.read<HomeBloc>().state.category,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 42,
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final categories = NewsCategory.values;

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = state.category == category;

                      return IosTapEffect(
                        onTap: () {
                          context.read<HomeBloc>().add(
                            HomeFetched(
                              query: context.read<HomeBloc>().state.query,
                              category: category,
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isSelected ? AppColors.blue400 : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? AppColors.blue200 : AppColors.blue200,
                              width: 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: AppColors.blue200.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(scale: animation, child: child),
                                child: isSelected
                                    ? const Icon(
                                  Icons.check,
                                  key: ValueKey(true),
                                  size: 16,
                                  color: Colors.white,
                                ) : const SizedBox(key: ValueKey(false)),
                              ),

                              if (isSelected) const SizedBox(width: 6),

                              AppText(
                                category.label,
                                fontSize: 14,
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: AppSpacing.s16),
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                listenWhen: (previous, current) => previous.errorMessage != current.errorMessage && current.errorMessage != null,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                },
                builder: (context, state) {
                  if (state.status == HomeStatus.loading && state.articles.isEmpty) {
                    return NewsListShimmer();
                  }

                  if (state.status == HomeStatus.failure && state.articles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.errorMessage ?? 'Failed to load articles'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(
                                HomeFetched(query: searchcontroller.text),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.articles.isEmpty) {
                    return const Center(child: Text('No articles found'));
                  }

                  return RefreshIndicator(
                    color: AppColors.blue500,
                    backgroundColor: AppColors.gray0,
                    onRefresh: () async {
                      context.read<HomeBloc>().add(
                        HomeFetched(
                          query: searchcontroller.text,
                          category: context.read<HomeBloc>().state.category,
                        ),
                      );
                    },
                    child: ListView.builder(
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        final article = state.articles[index];
                        return IosTapEffect(
                          onTap: (){
                            final article = state.articles[index];
                            context.pushNamed(
                              AppRouteName.articales_details,
                              extra: article,
                            );

                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.gray0,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: AppColors.gray200,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: article.urlToImage ?? '',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const SizedBox(height: 200,),
                                    errorWidget: (context, url, error) =>
                                        const SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: Icon(Icons.image_not_supported),
                                          ),
                                        ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AppText(
                                          article.author?.trim().isNotEmpty == true
                                              ? article.author!
                                              : 'Unknown author',
                                          maxLines: 1,
                                          fontSize: 14,
                                          style: AppTypography.bodyLarge,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      AppText(
                                        article.publishedAt ?? "",
                                        maxLines: 1,
                                        fontSize: 12,
                                        style: AppTypography.bodySmall,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: AppText(
                                    article.title ?? 'No title',
                                    maxLines: 2,
                                    fontSize: 16,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
