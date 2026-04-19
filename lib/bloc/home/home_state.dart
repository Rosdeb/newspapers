import 'package:newspapers/Models/NewspapersModels/newspapers.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.articles = const [],
    this.query = 'tesla',
    this.errorMessage,
  });

  final HomeStatus status;
  final List<Article> articles;
  final String query;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<Article>? articles,
    String? query,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }
}
