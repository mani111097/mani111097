import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistance {
  static Future<dynamic> getRequest(String url) async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        String jsondata = response.body;
        var decodedata = jsonDecode(jsondata);
        return decodedata;
      } else {
        return "FAILED";
      }
    } catch (exp) {
      return "FAILED";
    }
  }
}
