sealed class HomeEvent {
  const HomeEvent();
}

class HomeFetched extends HomeEvent {
  const HomeFetched({this.query = 'tesla'});

  final String query;
}

