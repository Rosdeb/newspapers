import 'package:newspapers/Models/NewspapersModels/newspapers.dart';

enum HomeStatus { initial, loading, success, failure }

enum NewsCategory { general, business, technology, entertainment }

extension NewsCategoryX on NewsCategory {
  String get label {
    switch (this) {
      case NewsCategory.general:
        return 'All';
      case NewsCategory.business:
        return 'Business';
      case NewsCategory.technology:
        return 'Tech';
      case NewsCategory.entertainment:
        return 'Entertainment';
    }
  }

  String get apiValue {
    switch (this) {
      case NewsCategory.general:
        return 'general';
      case NewsCategory.business:
        return 'business';
      case NewsCategory.technology:
        return 'technology';
      case NewsCategory.entertainment:
        return 'entertainment';
    }
  }
}


class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.articles = const [],
    this.query = '',
    this.category = NewsCategory.general,
    this.errorMessage,
  });

  final HomeStatus status;
  final List<Article> articles;
  final String query;
  final NewsCategory category;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<Article>? articles,
    String? query,
    NewsCategory? category,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      query: query ?? this.query,
      category: category ?? this.category,
      errorMessage: errorMessage,
    );
  }
}
