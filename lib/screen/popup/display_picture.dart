import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/screen/tab/home.dart';
import 'package:lr_bike_life/utils/picture.dart';
import 'package:intl/intl.dart';
import 'package:lr_bike_life/utils/tag.dart';

class DisplayPicture extends StatefulWidget {
  
  const DisplayPicture(this.callback, this.miniature, {Key? key}) : super(key: key);
  final Function callback;
  final Picture miniature;

  @override
  State<DisplayPicture> createState() => DisplayPictureState();
}

class DisplayPictureState extends State<DisplayPicture> {
  late Picture picture;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    getPicture();
  }

  @override
  Widget build(BuildContext context) {
    return loaded ? Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8, maxHeight: MediaQuery.of(context).size.height * 0.8),
        color: Colors.grey[700],
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Container(
              color: Colors.grey[800],
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back), color: Colors.white),
                  Row(
                    children: [
                      IconButton(onPressed: () => App.api.giveImage([picture]), icon: const Icon(Icons.download), color: Colors.white),
                      IconButton(onPressed: () => deleteImage([picture], context), icon: const Icon(Icons.delete_outline), color: Colors.white)
                    ]
                  )
                ]
              )
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Center(child: Image.memory(picture.getImage(), fit: BoxFit.contain)
                      )
                    )
                  ),
                  hasSize(context) ? getRowDescription(picture) : Container()
                ]
              )
            ),
            hasSize(context) ? Container() : getColumnDescription(picture)
          ]
        )
      )
    )
    : Center(child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey[700],
        child: const CircularProgressIndicator(color: Colors.amber)
      )
    );
  }

  deleteImage(List<Picture> pictures, BuildContext context){
    for(Picture picture in pictures){
      HomeState.instance.removePicture(picture.getKey());
    }
    App.api.deleteImage(pictures);
    Navigator.of(context).pop();
    
  }

  getPicture() async {
    picture = await App.api.getPicture(widget.miniature.getKey());
    setState(() {
      loaded = true;
    });
  }

  hasSize(BuildContext context) {
    return MediaQuery.of(context).size.width > 1024;
  }

  Widget getColumnDescription(Picture picture) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.grey[800],
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(picture.getTags().length > 1 ? "tags:   " : "tag:   ", style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 15)),
                  IconButton(
                    padding: const EdgeInsetsDirectional.all(0), 
                    constraints: const BoxConstraints(), 
                    color: Colors.white54,
                    iconSize: 18, 
                    onPressed: () => editTags(picture, context),
                    icon: const Icon(Icons.edit),
                  )
                ]
              ),
              Wrap(children: buildTags(picture.getTags())),
            ]
          ),
          Container(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Photographié le: ',
                  style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 15),
                  children: [
                    TextSpan(
                      text: DateFormat('EEEE dd MMMM yyyy', 'FR').format(DateTime.fromMillisecondsSinceEpoch(picture.getTimesTamp() * 1000)),
                      style: const TextStyle(color: Colors.white70)
                    ) 
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: 'par: ',
                  style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 15),
                  children: [
                    TextSpan(
                      text: picture.getAuthor().getName(),
                      style: const TextStyle(color: Colors.white70)
                    ) 
                  ]
                )
              )
            ]
          )
        ]
      )
    );
  }

  Widget getRowDescription(Picture picture) {
    return Container(
      padding: const EdgeInsets.all(15),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.25),
      color: Colors.grey[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("tags:   ", style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 15)),
                  IconButton(
                    padding: const EdgeInsetsDirectional.all(0), 
                    constraints: const BoxConstraints(), 
                    color: Colors.white54,
                    iconSize: 18, 
                    onPressed: () => editTags(picture, context),
                    icon: const Icon(Icons.edit),
                  )
                ]
              ),
              Wrap(children: buildTags(picture.getTags())),
            ]
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Ajouté le: ',
                  style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 15),
                  children: [
                    TextSpan(
                      text: DateFormat('EEEE dd MMMM yyyy', 'FR').format(DateTime.fromMillisecondsSinceEpoch(picture.getTimesTamp() * 1000)),
                      style: const TextStyle(color: Colors.white70)
                    ) 
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: 'par: ',
                  style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 15),
                  children: [
                    TextSpan(
                      text: picture.getAuthor().getName(),
                      style: const TextStyle(color: Colors.white70)
                    ) 
                  ]
                )
              )
            ],
          )
        ]
      )
    );
  }

  List<Widget> buildTags(List<Tag> tags) {
    List<Widget> childrens = [];

    for (Tag tag in picture.getTags()) {
      childrens.add(Container(
          padding: const EdgeInsetsDirectional.all(3),
          margin: const EdgeInsetsDirectional.all(2.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(shape: BoxShape.circle, color: tag.getColor())
              ),
              Text("  " + tag.getName(), style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 15))
            ],
          )
        )
      );
    }

    return childrens;
  }

  editTags(Picture picture, BuildContext context){

  }
}
