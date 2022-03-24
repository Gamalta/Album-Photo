import 'package:flutter/material.dart';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/screen/tab/home.dart';
import 'package:lr_bike_life/utils/filter.dart';
import 'package:lr_bike_life/utils/pre_picture.dart';
import 'package:lr_bike_life/utils/tag.dart';
import 'package:lr_bike_life/utils/user.dart';

// ignore: must_be_immutable
class FilterDrawer extends StatefulWidget {

  FilterDrawer(this.callback, this.pictures, this.filter, {Key? key}) : super(key: key);
  final Filter filter;
  final Function callback;
  List<PrePicture> pictures;

  @override
  FilterDrawerState createState() => FilterDrawerState();
}

class FilterDrawerState extends State<FilterDrawer> {

  bool tag = false;
  bool date = false;
  bool author = false;
  List<PrePicture> newPrePictures = [];

  @override
  void initState() {
    super.initState();
    newPrePictures = widget.pictures.toList();    
  }

  @override
  void dispose() {
    super.dispose();
    HomeState.instance.filter = widget.filter;
    purge(true, true, true);
    HomeState.instance.filtedprePictures = newPrePictures;
    HomeState.instance.resetPictures();
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
                  title: Text((widget.filter.getTags().length > 1 ? "Tags " : "Tag ") + (widget.filter.getTags().isNotEmpty ? widget.filter.getTags().length.toString() : ""), style: const TextStyle(color: Colors.white)),
                  trailing: getIcon(tag),
                  onTap: () => {
                    setState(() {
                    tag = !tag;
                    })
                  }
                ),
                tag ? getTag() : Container(),
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
                  title: Text((widget.filter.getUsers().length > 1 ? "photographes " : "photographe ") + (widget.filter.getUsers().isNotEmpty ? widget.filter.getUsers().length.toString() : ""), style: const TextStyle(color: Colors.white)),
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

  void purge(bool t, bool d, bool a){
    newPrePictures = widget.pictures.toList();  
    for(PrePicture picture in newPrePictures.toList()){

      if(t && widget.filter.getTags().isNotEmpty){
        bool removing = true;
        for(Tag tag in picture.getTags()){
          if(widget.filter.getTags().contains(tag)){
            removing = false;
            break;
          }
        }
        if(removing){
          newPrePictures.remove(picture);
        }
      }
      if(a && (widget.filter.getUsers().isNotEmpty && !widget.filter.getUsers().contains(picture.getAuthor()))){
        newPrePictures.remove(picture);
      }
    }
  }

  Widget getIcon(bool boo){
    return boo ? const Icon(Icons.expand_less, color: Colors.white) : const Icon(Icons.expand_more, color: Colors.white);
  }

  Widget getAuthor(){
    purge(true, true, false);
    List<Widget> children = [];
    int index = 0;

    for(User user in App.getUsers().values){
      int pictureSize = 0;

      for(PrePicture picture in newPrePictures){
        if(user == picture.getAuthor()){
          pictureSize++;
        }
      }

      children.add(MouseRegion(
        cursor: pictureSize == 0 ? SystemMouseCursors.forbidden : SystemMouseCursors.click, 
        child: GestureDetector(
          onTap: () => {
            if(pictureSize != 0){
              setState(() => {
                widget.filter.getUsers().contains(user) ? widget.filter.getUsers().remove(user) : widget.filter.getUsers().add(user),
                purge(true, true, false)
              })
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: widget.filter.getUsers().contains(user) ? Colors.grey[600] : Colors.grey[700],
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
                  value: widget.filter.getUsers().contains(user),
                  onChanged: (value) => setState(() => {
                    widget.filter.getUsers().contains(user) ? widget.filter.getUsers().remove(user) : widget.filter.getUsers().add(user),
                    purge(true, true, false)
                  })
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

  Widget getTag(){
    purge(false, true, true);
    List<Widget> children = [];
    int index = 0;

    for(Tag tag in App.getTags().values){
      int pictureSize = 0;

      for(PrePicture picture in newPrePictures){  
        if(picture.getTags().contains(tag)){
          pictureSize++;
        }
      }

      children.add(MouseRegion(
        cursor: pictureSize == 0 ? SystemMouseCursors.forbidden : SystemMouseCursors.click, 
        child: GestureDetector(
          onTap: () => {
            if(pictureSize != 0){
              setState(() => {
                widget.filter.getTags().contains(tag) ? widget.filter.getTags().remove(tag) : widget.filter.getTags().add(tag),
                purge(false, true, true)
              })
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: widget.filter.getTags().contains(tag) ? Colors.grey[600] : Colors.grey[700],
              border: index == 0 ? const Border() : const Border(top: BorderSide(color: Colors.black))
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //user profil picture
                Row(
                  children: [
                    Container(height: 15, width: 15, decoration: BoxDecoration(shape: BoxShape.circle, color: tag.getColor())),
                    Container(width: 10),
                    Text(tag.getName(), style: const TextStyle(color: Colors.white)),
                    Text(" ($pictureSize)", style: TextStyle(color: Colors.grey[400]))
                  ],
                ),
                pictureSize != 0 ? Checkbox(
                  activeColor: Colors.blue,
                  value: widget.filter.getTags().contains(tag),
                  onChanged: (value) => setState(() => {
                    widget.filter.getTags().contains(tag) ? widget.filter.getTags().remove(tag) : widget.filter.getTags().add(tag),
                    purge(false, true, true)
                  })
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