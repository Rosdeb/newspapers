import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newspapers/Utils/AppIcon/app_icon.dart';
import 'package:newspapers/Utils/AppImage/app_image.dart';
import 'package:newspapers/Views/Base/AppText/appText.dart';
import 'package:newspapers/Views/Base/CustomTextfield/CustomTextfield.dart';
import 'package:newspapers/bloc/home/home_bloc.dart';
import 'package:newspapers/bloc/home/home_event.dart';
import 'package:newspapers/bloc/home/home_state.dart';
import 'package:newspapers/utils/AppColor/app_colors.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            CustomTextField(
              borderRadius: 12,
              height: 40,
              controller: searchcontroller,
              hintText: "search news",
              borderColor: AppColors.gray500,
              prefixIcon: AppIcons.search,
              onSubmitted: (value) {
                context.read<HomeBloc>().add(HomeFetched(query: value));
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                listenWhen: (previous, current) =>
                    previous.errorMessage != current.errorMessage &&
                    current.errorMessage != null,
                listener: (context, state) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                },
                builder: (context, state) {
                  if (state.status == HomeStatus.loading &&
                      state.articles.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == HomeStatus.failure &&
                      state.articles.isEmpty) {
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

                  return ListView.builder(
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      final article = state.articles[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gray50,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: AppColors.gray50,
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
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
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
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                article.title ?? 'No title',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
