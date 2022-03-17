import 'package:flutter/material.dart';

class Profile extends StatefulWidget {

  const Profile(this.callback, {Key? key}) : super(key: key);
  final Function callback;

  @override
  State<Profile> createState() => ProfileState();
}  

class ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
           AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => widget.callback("HOME")
              )
            ]
          ),
          const Center(
             child: Text("Profiles")
          )
        ],
      )
    );
  }
}