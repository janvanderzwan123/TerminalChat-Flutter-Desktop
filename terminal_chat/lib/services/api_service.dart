import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {"Content-Type": "application/json"};
  }

  Future<Response> login(String username, String password) async {
    final response = await _dio.post(
      "/login",
      data: {"username": username, "password": password},
    );

    if (response.statusCode == 200) {
      final token = response.data["access_token"];
      if (token != null) {
        await _storage.write(key: "access_token", value: token);
      }
    }
    return response;
  }

  Future<Response> createUser(String name, String username, String email, String password) async {
    return await _dio.post(
      "/users/",
      data: {
        "name": name,
        "username": username,
        "email": email,
        "password": password,
      },
    );
  }

  Future<Response> getUser(int id) async {
    final token = await _storage.read(key: "access_token");
    return await _dio.get(
      "/users/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
