import 'package:flutter/material.dart';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/screen/popup/display_picture.dart';
import 'package:lr_bike_life/screen/widget/filter_drawer.dart';
import 'package:lr_bike_life/utils/filter.dart';
import 'package:lr_bike_life/utils/picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lr_bike_life/utils/pre_picture.dart';
import 'package:lr_bike_life/utils/tag.dart';
import 'package:lr_bike_life/utils/user.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Home extends StatefulWidget {

  const Home(this.callback, {Key? key}) : super(key: key);
  final Function callback;

  @override 
  State<Home> createState() => HomeState();
}  

class HomeState extends State<Home> with SingleTickerProviderStateMixin {

  late ScrollController scrollController = ScrollController();
  static late HomeState instance;
  Filter filter = Filter(<Tag>[], <int>[], <User>[]);
  List<PrePicture> prePictures = [];
  List<PrePicture> filtedprePictures = [];
  List<Picture> pictures = [];
  List<Picture> selectedPictures = [];
  bool selectionMode = false;
  StateSetter? stateSetter;
  double sendingPercentage = 0;
  int picturesSize = 0;
  int displayedSize = 0;
  double padding = 20;
  int overImage = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    instance = this;
    scrollController.addListener(() => {
      loadMorePictures(false),
    });
    initAllPictures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FilterDrawer(widget.callback, prePictures, filter),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Album photos"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () { 
                setState(() {
                  selectedPictures.clear();
                  selectionMode = false;
                });
                Scaffold.of(context).openDrawer(); 
                },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [                      
          Checkbox(
            value: selectionMode,
            onChanged: (value) {
              setState(() {
                selectedPictures.clear();
                selectionMode = value!;
              });
            }
          ),
          Center(
            child: Text(selectedPictures.length > 1 ? "sélection d'images" : "sélection d'image" + (selectedPictures.isNotEmpty ? ": ${selectedPictures.length}" : ""))
          ),
          Container(width: 20),
          IconButton(
            onPressed: () => selectedPictures.isNotEmpty ? giveSelectedPictures() : {}, 
            icon: const Icon(Icons.download), 
            mouseCursor: selectedPictures.isEmpty ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
            color: selectedPictures.isEmpty ? Colors.grey : Colors.black
          ),
          IconButton(
            onPressed: () => selectedPictures.isNotEmpty ? removeSelectedPictures() : {},
            icon: const Icon(Icons.delete_outline),
            mouseCursor: selectedPictures.isEmpty ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
            color: selectedPictures.isEmpty ? Colors.grey : Colors.black
            )
        ],
      ),
      body: Container(
        color: Colors.grey[600],
        child: Column(
          children: [
            Expanded(
              child: pictures.isEmpty ? 
                Center(child: Text("Aucune photo disponible", style: GoogleFonts.getFont('Lato', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))) :
                SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      crossAxisCount: getAxisCount(context),
                      children: getPictures(),
                    )
                  ] 
                )
              )
            )
          ]
        )
      )
    );
  }

  void initAllPictures() async {
    debugPrint("initing...");
    prePictures.clear();
    filtedprePictures.clear();
    pictures.clear();
    prePictures = await App.api.getPicturesArray();
    filtedprePictures = prePictures.toList();
    picturesSize = prePictures.length;
    loadMorePictures(true);
  }

  void resetPictures(){
    pictures.clear();
    displayedSize = 0;
    loadMorePictures(true);    
  }

  void loadMorePictures(force) async {
    if(force || (filtedprePictures.length >= displayedSize && scrollController.position.maxScrollExtent <= scrollController.offset && !loading)){
      loading = true;
      await for(PrePicture prePicture in Stream.fromIterable(filtedprePictures.skip(displayedSize).take(30))){
        Picture picture = await App.api.getMiniature(prePicture.getKey());
        setState(() {
          pictures.add(picture);
        });
      }
      displayedSize += 30;
      loading = false;
      }
  }

  List<Widget> getPictures() {

    List<Widget> children = [];
    List<Picture> arrays = pictures.toList();
    int i = 0;
    for(Picture picture in arrays){
      int x = i;
      setState(() {
        children.add(
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            color: Colors.grey[700],
            padding: EdgeInsets.all(overImage == x && !selectionMode ? padding : 20),
            child: InkWell(      
              onTap: () => setState(() {
                selectionMode ? selectedPictures.contains(picture) ? selectedPictures.remove(picture) : selectedPictures.add(picture) : showDialog(context: context, builder: (BuildContext context) => DisplayPicture(widget.callback, picture), barrierColor: Colors.transparent);
              }),
              onHover: (value){
                  setState(() {
                  padding = value ? 0 : 20;
                  overImage = x;
                  });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.memory(picture.getImage()).image, 
                    scale: 0.1, 
                    fit: BoxFit.contain,
                    colorFilter: selectedPictures.contains(picture) ? ColorFilter.mode(Colors.blue.withOpacity(0.5), BlendMode.srcOver) : const ColorFilter.mode(Colors.transparent, BlendMode.color)
                  )
                )
              )
            )
          )
        );
      });
      i++;
    }
    return children;
  }

  giveSelectedPictures() async{
    List<Picture> pictures = [];
    int size = selectedPictures.length;
    sendingPercentage = 0;
    int index = 0;
    downloadingPopUp();
    
    await for(Picture miniature in Stream.fromIterable(selectedPictures)) {
      pictures.add(await App.api.getPicture(miniature.getKey()));
      index++;
      stateSetter!(() {
          sendingPercentage = index/size;
      });
    }
    App.api.giveImage(pictures);
    selectedPictures.clear();
    Navigator.of(context).pop();
  }

  downloadingPopUp(){

    setState(() {
      showDialog(context: context, builder: (BuildContext context) =>
        AlertDialog(content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            stateSetter = setState;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Récupération des photos', style: GoogleFonts.getFont( 'Lato', fontWeight: FontWeight.bold, fontSize: 20)),
                Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15), child: LinearPercentIndicator(percent: sendingPercentage, progressColor: Colors.green)),
              ]
            );
          }
        )
      )
    );
  });
  }

  int getAxisCount(context){
    
    double screenSize = MediaQuery.of(context).size.width;
    double kMobileBreakpoint = 576;
    double kTabletBreakpoint = 1024;
    double kDesktopBreakPoint = 1366;
    
    if (screenSize <= kMobileBreakpoint) {
      return 2;
    } else if (screenSize > kMobileBreakpoint && screenSize <= kTabletBreakpoint) {
      return 3;
    } else if (screenSize > kTabletBreakpoint && screenSize <= kDesktopBreakPoint) {
      return 4;
    } else {
      return 6;
    }
  }

  void removeSelectedPictures() {
    
    App.api.deleteImage(selectedPictures.toList());

    setState(() {
      for(Picture picture in selectedPictures.toList()){
          pictures.remove(picture);
          selectedPictures.remove(picture);
      }
    selectionMode = false;
    });
    
  }

  void removePicture(String uuid){
    setState(() {
      pictures.removeWhere((element) => element.getKey() == uuid);
    });
  }
}