import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.dev.kpi-drive.ru/_api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Authorization': 'Bearer 5c3964b8e3ee4755f2cc0febb851e2f8',
        'Accept': '*/*',
      },
    ),
  )..interceptors.add(_LogInterceptor());

  Future<List<dynamic>> getTasks() async {
    final res = await _dio.post(
      '/indicators/get_mo_indicators',
      data: FormData.fromMap({
        'period_start': '2026-04-01',
        'period_end': '2026-04-30',
        'period_key': 'month',
        'requested_mo_id': 42,
        'behaviour_key': 'task,kpi_task',
        'with_result': false,
        'response_fields': 'name,indicator_to_mo_id,parent_id,order',
        'auth_user_id': 40,
      }),
    );

    return res.data['DATA']['rows'] as List<dynamic>;
  }

  static Future<void> moveTask({
    required int indicatorToMoId,
    required int newParentId,
    required int newOrder,
  }) async {
    await instance._saveField(
      indicatorToMoId: indicatorToMoId,
      fieldName: 'parent_id',
      fieldValue: newParentId,
    );
    await instance._saveField(
      indicatorToMoId: indicatorToMoId,
      fieldName: 'order',
      fieldValue: newOrder,
    );
  }

  Future<void> _saveField({
    required int indicatorToMoId,
    required String fieldName,
    required dynamic fieldValue,
  }) async {
    try {
      final res = await _dio.post(
        '/indicators/save_indicator_instance_field',
        data: FormData.fromMap({
          'period_start': '2026-04-01',
          'period_end': '2026-04-30',
          'period_key': 'month',
          'indicator_to_mo_id': indicatorToMoId,
          'field_name': fieldName,
          'field_value': fieldValue,
          'auth_user_id': 40,
        }),
      );

      final body = res.data;
      final status = (body['STATUS'] ?? body['status'] ?? '')
          .toString()
          .toUpperCase();
      final success =
          status == 'OK' || body['SUCCESS'] == true || body['success'] == true;

      if (!success) {
        debugPrint('_saveField: server rejected $fieldName — ${res.data}');
        throw Exception('Server rejected $fieldName update');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception(
          '403 CORS blocked — run: flutter run -d chrome --web-browser-flag "--disable-web-security"',
        );
      }
      rethrow;
    }
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('→ ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('← ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '✗ ${err.response?.statusCode ?? "no status"} ${err.requestOptions.path}: ${err.message}',
    );
    super.onError(err, handler);
  }
}
