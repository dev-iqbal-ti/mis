import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:http/http.dart' as http;

class THttpHelper {
  static const String _baseUrl = "http://localhost:4000/api";
  // static const String _baseUrl = "http://10.0.2.2:4000/api";
  // static const String _baseUrl = String.fromEnvironment(
  //   'BACKEND_URL',
  //   defaultValue: '',
  // );

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      "authorization":
          "Bearer ${AuthController.instance.authUser?.accessToken ?? ""}",
      "x-session-id": AuthController.instance.authUser?.sessionId ?? "",
    };
  }

  // Helper method to make a GET request
  static Future<Map<String, dynamic>?> getRequest(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool showError = true,
  }) async {
    TLoggerHelper.customPrint(_baseUrl);

    TLoggerHelper.customPrint("In get request $endpoint");

    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);
      return _handleResponse(response, endpoint, showError);
    } catch (e) {
      log(e.toString());
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      return null;
    }
  }

  // Helper method to make a PUT request
  static Future<Map<String, dynamic>?> putRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    bool showError = true,
  }) async {
    TLoggerHelper.customPrint(_baseUrl);
    TLoggerHelper.customPrint("In PUT request $endpoint");

    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.put(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response, endpoint, showError);
    } catch (e) {
      log(e.toString());
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      return null;
    }
  }

  // Helper method to make a POST request
  static Future<Map<String, dynamic>?> postRequest(
    String endpoint,
    dynamic data,
  ) async {
    TLoggerHelper.customPrint(_baseUrl);
    TLoggerHelper.customPrint("In post request $endpoint");
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      TLoggerHelper.customPrint(response.body, endpoint);
      return _handleResponse(response, endpoint, true);
    } catch (e) {
      log(e.toString());
      TLoggerHelper.customPrint(e);
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> deleteRequest(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response, endpoint, true);
    } catch (e) {
      log(e.toString());
      TLoggerHelper.customPrint(e);
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      return null;
    }
  }

  // static Future<Map<String, dynamic>?> formDataRequest(
  //   String endpoint,
  //   File? file,
  //   Map<String, dynamic> data,
  // ) async {
  //   try {
  //     var uri = Uri.parse('$_baseUrl$endpoint');

  //     var request = http.MultipartRequest('POST', uri);
  //     if (file != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'image',
  //           file.path,
  //           filename: file.path.split('/').last,
  //         ),
  //       );
  //     }
  //     // log(file.path.split('/').last);
  //     request.headers.addAll(headers);
  //     request.fields.addAll(
  //       data.map((key, value) => MapEntry(key, value.toString())),
  //     );

  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();

  //     TLoggerHelper.customPrint(responseData, endpoint);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return jsonDecode(responseData);
  //     }
  //     return null;
  //   } catch (e) {
  //     log(e.toString());
  //     TLoggerHelper.customPrint(e);
  //     TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
  //     return null;
  //   }
  // }

  static Future<Map<String, dynamic>?> formDataRequest(
    String endpoint,
    File? file,
    Map<String, dynamic> data,
  ) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: _baseUrl));

      FormData formData = FormData.fromMap({
        ...data,
        if (file != null)
          'image': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      });

      final response = await dio.post(
        endpoint,
        data: formData,
        options: Options(headers: headers),
      );

      TLoggerHelper.customPrint(response.data, endpoint);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data is Map<String, dynamic>
            ? response.data
            : jsonDecode(response.data);
      }
      return null;
    } on DioException catch (e) {
      String message = "Something went wrong";

      if (e.response != null) {
        // Backend error message
        message =
            e.response?.data?['message'] ??
            e.response?.statusMessage ??
            message;
      } else {
        // Network / timeout / unknown
        message = e.message ?? message;
      }

      log(message);
      TLoggerHelper.customPrint(e);

      TLoaders.errorSnackBar(title: "Error", message: message);
      return null;
    } catch (e) {
      log(e.toString());
      TLoggerHelper.customPrint(e);
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> uploadImageWithProgress({
    required String endpoint,
    required File file,
    required Function(double) onProgress,
  }) async {
    try {
      TLoggerHelper.customPrint(endpoint);
      final dio = Dio(BaseOptions(baseUrl: _baseUrl));

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await dio.post(
        endpoint,
        data: formData,
        options: Options(headers: headers),
        // This is the magic part for the progress bar
        onSendProgress: (int sent, int total) {
          if (total != -1) {
            double progress = sent / total;
            onProgress(progress);
          }
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data is Map<String, dynamic>
            ? response.data
            : jsonDecode(response.data);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // static Future<Map<String, dynamic>?> postDioRequest(
  //   String endpoint,
  //   dynamic data,
  // ) async {
  //   TLoggerHelper.customPrint("In post request $endpoint");
  //   final dio = Dio();
  //   try {
  //     Response response = await dio.post(
  //       '$_baseUrl$endpoint',
  //       options: Options(headers: headers),
  //       data: data,
  //     );
  //     TLoggerHelper.customPrint(response.data, endpoint);
  //     // return _handleResponse(response, endpoint, true);
  //   } catch (e) {
  //     TLoggerHelper.customPrint(e);
  //     TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
  //     return null;
  //   }
  // }

  // Handle the HTTP response
  static Map<String, dynamic>? _handleResponse(
    http.Response response,
    String? endpoint,
    bool showError,
  ) {
    TLoggerHelper.customPrint(response.body, endpoint);
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      _showErrorToast(
        response.body,
        "$endpoint ${response.statusCode}",
        showError,
      );
      return null;
    }
  }

  static void _showErrorToast(String body, String? endpoint, bool showError) {
    final Map<String, dynamic> data = jsonDecode(body);
    TLoggerHelper.customPrint(data, endpoint);

    String? message =
        data["error"] ?? data["message"] ?? "Something went wrong";
    TLoaders.errorSnackBar(title: "Error", message: message);
  }
}
