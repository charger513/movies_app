import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfoInterface {
  Future<bool> get isConnected;
}

class NetworkInfo implements NetworkInfoInterface {
  final InternetConnectionChecker internetConnectionChecker;

  NetworkInfo(this.internetConnectionChecker);

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}
