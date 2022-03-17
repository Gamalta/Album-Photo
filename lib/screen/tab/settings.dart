import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  
  const Settings(this.callback, {Key? key}) : super(key: key);
  final Function callback;

  @override
  State<Settings> createState() => SettingsState();
}  

class SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBar(
            actions: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => widget.callback("HOME"))
            ]
          ),
          const Center(child: Text("Settings")
          )
        ],
      )
    );
  }
}
