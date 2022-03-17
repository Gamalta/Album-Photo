import 'dart:convert';
import 'dart:typed_data';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/utils/tag.dart';
import 'package:lr_bike_life/utils/user.dart';

class Picture {

  Picture(this._key, this._image, this._tags, this._timesTamp, this._index, this._author);
  String _key = "";
  Uint8List _image = Uint8List(0);
  List<Tag> _tags = [];
  int _timesTamp = 0;
  int _index = 0;
  User _author = User('id', 'name');


  Picture.fromJson(Map<String, dynamic> json) {

    _key = json['uuid'];
    _image = Uint8List.fromList(base64.decode(json['image']));
    _timesTamp = json['date'];
    _author = App.getUser(json['author']);

    for(var name in jsonDecode(json['tags'])){
      Tag? tag = App.getTag(name['tag']);
      _tags.add(tag);
    }
  }

  Future<Map<String, dynamic>> toJson() async {

    List<Map<String, dynamic>> jsonTags = [];
    String image = base64.encode(_image);
    String timesTamp = _timesTamp.toString();
    String author = _author.getUniqueId();

    var json = {
        
        '"uuid"': '"$_key"',
        '"image"': '"$image"',
        '"date"': '"$timesTamp"',
        '"author"': '"$author"'
    }; 

    for (var tag in _tags) { 
      jsonTags.add(tag.toJson());
    }
    json['"tags"'] = jsonTags.toString();
    return json;

  }

  String getKey(){
    return _key;
  }

  setKey(String key){
    _key = key;
  }

  Uint8List getImage(){
    return _image;
  }

  setImage(Uint8List image){
    _image = image;
  }

  int getTimesTamp(){
    return _timesTamp;
  }

  setDate(int timesTamp){
    _timesTamp = timesTamp;
  }

  List<Tag> getTags(){
    return _tags;
  }

  setTags(List<Tag> tags){
    _tags = tags;
  }

  addTag(Tag tag){
    if(!getTagsName().contains(tag.getName())){
    _tags.add(tag);
    }
  }

  removeTag(Tag tag){
    _tags.remove(tag);
  }

  int getIndex(){
    return _index;
  }

  setIndex(int index){
    _index = index;
  }

  getTagsName(){
    List<String> tagsName = [];

    for (var tag in _tags) {
      tagsName.add(tag.getName());
    }
    return jsonEncode(tagsName).toString();
  }

  User getAuthor(){
    return _author;
  }

  setAuthor(User author){
    _author = author;
  }
}