import 'package:flutter/material.dart';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/utils/picture.dart';
import 'package:lr_bike_life/utils/user.dart';

class Filter extends StatefulWidget {

  const Filter(this.callback, this.pictures, {Key? key}) : super(key: key);
  final Function callback;
  final List<Picture> pictures;

  @override
  FilterState createState() => FilterState();
}

class FilterState extends State<Filter> {

  List<Picture> filtedPictures = [];
  bool tag = false;
  bool date = false;
  List<User> authors = [];
  bool author = false;

  @override
  void initState() {
    super.initState();
    filtedPictures = widget.pictures.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[800],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Filtres',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(fit: BoxFit.cover, image: AssetImage('../assets/images/icon.ico'))
            )
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.tag, color: Colors.white),
                  title: const Text('tag', style: TextStyle(color: Colors.white)),
                  trailing: getIcon(tag),
                  onTap: () => {
                    setState(() {
                    tag = !tag;
                    })
                  }
                ),
                tag ? Container(height: 100, color: Colors.red): Container(),
                ListTile(
                  leading: const Icon(Icons.date_range, color: Colors.white),
                  title: const Text('date', style: TextStyle(color: Colors.white)),
                  trailing: getIcon(date),
                  onTap: () => {
                    setState(() {
                    date = !date;
                    })
                  }
                ),
                date ? Container(height: 100, color: Colors.blue): Container(),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: Text((authors.isNotEmpty && authors.length > 1 ? "photographes" : "photographe") + (authors.isNotEmpty ? " ${authors.length}" : ""), style: const TextStyle(color: Colors.white)),
                  trailing: getIcon(author),
                  onTap: () => {
                    setState(() {
                    author = !author;
                    })
                  }
                ),
                author ? getAuthor() : Container(),
              ] 
            )
          )
        ]
      )
    );
  }

  Widget getIcon(bool boo){
    return boo ? const Icon(Icons.expand_less, color: Colors.white) : const Icon(Icons.expand_more, color: Colors.white);
  }

  Widget getAuthor(){

    List<Widget> children = [];
    List<Picture> authorPictures = filtedPictures.toList();
    int index = 0;

    for(User user in App.getUsers().values){
      int pictureSize = 0;

      for(Picture picture in authorPictures.toList()){
        if(user == picture.getAuthor()){
          pictureSize++;
          authorPictures.remove(picture);
        }
      }

      children.add(MouseRegion(
        cursor: pictureSize == 0 ? SystemMouseCursors.forbidden : SystemMouseCursors.click, 
        child: GestureDetector(
          onTap: () => {
            if(pictureSize != 0){
              setState(() => authors.contains(user) ? authors.remove(user) : authors.add(user))
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: authors.contains(user) ? Colors.grey[600] : Colors.grey[700],
              border: index == 0 ? const Border() : const Border(top: BorderSide(color: Colors.black))
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //user profil picture
                Row(
                  children: [
                    Text(user.getName(), style: const TextStyle(color: Colors.white)),
                    Text(" ($pictureSize)", style: TextStyle(color: Colors.grey[400]))
                  ],
                ),
                pictureSize != 0 ? Checkbox(
                  activeColor: Colors.blue,
                  value: authors.contains(user),
                  onChanged: (value) => setState(() => authors.contains(user) ? authors.remove(user) : authors.add(user))
                ) : Container()
              ]
            )
          )
        )
      ));
      index++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}