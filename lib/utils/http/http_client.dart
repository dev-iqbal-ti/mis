import 'dart:convert';

import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/logging/logger.dart';

import 'package:dronees/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class THttpHelper {
  static const String _baseUrl = "";

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      "Authorization": AuthController.instance.authUser?.token ?? "",
    };
  }

  static const String _apiVersion = "/v1";
  // Helper method to make a GET request
  static Future<Map<String, dynamic>?> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool showError = true,
  }) async {
    TLoggerHelper.customPrint("In get request $endpoint");

    try {
      final uri = Uri.parse(
        '$_baseUrl/$_apiVersion$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);
      return _handleResponse(response, endpoint, showError);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      return null;
    }
  }

  // Helper method to make a POST request
  static Future<Map<String, dynamic>?> post(
    String endpoint,
    dynamic data,
  ) async {
    TLoggerHelper.customPrint("In post request $endpoint");
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_apiVersion$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response, endpoint, true);
    } catch (e) {
      TLoggerHelper.customPrint(e);
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      return null;
    }
  }

  // Handle the HTTP response
  static Map<String, dynamic>? _handleResponse(
    http.Response response,
    String? endpoint,
    bool showError,
  ) {
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      if (endpoint == "/fetch-property-details" && response.statusCode == 500) {
        return {"message": "Property not found"};
      }
      if (data["message"] == "Authentication Failed!") {
        AuthController.instance.logout();
        // Get.offAll(() => const WelcomeScreen());
      }
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
    if (data["message"] == "Error occured!" &&
        data.containsKey("error") &&
        data["error"].containsKey("error_type")) {
      String errorType = data["error"]["error_type"];
      // String? message = Constants.stytchErrors[errorType];
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      return;
    }
    if (!showError &&
        data['message'] == "Authentication Failed! User doesn't exist!") {
      return;
    }
    String? message = data["message"];
    TLoaders.errorSnackBar(
      title: "Error",
      message: message ?? "Something went wrong",
    );
  }
}
