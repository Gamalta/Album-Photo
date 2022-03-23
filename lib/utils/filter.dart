
import 'package:lr_bike_life/utils/tag.dart';
import 'package:lr_bike_life/utils/user.dart';

class Filter {

  List<Tag> _tags;
  List<int> _dates;
  List<User> _authors;

  Filter(this._tags, this._dates ,this._authors);

  List<Tag> getTags(){
    return _tags;
  }

  void setTags(List<Tag> tags){
    _tags = tags;
  }

  List<int> getDates(){
    return _dates;
  }

  void setDates(List<int> dates){
    _dates = dates;
  }

  List<User> getUsers(){
    return _authors;
  }

  void setUsers(List<User> authors){
    _authors = authors;
  }
  
}