import 'package:andrea_app_ui/friend_request/FriendRequest.dart';
import 'package:andrea_app_ui/rooms_information/roomsInformation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andrea App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  final String title = "Andrea App";
  final String titleMenu = "Menú";
  final String roomsInformation = "Información de rooms";
  final String friendRequests = "Manejo solicitudes de amsitad";

  int _page = 0;

  void changePage(context, int page) {
    setState(() {
      _page = page;
    });
    Navigator.pop(context);
  }

  Widget bodyFunction() {
    switch (_page) {
      case 0:
        return const RoomsInformation();
      case 1:
        return FriendRequest();
      default:
        return Container(color: Colors.amber,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: bodyFunction(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Colors.blue
              ),
              child: Text(titleMenu),
            ),
            ListTile(
              title: Text(roomsInformation),
              onTap: () {
                changePage(context, 0);
              },
            ),
            ListTile(
              title: Text(friendRequests),
              onTap: () {
                changePage(context, 1);
              },
            )
          ],
        ),
      ),
    );
  }
}
