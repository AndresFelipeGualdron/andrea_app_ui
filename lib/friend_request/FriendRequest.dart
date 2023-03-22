
import 'package:andrea_app_ui/services/AndreaAppService.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({super.key});



  @override
  FriendRequestState createState() => FriendRequestState();
}

class FriendRequestState extends State<FriendRequest> {
  final myControllerFieldText = TextEditingController();

  bool _isLoading = false;

  Future<bool> sendFriendRequest() async {
    String userName = myControllerFieldText.value.text;
    bool answer = false;

    setState(() {
      _isLoading = true;
    });

    try {
      Response response = await AndreaAppService.sendOneFriendRequest(userName);

      answer = response.statusCode == 200;
    } catch (e) {
      answer = false;
    }


    setState(() {
      _isLoading = false;
    });

    return answer;
  }

  Future<bool> sendBigFriendRequests() async {
    bool answer = false;

    setState(() {
      _isLoading = true;
    });
    try {
      Response response = await AndreaAppService.chaseModelsUsers();

      answer = response.statusCode == 200;
    } catch (e) {
      answer = false;
    }


    setState(() {
      _isLoading = false;
    });

    return answer;
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
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "User name"
                  ),
                  controller: myControllerFieldText,
                ),
                ElevatedButton(
                  onPressed: () {
                    sendFriendRequest().then((value) {
                      if (value) {
                        showSuccessMessage(context);
                      } else {
                        showErrorMessage(context);
                      }
                    });
                  },
                  child: const Text("Enviar solicitud al usuario ingresado")
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    sendBigFriendRequests()
                        .then((value) {
                          if (value) {
                            showSuccessMessage(context);
                          } else {
                            showErrorMessage(context);
                          }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple)
                  ),
                  child: const Text("Enviar solicitudes en masa"),
                ),
              ],
            ),
          ],
        )
    );
  }
}