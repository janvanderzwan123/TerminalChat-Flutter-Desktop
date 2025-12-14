import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://127.0.0.1:8000",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
  ));

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Response> login(String username, String password) async {
    final formData = "username=$username&password=$password&grant_type=password";

    return await _dio.post(
      "/login",
      data: formData,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }

  Future<void> logout() async {
    await _storage.delete(key: "access_token");
  }


  Future<String?> getToken() async {
    return await _storage.read(key: "access_token");
  }

  Future<Response?> getUser(int userId) async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final response = await _dio.get(
        "/users/$userId",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return response;
    } on DioError catch (e) {
      print("Get user error: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  /// Example: Create a new user
  Future<Response?> createUser(Map<String, dynamic> userData) async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final response = await _dio.post(
        "/users/",
        data: userData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return response;
    } on DioError catch (e) {
      print("Create user error: ${e.response?.data ?? e.message}");
      return null;
    }
  }
}
