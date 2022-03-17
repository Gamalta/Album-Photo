import 'package:lr_bike_life/utils/extension/hex_color.dart';
import 'package:flutter/material.dart';

class Tag{

  String _name = "";
  Color _color = Colors.black;
  String _creator = "";
  DateTime _createdAt = DateTime.now();
  String _category = "none";

  Tag(this._name, this._color, this._creator, this._createdAt, this._category);

  Tag.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _color = HexColor.fromHex(json['color']);
    _creator = json['creator'];
    _createdAt = DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt']));
    _category = json['category'];
  }

  Map<String, dynamic> toJson() => {
        '"name"': '"' + _name + '"',
        '"color"': '"' + _color.toHex() + '"',
        '"creator"': '"' + _creator + '"',
        '"createdAt"': '"' + _createdAt.microsecondsSinceEpoch.toString() + '"',
        '"category"': '"' + _category + '"'
  };

  String getName(){
    return _name;
  }

  setName(String name){
    _name = name;
  }
  Color getColor(){
    return _color;
  }

  setColor(Color color){ 
  _color = color;
  }
}