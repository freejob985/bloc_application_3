import 'dart:convert';
import 'package:bloc_application_3/ApiResponse.dart';
import 'package:http/http.dart' as http;

class Apihelper {
  static const baseURL = 'http://192.168.1.3/cafeteriaapp/public/api';
// ----- Errors -----
  static const serverError = 'Server error';
  static const unauthorized = 'Unauthorized';
  static const somethingWentWrong = 'Something went wrong, try again!';

  Future<ApiResponse> fetchData<T>(String url,
      {String? token,
      String? tableName,
      required T Function(Map<String, dynamic>) fromJson}) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      final response = await http.get(
        Uri.parse("$baseURL/$url"),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = response.body;
        if (tableName != null) {
          apiResponse.data = jsonDecode(data)[tableName];
        } else {
          apiResponse.data = jsonDecode(data);
        }
      } else {
        print("${response.body}");
        switch (response.statusCode) {
          case 200:
            if (tableName != null) {
              apiResponse.data =
                  jsonDecode(response.body)[tableName].map<T>((p) {
                return fromJson(p);
              }).toList();
            } else {
              apiResponse.data = jsonDecode(response.body).map<T>((p) {
                return fromJson(p);
              }).toList();
            }
            break;
          case 401:
            apiResponse.error = unauthorized;
            break;
          default:
            apiResponse.error = somethingWentWrong;

            break;
        }
      }
    } catch (e) {
      print("ERR:::::$e");
      apiResponse.error = serverError;
    }

    return apiResponse;
  }

  


}