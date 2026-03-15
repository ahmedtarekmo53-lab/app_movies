import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static late Dio authDio;

  static init() {
    // Dio للأفلام (YTS API)
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://movies-api.accel.li/api/v2/', 
        receiveDataWhenStatusError: true,
      ),
    );

    // Dio للـ Auth (رابط Postman)
    authDio = Dio(
      BaseOptions(
        baseUrl: 'YOUR_AUTH_BASE_URL_HERE', // استبدل هذا برابط Postman الخاص بالـ Auth
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    bool isAuth = false,
  }) async {
    return await (isAuth ? authDio : dio).get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    bool isAuth = false,
  }) async {
    return await (isAuth ? authDio : dio).post(url, data: data);
  }
}
