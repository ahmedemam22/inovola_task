abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // In a real app, you would use connectivity_plus package
    // For now, we'll assume we have internet connection
    // You can implement proper connectivity checking here
    return true;
  }
}
