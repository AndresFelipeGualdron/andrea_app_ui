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
    return await http.post(url, headers: headers, body: jsonEncode(body));
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

    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> sendOneFriendRequest(String userName) async {
    await config.initSettings();
    final url = Uri.parse(config.globalConfigs["endpoints"]["andrea-app"]);
    final headers = {'Content-Type': 'application/json'};
    final body = {
      "option": "sendOneFriendRequest",
      "friendName": userName
    };

    return await http.post(url, headers: headers, body: jsonEncode(body));

  }

  static Future<http.Response> chaseModelsUsers() async {
    await config.initSettings();
    final url = Uri.parse("${config.globalConfigs['endpoints']['ngrok']}?profundidad=20");
    return await http.post(url);
  }

}