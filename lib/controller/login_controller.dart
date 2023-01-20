import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final _apiUrl = "https://api.aglpearlshop.com/api/chat/Login";

  Future<void> login(String username, String password, String deviceId) async {
    try {
      var response = await http.post(
        Uri.parse(_apiUrl),
        body: {
          "UserNameId": username,
          "UserPassword": password,
          "DeviceId": deviceId,
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        // Successful login
        // handle the response
      } else {
        // Handle error
      }
    } catch (e) {
      print(e);
      // Handle exception
    }
  }
}
