import 'package:dio/dio.dart';

import '../../../network/api_endpoints.dart';
import '../models/register_push_device_request.dart';
import '../models/remove_push_device_request.dart';

final class PushDeviceApiClient {
  PushDeviceApiClient({required Dio dio}) : _dio = dio;

  static const String _endpoint = ApiEndpoints.pushDevices;

  final Dio _dio;

  Future<void> registerPushDevice(
    final RegisterPushDeviceRequest request,
  ) async {
    await _dio.post<void>(_endpoint, data: request.toJson());
  }

  Future<void> removePushDevice(final RemovePushDeviceRequest request) async {
    await _dio.delete<void>(_endpoint, data: request.toJson());
  }
}
