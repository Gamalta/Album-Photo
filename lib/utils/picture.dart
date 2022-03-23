import 'dart:convert';
import 'dart:typed_data';
import 'package:lr_bike_life/utils/pre_picture.dart';

class Picture extends PrePicture{

  Uint8List _image;

  Picture(_key, this._image, _tags, _timesTamp, _index, _author) : super(_key, _tags, _timesTamp, _index, _author);

  Picture.fromJson(Map<String, dynamic> json) 
    : _image = Uint8List.fromList(base64.decode(json['image'])),
     super.fromJson(json);
  

  @override
  Map<String, dynamic> toJson() {
    
    String image = base64.encode(_image);
    var json = super.toJson();
    json['"image"'] = '"$image"';
    return json;
  }

  Uint8List getImage(){
    return _image;
  }

  setImage(Uint8List image){
    _image = image;
  }
}