enum NetworkStatus { online, offline }

class NetworkState {
  const NetworkState({
    this.status = NetworkStatus.online,
    this.hasCheckedConnection = false,
  });

  final NetworkStatus status;
  final bool hasCheckedConnection;

  bool get isOnline => status == NetworkStatus.online;

  NetworkState copyWith({NetworkStatus? status, bool? hasCheckedConnection}) {
    return NetworkState(
      status: status ?? this.status,
      hasCheckedConnection: hasCheckedConnection ?? this.hasCheckedConnection,
    );
  }
}
