import 'dart:typed_data';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/screen/tab/home.dart';
import 'package:lr_bike_life/utils/picture.dart';
import 'package:lr_bike_life/utils/tag.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:uuid/uuid.dart';

class AddPicture extends StatefulWidget {

  const AddPicture(this.callback, {Key? key}) : super(key: key);
  final Function callback;

  @override
  State<AddPicture> createState() => AddPictureState();
}  

class AddPictureState extends State<AddPicture> {

  final dateRangePickerController = DateRangePickerController();
  final ImagePickerWeb imagePickerWeb = ImagePickerWeb();
  final TextEditingController searchTextEditingController = TextEditingController();
  String get searchText => searchTextEditingController.text.trim();
  Map<int, Picture>? prePicture = {};
  int? selectedPicture;
  StateSetter? setStater;
  double sendingPercentage = 0;
  bool breaked = false;

  @override
  Widget build(BuildContext context) {

    final imageScrollController = ScrollController();

    return Dialog(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            children: [IconButton(onPressed:() => Navigator.of(context).pop(), icon : const Icon(Icons.arrow_back))],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                                decoration: BoxDecoration(
                                  color:Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(prePicture!.length <= 1 ? "Photo: " : "Photos: ", style: GoogleFonts.getFont('Lato', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                              Text(prePicture!.length.toString(), style: GoogleFonts.getFont('Lato', color: Colors.black54, fontSize: 13))
                                            ]
                                          ),
                                          IconButton(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                            constraints: const BoxConstraints(),
                                            iconSize: 18,
                                            onPressed: () => selectImage(), 
                                            icon: const Icon(Icons.add),
                                          )
                                        ]
                                      )
                                    ),
                                    Container(
                                      margin: const EdgeInsetsDirectional.fromSTEB(10, 5, 5, 0),
                                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
                                    ),
                                    Scrollbar(
                                      isAlwaysShown: true,
                                      controller: imageScrollController,
                                      child: SingleChildScrollView(
                                        controller: imageScrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: imageSelector()
                                      )
                                    )
                                  ]
                                )
                              )
                            )
                          ]
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                constraints: const BoxConstraints(minHeight: 75),
                                margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                                decoration: BoxDecoration(
                                  color:Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(selectedPicture != null && prePicture![selectedPicture]!.getTags().length <= 1 ? "Tag: " : "Tags: ", style: GoogleFonts.getFont('Lato', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                              Text(selectedPicture != null ? prePicture![selectedPicture]!.getTags().length.toString() : "", style: GoogleFonts.getFont('Lato', color: Colors.black54, fontSize: 13))
                                            ]
                                          ),
                                          selectedPicture != null ?
                                          Container(
                                            width: 130,
                                            padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                            margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                            decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                              border: Border.all(color: Colors.grey.shade500, width: 1),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    onChanged: (value) => setState(() => searchText  == value),
                                                    controller: searchTextEditingController,
                                                    decoration: const InputDecoration.collapsed(
                                                      hintText: 'Rechercher un tag', 
                                                      hintStyle: TextStyle(color: Colors.grey),
                                                    ),
                                                    style: const TextStyle(fontSize: 13.0),
                                                    textInputAction: TextInputAction.search,  
                                                  )
                                                ),
                                                searchTextEditingController.text != "" ? InkWell(
                                                  child: Icon(Icons.clear, color: Colors.grey.shade700, size: 15),
                                                  onTap: () => setState(() => searchTextEditingController.clear())
                                                ) : Icon(Icons.search, color: Colors.grey.shade700, size: 15),
                                              ]
                                            )
                                          ) : Container()
                                        ]
                                      )
                                    ),
                                    Container(
                                      margin: const EdgeInsetsDirectional.fromSTEB(10, 5, 5, 0),
                                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
                                    ),
                                    selectedPicture == null ? Container() : 
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: buildTags(getFiltedTags(App.getTags()))
                                    )
                                  ]
                                )
                              ) 
                            )
                          ]
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                constraints: const BoxConstraints(minHeight: 75),
                                margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                                decoration: BoxDecoration(
                                  color:Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Date", style: GoogleFonts.getFont('Lato', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                              ]
                                          )
                                        ]
                                      )
                                    ),
                                    Container(
                                      margin: const EdgeInsetsDirectional.fromSTEB(10, 5, 5, 0),
                                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
                                    ),
                                    selectedPicture != null ?
                                    SfDateRangePicker(
                                      controller: dateRangePickerController,
                                      initialSelectedDate: DateTime.fromMillisecondsSinceEpoch(prePicture![selectedPicture]!.getTimesTamp()),
                                      initialDisplayDate: DateTime.fromMillisecondsSinceEpoch(prePicture![selectedPicture]!.getTimesTamp()),
                                      todayHighlightColor: Colors.blue,
                                      selectionColor: Colors.blue,
                                      showNavigationArrow: true,
                                      onSelectionChanged: _onSelectionChanged,
                                      maxDate: DateTime.now(),
                                      monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1)
                                    ) : 
                                    Container()
                                  ]
                                )
                              )
                            )
                          ]
                        ),
                      ]
                    ),
                    Column( //add images
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => sendPicture(),
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                          child: Text('Ajouter', style: GoogleFonts.getFont( 'Lato', color: Colors.white, fontSize: 18))
                        )
                      ]
                    )
                  ]
                )
              )
            )
          )
        ]
      )
    );
  }
  
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs dateTime) {

    setState(() {
      prePicture![selectedPicture]!.setDate(dateTime.value.millisecondsSinceEpoch);
    });
}

  Widget imageSelector(){
    Widget widget = const Text("not initialized");

    setState(() {

      if(prePicture!.isNotEmpty){

        List<Widget> children = [];

        prePicture!.forEach((key, value) {
          Picture? picture = value;
          children.add(
            IconButton(
              iconSize: 75,
              onPressed: () => setState(() {selectedPicture = picture.getIndex(); dateRangePickerController.selectedDate = DateTime.fromMillisecondsSinceEpoch(prePicture![selectedPicture]!.getTimesTamp());}),
              icon: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.memory(picture.getImage(),
                      fit: BoxFit.cover, 
                      width: 100, 
                      height: 100,
                      color: Colors.blue.withOpacity(selectedPicture == picture.getIndex() ? 0.5 : 0),
                      colorBlendMode: BlendMode.color
                    )
                  ),
                  (selectedPicture == picture.getIndex()) ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2)
                    ),
                    child: 
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close), 
                          onPressed: () => setState(() {prePicture!.remove(selectedPicture); selectedPicture = null; })
                        ),
                      ),
                  ) : Container(
                  )
                ]
              )        
            )
          );
        });

        widget = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children
        );

      } else {
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => selectImage(), 
              icon: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset('../assets/images/default_picture.png', fit: BoxFit.cover, width: 100 , height: 100)
            ),
              iconSize: 75
            )
          ]
        );
      }
    });
  return widget;
  }

  List<Tag> getFiltedTags(Map<String, Tag> tags){
    List<Tag> after = [];

    for (String name in tags.keys) {

      if(name.toLowerCase().trim().contains(searchText.toLowerCase())){
        Tag? tag = tags[name];
        after.add(tag!);
      }
    }

    return after;
  }

  Widget buildTags(List<Tag> tags) {

    List<Widget> childrens = [];

    for (Tag tag in tags) {
      childrens.add(
        Container(
          padding: const EdgeInsetsDirectional.all(3),
          margin: const EdgeInsetsDirectional.all(2.5),
          decoration: BoxDecoration(
            color: prePicture![selectedPicture]!.getTagsName().contains(tag.getName()) ? tag.getColor() : tag.getColor().withOpacity(0.3),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            border: Border.all(color: tag.getColor(), width: 2),
          ),
          child: TextButton(
            style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () => setState(() => {

              if(prePicture![selectedPicture]!.getTagsName().contains(tag.getName())){

                prePicture![selectedPicture]!.removeTag(tag)

              } else {

                prePicture![selectedPicture]!.addTag(tag),

              }
            }), 
            child: prePicture![selectedPicture]!.getTagsName().contains(tag.getName()) ? 
            Text(tag.getName(), style: GoogleFonts.getFont('Lato', color: tag.getColor().computeLuminance() > 0.5 ? Colors.black : Colors.white, fontSize: 15)) :
            Text(tag.getName(), style: GoogleFonts.getFont('Lato', color: Colors.black, fontSize: 15))
          )
        )
      );
    }

    return Wrap(
      alignment: WrapAlignment.start,
      children: childrens
      );
  }

  void selectImage() async {

    List<Uint8List>? selectedImages = await ImagePickerWeb.getMultiImagesAsBytes();

    if(selectedImages !=null && selectedImages.isNotEmpty){

      int index = prePicture!.length;

      setState(() {

        for (Uint8List image in selectedImages) { 
          Picture picture = Picture(const Uuid().v4(), image, [], DateTime.now().millisecondsSinceEpoch, index, App.getUser(App.getAccount().getUniqueId()));
          prePicture![index] = picture;
          index++;
        }
      });
    }
  }

  sendPicture() async {

    if(prePicture != null && prePicture!.isNotEmpty){

      int size = prePicture!.length;
      sendingPercentage = 0;
      int index = 0;

      setState(() {
        sendingPopUp();
      });

      await for (Picture picture in Stream.fromIterable(prePicture!.values)) {

        if(breaked){
          break;
        }

        await App.api.sendImage(await picture.toJson());
        HomeState.instance.addPicture(picture);
        index++;

        setStater!(() {
          sendingPercentage = index/size;
        });
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      HomeState.instance.picturesId.clear();
      HomeState.instance.pictures.clear();
      HomeState.instance.initAllPictures();
    }
  }

  sendingPopUp(){
    setState(() {
      showDialog(context: context, builder: (BuildContext context) =>
        AlertDialog(content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            setStater = setState;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Envoie des photos', style: GoogleFonts.getFont( 'Lato', fontWeight: FontWeight.bold, fontSize: 20)),
                Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15), child: LinearPercentIndicator(percent: sendingPercentage, progressColor: Colors.green)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () => {
                    breaked = true, 
                    Navigator.of(context).pop()
                  },
                  child: Text('Arrêter', style: GoogleFonts.getFont( 'Lato', color: Colors.black, fontSize: 18))
                )
              ]
            );
          }
        )
      )
    );
  });
  }
} 