import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:andrea_app_ui/config/Config.dart';

class AndreaAppService {

  static Config config = Config();

  static Future<http.Response> getViewersOfRoom(String roomName) async {
    await config.initSettings();
    final url = Uri.parse(config.globalConfigs["endpoints"]["andrea-app"]
        ?? "https://google.com");
    final headers = {'Content-Type': 'application/json'};
    final body = {
      "option": "getViewers",
      "roomName": roomName
    };
    http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body)
    ).timeout(const Duration(seconds: 15));
    return Future.value(response);
  }

  static Future<http.Response> sendFriendRequest(String user, int userId) async {
    await config.initSettings();
    final url = Uri.parse(config.globalConfigs["endpoints"]["andrea-app"]);
    final headers = {'Content-Type': 'application/json'};
    final body = {
      "option": "sendFriendRequest",
      "friendId": userId,
      "friendName": user
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body)
    ).timeout(const Duration(seconds: 15));

    return response;
  }

}