import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newspapers/Router/app_router.dart';
import 'package:newspapers/main.dart';
import 'package:newspapers/Models/NewspapersModels/newspapers.dart';
import 'package:newspapers/Repository/news_repository.dart';
import 'package:newspapers/bloc/network/network_cubit.dart';

class FakeNewsRepository extends NewsRepository {
  @override
  Future<List<Article>> fetchArticles({required String query, required String category,}) async => [];
}

void main() {
  testWidgets('renders home search field', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        newsRepository: FakeNewsRepository(),
        networkCubit: NetworkCubit(),
        router: createAppRouter(),
        scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('search news'), findsOneWidget);
  });
}
