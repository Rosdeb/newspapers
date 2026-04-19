import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newspapers/Models/NewspapersModels/newspapers.dart';
import 'package:newspapers/Router/route_names.dart';
import 'package:newspapers/Views/ArticalesDetails/articales_details.dart';
import 'package:newspapers/Views/HomeScreen/home_screen.dart';
import 'package:newspapers/Views/OfflinePage/offlinePage.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter({String initialLocation = AppPath.home}) {
  return GoRouter(
    initialLocation: initialLocation,
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: AppPath.home,
        name: AppRouteName.home,
        pageBuilder: (context, state) =>
            const MaterialPage(child: HomeScreen()),
      ),

      GoRoute(
        path: AppPath.offline,
        name: AppRouteName.offline,
        pageBuilder: (context, state) =>
            const MaterialPage(child: OfflinePage()),
      ),

      GoRoute(
        path: AppPath.articales_details,
        name: AppRouteName.articales_details,
        pageBuilder: (context, state) {
          final article = state.extra as Article;
          return MaterialPage(
            child: ArticalesDetails(article: article),
          );
        },
      ),

    ],
  );
}
