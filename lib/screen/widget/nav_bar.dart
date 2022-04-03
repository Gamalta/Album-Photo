import 'dart:core';
import 'package:flutter/material.dart';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/screen/popup/add_picture.dart';

class NavBar extends StatefulWidget {

  NavBar(this.callback, this.currentIndex, {Key? key}) : super(key: key);
  final Function callback;
  final int currentIndex;
  static int lastIndex = 0;
  final Tween<double> rotationTween = Tween<double>(begin: 180, end: 360);
  final double navBarHeight = 68;
  final double iconSize = 40;
  final double circleSize = 58;

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    animation = Tween<double>(begin: 0.1, end: 1).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => NavBarWidget(widget, animation: animation, controller: controller);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// ignore: must_be_immutable
class NavBarWidget extends AnimatedWidget {
  
  NavBarWidget(this.widget, {Key? key, required this.animation, required this.controller}) : super(key: key, listenable: animation);

  final NavBar widget;
  final Animation<double> animation;
  final AnimationController controller;
  late NavBarItem currentIcon;
  late BuildContext context;
  late double iconsWidth;

  @override
  Widget build(BuildContext context) {

    double navBarWidth = MediaQuery.of(context).size.width;
    iconsWidth = navBarWidth/6;
    Tween<double> placementTween = Tween<double>(begin: (NavBar.lastIndex + 1) * iconsWidth, end: (widget.currentIndex + 1) * iconsWidth);

    final Map icons =  {
      0: NavBarItem(IconButton(icon: const Icon(Icons.image, color: Colors.white), onPressed: () {setHome(); NavBar.lastIndex = widget.currentIndex;}), "Photo", Colors.orange, labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
      1: NavBarItem(const IconButton(icon: Icon(Icons.slideshow, color: Colors.white), onPressed: null), "Vidéo", Colors.blue, labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
      3: NavBarItem(IconButton(icon: const Icon(Icons.person, color: Colors.white), onPressed: () {setProfile(); NavBar.lastIndex = widget.currentIndex;}), "Profil", Colors.blue, labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
      4: NavBarItem(IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {setSettings(); NavBar.lastIndex = widget.currentIndex;}), "Paramètre", Colors.grey, labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
    };

    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container( 
          color: Colors.grey[800],
          height: 68,
          child:
          Stack(
            children: getIcons(icons, widget.currentIndex)
          )
        ),
        Positioned(
          child: Transform(
            transform: Matrix4.identity()..rotateY(widget.rotationTween.evaluate(animation) * 3.1415927 / 180),
            alignment: FractionalOffset.center,
            child: Stack(
                children: [
                  Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[800])),
                  Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, color: currentIcon.circleColor)),
                  Center(child: currentIcon.icon)
                ]
              ),
          ),
          width: widget.circleSize+8,
          height: widget.circleSize+8,
          left: placementTween.evaluate(animation) - (widget.circleSize+8)/2,
          bottom: widget.navBarHeight - (widget.circleSize+8)/2,
        ),
        Positioned(
          width: widget.circleSize+8,
          height: widget.circleSize+8,
          left: placementTween.evaluate(animation) - (widget.circleSize+8)/2,
          bottom: widget.navBarHeight - (widget.circleSize+8) - 10,
          child: Center(child: Text(currentIcon.title, style: currentIcon.labelStyle))
        ),
      ]
    );
  }

  List<Widget> getIcons(Map icons, int currentIcon){
    List<Widget> childrens = [];

    icons.forEach((key, value) {
      key != currentIcon ?
      childrens.add(Positioned(
        child: value.icon,
        left: iconsWidth*(key+1) - widget.iconSize/2,
        top: widget.navBarHeight/2 - widget.iconSize/2
      )) : this.currentIcon = value;
    });

    return childrens;
  }
  
  void addPicture(BuildContext context){
    App.initTags();
    showDialog(context: context, builder: (BuildContext context) => AddPicture(widget.callback));
  }
  void setHome(){
    controller.reset();
    controller.forward();
    widget.callback("HOME");
  }
  void setProfile(){
    controller.reset();
    controller.forward();
    widget.callback("PROFILE");
  }

  void setSettings(){
    controller.reset();
    controller.forward();
    widget.callback("SETTINGS");

  }
}

class NavBarItem {
  IconButton icon;
  String title;
  Color circleColor;
  TextStyle labelStyle;

  NavBarItem(this.icon, this.title, this.circleColor, {this.labelStyle = const TextStyle(fontWeight: FontWeight.bold)});
}