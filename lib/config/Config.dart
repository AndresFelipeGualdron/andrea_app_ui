import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Config {
  
  dynamic globalConfigs = {
    "endpoints": {
      "andrea-app": "",
      "ngrok": ""
    }
  };

  static final Config _instance = Config._internal();

  factory Config() {
    return _instance;
  }

  Future<void> initSettings() async {
    final url = Uri.parse("https://raw.githubusercontent.com/gualdronsito/scripts/main/andrea-app-config.json");
    http.Response response = await http.get(url).timeout(const Duration(seconds: 5));
    if(response.statusCode == 200) {
      dynamic object = jsonDecode(response.body);
      globalConfigs["endpoints"]["andrea-app"] = object["endpoints"]["andreaApp"];
      globalConfigs["endpoints"]["ngrok"] = object["endpoints"]["ngrok"];
    }
  }

  Config._internal();

}