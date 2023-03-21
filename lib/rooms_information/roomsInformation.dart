
import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:andrea_app_ui/services/AndreaAppService.dart';

class RoomsInformation extends StatefulWidget {
  const RoomsInformation({super.key});

  @override
  RoomsInformationState createState() => RoomsInformationState();

}

class RoomsInformationState extends State<RoomsInformation> {
  final ScrollController _scrollController = ScrollController();
  final myController = TextEditingController();
  List<dynamic> _users = [];
  bool _isLoading = false;

  Future<bool> getUsersInRoom() async {
    bool answer = false;
    setState(() {
      _isLoading = true;
    });
    String nameRoom = myController.value.text;

    Response response = await AndreaAppService.getViewersOfRoom(nameRoom);

    if (response.statusCode == 200) {
      answer = true;

      setState(() {
        _users = response.statusCode != 200 ||
            jsonDecode(response.body)["members"] == null
            ? [] : jsonDecode(response.body)["members"];
      });
    } else {
      answer = false;
    }

    setState(() {
      _isLoading = false;
    });

    return answer;
  }

  Color getColorOfUser(String league) {
    switch(league) {
      case "grey":
        return Colors.grey;
      case "bronze":
        return Colors.brown;
      case "silver":
        return Colors.cyanAccent;
      case "gold":
        return Colors.amberAccent;
      case "diamond":
        return Colors.deepPurple;
      case "royal":
        return Colors.red;
      case "legend":
        return Colors.pink;
      default:
        return Colors.black;
    }
  }

  Future<bool> sendFriendRequest(String user, int userId) async {
    final completer = Completer<bool>();

    setState(() {
      _isLoading = true;
    });

    final response = await AndreaAppService.sendFriendRequest(user, userId);

    if(response.statusCode == 200) {
      completer.complete(true);
    } else {
      completer.complete(false);
    }

    setState(() {
      _isLoading = false;
    });

    return completer.future;
  }

  void showSuccessMessage(BuildContext context) {
    Flushbar(
      message: "Proceso procesado correctamente.",
      icon: const Icon(Icons.check, color: Colors.white),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  void showErrorMessage(BuildContext context) {
    Flushbar(
      message: "Error en el proceso.",
      icon: const Icon(Icons.error, color: Colors.white),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _isLoading,
        dismissible: false,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Room name"
              ),
              controller: myController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Future<bool> correct = getUsersInRoom();
                  correct.then((value) {
                    if(value) {
                      showSuccessMessage(context);
                    } else {
                      showErrorMessage(context);
                    }
                  });
                },
                child: const Text("Submit"),
              ),
            ),
            Expanded(
                child: Theme(
                  data: ThemeData(
                    scrollbarTheme: ScrollbarThemeData(
                      thickness: MaterialStateProperty.all(10.0),
                      thumbVisibility: MaterialStateProperty.all(true),
                      trackColor: MaterialStateProperty.all(Colors.grey),
                    ),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _users.length,
                      itemBuilder: (BuildContext context2, int index) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: Text(_users[index]["user"]["username"]),
                                  textColor: getColorOfUser(_users[index]["user"]["userRanking"]["league"]),
                                ),
                              ),
                              SizedBox(
                                  width: 200.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Future<bool> answer = sendFriendRequest(_users[index]["user"]["username"],
                                          _users[index]["user"]["id"]);
                                      answer.then((value) {
                                        if (value) {
                                          showSuccessMessage(context);
                                        } else {
                                          showErrorMessage(context);
                                        }
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.green),
                                    ),
                                    child: const Text("Enviar solicitud"),
                                  ),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                )
            ),
          ],
        ),
    );

  }
}