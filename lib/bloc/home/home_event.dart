import 'home_state.dart';

sealed class HomeEvent {
  const HomeEvent();
}

class HomeFetched extends HomeEvent {
  const HomeFetched({
    this.query = '',
    this.category,
  });

  final String query;
  final NewsCategory? category;
}