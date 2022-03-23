import 'package:lr_bike_life/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:lr_bike_life/screen/template.dart';
import 'package:lr_bike_life/utils/tag.dart';
import 'package:lr_bike_life/utils/account.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lr_bike_life/utils/user.dart';

void main() {

  runApp(App());
}

class App extends StatelessWidget {

  static late final Api api;
  final String title = 'La Rochelle bike-life';
  static Map<String, Tag> _tags = {};
  static Map<String, User> _users = {};
  static Account _account = Account('username', 'uuid', 'email', 'hashedPassword');

  // ignore: prefer_const_constructors_in_immutables
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', "US"),
        Locale('fr', 'FR')
      ],
      
      locale: const Locale('fr'),
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TabBase(),
    ); 
  }

  static Account getAccount(){
    return _account;
  }

  static setAccount(Account account){
    _account = account;
  }

  static initAPI(String username, String password){
    debugPrint("initing API...");
    api = Api(username, password);
  }

  static initTags() async {
    debugPrint("initing Tags...");
    _tags.clear();
    _tags = await api.getTags();
  }

  static Tag getTag(String name){
    return _tags[name]!;
  }

  static Map<String, Tag> getTags(){
    return _tags;
  }

  static setTags(Map<String, Tag> map){
    _tags = map;
  }

  static addTags(String name, Tag tag){
    _tags[name] = tag;
  }

  static initUsers() async {
    debugPrint("initing Users...");
    _users.clear();
    _users = await api.getUsers();
  }

  static User getUser(String uuid){
    return _users[uuid]!;
  }

  static Map<String, User> getUsers(){
    return _users;
  }

  static setUsers(Map<String, User> map){
    _users = map;
  }

  static addUsers(String uuid, User user){
    _users[uuid] = user;
  }
}