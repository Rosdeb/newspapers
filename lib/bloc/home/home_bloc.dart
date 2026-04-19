import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newspapers/Repository/news_repository.dart';
import 'package:newspapers/bloc/home/home_event.dart';
import 'package:newspapers/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required NewsRepository newsRepository})
    : _newsRepository = newsRepository,
      super(const HomeState()) {on<HomeFetched>(_onHomeFetched);
  }

  final NewsRepository _newsRepository;

  Future<void> _onHomeFetched(
    HomeFetched event,
    Emitter<HomeState> emit,
  ) async {

    final query = event.query.trim().isEmpty ? state.query : event.query.trim();

    emit(
      state.copyWith(
        status: HomeStatus.loading,
        query: query,
        errorMessage: null,
      ),
    );

    try {
      final articles = await _newsRepository.fetchArticles(query: query);
      emit(
        state.copyWith(
          status: HomeStatus.success,
          query: query,
          articles: articles,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          query: query,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
