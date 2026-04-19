import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:newspapers/Router/route_names.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  RxBool isOnline = true.obs;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<NavigatorState> navigatorKey;

  NetworkController({required this.navigatorKey});

  @override
  void onInit() {
    super.onInit();
    _startMonitoring();
  }

  void _startMonitoring() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      final previousStatus = isOnline.value;

      final connected = !result.contains(ConnectivityResult.none)
          ? await _verifyInternetAccess()
          : false;

      isOnline.value = connected;

      if (previousStatus != connected) {
        if (!connected) {
          _goToRoute(AppPath.offline);
          _showSnackBar(
            'No Internet Connection',
            background: Colors.red.shade400,
          );
        } else {
          _goToRoute(AppPath.home);
          _showSnackBar(
            'Back Online',
            background: Colors.green.shade400,
            duration: const Duration(seconds: 2),
          );
        }
      }
    });
  }

  void _goToRoute(String path) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        GoRouter.of(context).go(path);
      } else {
        debugPrint('Navigator context is null, could not navigate to $path');
      }
    });
  }

  Future<bool> _verifyInternetAccess() async {
    try {
      final lookup = await InternetAddress.lookup('google.com');
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showSnackBar(
    String message, {
    Color? background,
    Duration duration = const Duration(seconds: 3),
  }) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: background,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
