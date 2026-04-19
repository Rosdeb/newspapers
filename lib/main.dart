import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:newspapers/Router/app_router.dart';
import 'package:newspapers/Router/route_names.dart';
import 'package:newspapers/Repository/news_repository.dart';
import 'package:newspapers/bloc/home/home_bloc.dart';
import 'package:newspapers/bloc/home/home_event.dart';
import 'package:newspapers/bloc/network/network_cubit.dart';
import 'package:newspapers/bloc/network/network_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final networkCubit = NetworkCubit();
  await networkCubit.initialize();
  final newsRepository = NewsRepository.forOnlineStatus(
    isOnline: () => networkCubit.state.isOnline,
  );
  final router = createAppRouter(
    initialLocation: networkCubit.state.isOnline
        ? AppPath.home
        : AppPath.offline,
  );

  runApp(
    MyApp(
      newsRepository: newsRepository,
      networkCubit: networkCubit,
      router: router,
      scaffoldMessengerKey: scaffoldMessengerKey,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.newsRepository,
    required this.networkCubit,
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    required GoRouter router,
  }) : _scaffoldMessengerKey = scaffoldMessengerKey,
       _router = router;

  final NewsRepository newsRepository;
  final NetworkCubit networkCubit;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;
  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: networkCubit),
        BlocProvider(create: (_) =>
          HomeBloc(newsRepository: newsRepository)
                ..add(const HomeFetched()),
        ),
      ],
      child: AppView(
        router: _router,
        scaffoldMessengerKey: _scaffoldMessengerKey,
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({required this.router, required this.scaffoldMessengerKey});

  final GoRouter router;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkState>(
      listenWhen: (previous, current) => previous.status != current.status && current.hasCheckedConnection,
      listener: (context, state) {
        router.go(state.isOnline ? AppPath.home : AppPath.offline);
        if (state.isOnline) {
          context.read<HomeBloc>().add(
            HomeFetched(query: context.read<HomeBloc>().state.query),
          );
        }
      },
      child: MaterialApp.router(
        routerConfig: router,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Newspapers',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
