import 'dart:convert';
import 'package:employee_management_u/model/user_login_get_model.dart';
import 'package:http/http.dart' as http;
// import 'user_login_get.dart';

class ApiService {
  // final String baseUrl;
  static const String baseUrl = "http://192.168.29.135:2000/app/users/login";

  

  Future<UserLoginGet> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl), // Replace with your actual login API endpoint
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      // return json.decode(response.body);
      final responseData = json.decode(response.body);
      print('+++++++++++++++++++++++++++++++++++++:${response.body}');

      // Assuming UserLoginGet.fromJson is a factory constructor in your model class
      return UserLoginGet.fromJson(responseData['user']);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
