import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newspapers/bloc/network/network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity(),
      super(const NetworkState());

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> initialize() async {
    final initialResults = await _connectivity.checkConnectivity();
    final initialStatus = await _resolveConnection(initialResults);
    _emitConnection(initialStatus);

    _subscription ??= _connectivity.onConnectivityChanged.listen((
      results,
    ) async {
      final isOnline = await _resolveConnection(results);
      _emitConnection(isOnline);
    });
  }

  Future<bool> _resolveConnection(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none)) {
      return false;
    }

    try {
      final lookup = await InternetAddress.lookup('google.com');
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _emitConnection(bool isOnline) {
    final nextStatus = isOnline ? NetworkStatus.online : NetworkStatus.offline;
    if (state.status == nextStatus && state.hasCheckedConnection) {
      return;
    }

    emit(state.copyWith(status: nextStatus, hasCheckedConnection: true));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
