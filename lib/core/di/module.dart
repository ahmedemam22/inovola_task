import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/hive_service.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => DioClient().dio;

  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl();

  @lazySingleton
  HiveService get hiveService => HiveService.instance;
}
