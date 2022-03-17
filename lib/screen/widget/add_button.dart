import 'dart:core';
import 'package:flutter/material.dart';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/screen/popup/add_picture.dart';

class AddButton extends StatelessWidget {

  const AddButton(this.callback, {Key? key}) : super(key: key);
  final Function callback;
  final double circleSize = 58;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: circleSize+8,
      height: circleSize+8,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[800])),
          Container(margin: const EdgeInsets.all(4), decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
          Center(
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () => addPicture(context),
            )
          )
        ]
      )
    );
  }
  
  void addPicture(BuildContext context){
    App.initTags();
    showDialog(context: context, builder: (BuildContext context) => AddPicture(callback));
  }
}