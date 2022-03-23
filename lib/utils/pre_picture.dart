import 'dart:convert';
import 'package:lr_bike_life/main.dart';
import 'package:lr_bike_life/utils/tag.dart';
import 'package:lr_bike_life/utils/user.dart';

class PrePicture {

  PrePicture(this._key, this._tags, this._timesTamp, this._index, this._author);
  String _key = "";
  List<Tag> _tags = [];
  int _timesTamp = 0;
  int _index = 0;
  User _author = User('id', 'name');


  PrePicture.fromJson(Map<String, dynamic> json) {
    
    _key = json['uuid'];
    _timesTamp = json['date'];
    _author = App.getUser(json['author']);

    if(json['tags'] != null){
      for(var name in jsonDecode(json['tags'])){
        Tag? tag = App.getTag(name['tag']);
        _tags.add(tag);
      }
    }
  }

  Map<String, dynamic> toJson() {

    List<Map<String, dynamic>> jsonTags = [];
    String timesTamp = _timesTamp.toString();
    String author = _author.getUniqueId();

    var json = {
        
        '"uuid"': '"$_key"',
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