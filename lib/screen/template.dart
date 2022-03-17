import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/screen/tab/home.dart';
import 'package:lr_bike_life/screen/widget/add_button.dart';
import 'package:lr_bike_life/screen/tab/login.dart';
import 'package:lr_bike_life/screen/tab/profile.dart';
import 'package:lr_bike_life/screen/tab/settings.dart';
import 'package:lr_bike_life/screen/widget/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/account.dart';

class TabBase extends StatefulWidget {

  const TabBase({Key? key}) : super(key: key);

  @override
  State<TabBase> createState() => TabBaseState();
}

class TabBaseState extends State<TabBase> with SingleTickerProviderStateMixin {

  int navbarIcon = 0;
  late Widget currentPage;
  late bool hasNavBar;

  @override
  void initState() {
    super.initState();
    currentPage = Login(callback);
    hasNavBar = false;
    rememberLogin();
  }

  rememberLogin() async{
      
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? remember = prefs.getBool('remember');
    String? username = prefs.getString('username');
    String? hasedPassword = prefs.getString('hashedPassword');
    
    if(remember != null && username != null && hasedPassword != null ){
      
      Account account = Account("", username, "", "");
      App.setAccount(account);
      await account.connect(hasedPassword);
      
      setState(() {
        if(account.isConnected()){
          App.initTags();
          App.initUsers();
          callback("HOME");
        } else {
          prefs.setBool('remember', false);
          prefs.setString('username', "");
          prefs.setString('hashedPassword', "");
          callback("LOGIN");
        }
      });
    }
  }
  void callback(String page) {
    setState(() {
      switch(page){
        case "LOGIN":
          currentPage = Login(callback);
          hasNavBar = false;
          break;
        case "PROFILE":
          navbarIcon = 3;
          currentPage = Profile(callback);
          hasNavBar = true;
          break;
        case "SETTINGS":
          navbarIcon = 4;
          currentPage = Settings(callback);
          hasNavBar = true;
          break;
        default:
          navbarIcon = 0;
          currentPage = Home(callback);
          hasNavBar = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: hasNavBar ? NavBar(callback, navbarIcon): const SizedBox.shrink(),
      floatingActionButton: hasNavBar ? AddButton(callback) : (null),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}