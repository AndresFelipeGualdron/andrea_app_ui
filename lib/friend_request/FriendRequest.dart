
import 'package:flutter/material.dart';

class FriendRequest extends Container {
  FriendRequest({super.key});



  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "User name"
      ),
    );
  }
}