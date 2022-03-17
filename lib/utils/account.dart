import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lr_bike_life/utils/api.dart';

import '../main.dart';

class Account {
  String _username = "";
  String _email = "";
  String _hashedPassword = "";
  String _uuid = "";
  bool _connected = false;

  Account(this._uuid, this._username, this._email, this._hashedPassword);

  Account.fromJson(Map<String, dynamic> json) {
    _uuid = json["uuid"];
    _username = json['username'];
    _email = json['email'];
    _hashedPassword = json['password'];
  }

  connect(String password) async {

    String date = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    //App.initAPI(_username, password);
    
    try {
      Map<String, dynamic> jsonObject = await Api.getUser(_username, password);
      _uuid = jsonObject["uuid"];
      _username = jsonObject['username'];
      _email = jsonObject['email'];
      _hashedPassword = jsonObject['password'];
      App.initAPI(_username, _hashedPassword);
      debugPrint('connected ! user: ' + _username + " at " + date);
      _connected = true;
      return true;

    } catch(e){
      debugPrint('connection failed ! user: ' + _username + " at " + date);
      _hashedPassword = "";
      _email = "";
      _connected = false;
      return false;
    }
  }
  
  bool isConnected(){
    return _connected;
  }

  String getHasedPassword(){
    return _hashedPassword;
  }

  setUsername(String username){
    _username = username;
  }

  String getUniqueId(){
    return _uuid;
  }

  String getUsername(){
    return _username;
  }
  String getEmail(){
    return _email;
  }
}
