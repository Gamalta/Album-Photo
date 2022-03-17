// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lr_bike_life/utils/picture.dart';
import 'package:lr_bike_life/utils/tag.dart';
import 'package:lr_bike_life/utils/user.dart';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;

class Api {

  final Map<String, String> headers = {};

  Api(String username, String password){

    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    headers['authorization'] = basicAuth;
  }

  static Future<Map<String, dynamic>> getUser(String username, String password) async {

    Uri uri = Uri.https('save.redblock.fr', '/api/user/$username');
    http.Response response = await http.get(uri, headers: {'authorization': 'Basic ' + base64Encode(utf8.encode('$username:$password'))});
    return jsonDecode(response.body);
  }

  Future<Map<String, User>> getUsers() async {

    Map<String, User> users = {};
    var jsonObject = {};
    
    try {

      Uri uri = Uri.https('save.redblock.fr', '/api/users');
      http.Response response = await http.get(uri, headers: headers);
      jsonObject = jsonDecode(response.body);
    
    } catch (e){
      debugPrint("usersss error: " + e.toString());
    }

    for(Map<String, dynamic> json in jsonObject['users']){
      User user = User(json["uuid"], json["username"]);
      users[user.getUniqueId()] = user;
    }
    return users;

  }

  Future<Map<String, Tag>> getTags() async {

    Map<String, Tag> tags = {};
    var jsonObject = {};

    try {

      Uri uri = Uri.http('save.redblock.fr', '/api/tags');
      http.Response response = await http.get(uri, headers: headers);
      jsonObject = jsonDecode(response.body);

    } catch (e){
      debugPrint("tags error: " + e.toString());
    }

    for(Map<String, dynamic> json in jsonObject['tags']){
      Tag tag = Tag.fromJson(json);
      tags[tag.getName()] = tag;
    }

    return tags;
  }

  Future<Picture> getMiniature(String uuid) async {

    Picture picture = Picture(uuid, Uint8List(0), [], 0, -1, User("id", "name"));

    try {
      
      Uri uri = Uri.https('save.redblock.fr', '/api/pictures', {"uuid": "ico:" + uuid});
      http.Response response = await http.get(uri, headers: headers);     
      picture = Picture.fromJson(jsonDecode(response.body));

    } catch(e) {
      debugPrint("error: " + e.toString());
    }
    return picture;
  }

  Future<Picture> getPicture(String uuid) async {

    Picture picture = Picture(uuid, Uint8List(0), [], 0, -1, User("id", "name"));

    try {

      Uri uri = Uri.https('save.redblock.fr', '/api/pictures', {"uuid": "jpg:" + uuid});
      http.Response response = await http.get(uri, headers: headers);        
      picture = Picture.fromJson(jsonDecode(response.body));
    
    } catch(e) {
      debugPrint("error: " + e.toString());
    }
    return picture;
  }

  Future<Map<String, dynamic>> getPicturesArray(Map<String, dynamic> parameters) async {

    Map<String, dynamic> jsonObject = {};

    try {

      Uri uri = Uri.https('save.redblock.fr', '/api/pictures', parameters);
      http.Response response = await http.get(uri, headers: headers);        
      jsonObject = jsonDecode(response.body);

    } catch (e) {
        debugPrint("error: " + e.toString());
    }
    return jsonObject;
  }

  Future sendImage(Map<String, dynamic> json) async {

    try {

      Uri uri = Uri.https('save.redblock.fr', '/api/pictures');
      await http.post(uri, body: json.toString(), headers: headers);

    } catch (e) {
        debugPrint("error: " + e.toString());
    }
  }

  void giveImage(List<Picture> pictures){

    String label;
    List<int>? base64;

    if(pictures.length >1){

      label = "images.zip";
      Archive archive = Archive();
      
      int i = 0;
      for (var picture in pictures) {
        archive.addFile(ArchiveFile("image $i.jpg", picture.getImage().lengthInBytes, picture.getImage()));
        i++;
      }

      base64 = ZipEncoder().encode(archive, level: Deflate.BEST_COMPRESSION, output: OutputStream(byteOrder: LITTLE_ENDIAN));
      
    } else {

      label = "image.jpg";
      base64 = pictures[0].getImage();
    }

    AnchorElement anchor = AnchorElement(href: 'data:application/octet-stream;base64,' + base64Encode(base64!))..target = 'blank'..download = label;
    anchor.click();
    anchor.remove();
  }

  void deleteImage(List<Picture> pictures) async {

    await for(Picture picture in Stream.fromIterable(pictures)) {

      try {

        Uri uri = Uri.https('save.redblock.fr', '/api/pictures', {"uuid": picture.getKey()});
        await http.delete(uri, headers: headers);
      } catch (e) {
        
          debugPrint("error: " + e.toString());
      }
    }
    
  }
}