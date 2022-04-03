import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DatePicker extends StatefulWidget {

  DatePicker({Key? key, minDate, maxDate, dateType}) : super(key: key);
  final DateTime minDate = DateTime(2000);
  final DateTime maxDate = DateTime.now();
  DateDisplayType dateType = DateDisplayType.month;

  @override
  State<DatePicker> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateDisplayType dateType = DateDisplayType.month;
  int year = 2022;
  int month = 1;

  @override
  void initState() {
    super.initState();
    dateType = widget.dateType;
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 0;
    List<Widget> childrens = [];
    List<Widget> headers = [];
    int i = 1;

    switch (dateType) {
      case DateDisplayType.day:
        crossAxisCount = 7;
        headers.add(Container(margin: const EdgeInsets.only(right: 15), child: Text(DateFormat('MMM', 'FR').format(DateTime(year, month)), style: const TextStyle(color: Colors.white))));
        headers.add(Container(margin: const EdgeInsets.only(right: 15), child: Text("$year", style: const TextStyle(color: Colors.white))));
        childrens.add(const Center(child: Text("lu.", style: TextStyle(color: Colors.white))));
        childrens.add(const Center(child: Text("ma.", style: TextStyle(color: Colors.white))));
        childrens.add(const Center(child: Text("me.", style: TextStyle(color: Colors.white))));
        childrens.add(const Center(child: Text("je.", style: TextStyle(color: Colors.white))));
        childrens.add(const Center(child: Text("ve.", style: TextStyle(color: Colors.white))));
        childrens.add(const Center(child: Text("sa.", style: TextStyle(color: Colors.white))));
        childrens.add(const Center(child: Text("di.", style: TextStyle(color: Colors.white))));

        for(int x = 1; x < DateTime(year, month, 1).weekday; x++){
          childrens.add(Container());
        }

        for(i; i <= DateTime(year, month+1, 0).day; i++){
          childrens.add(Center(child: Text("$i", style: const TextStyle(color: Colors.white))));
        }
        break;
      case DateDisplayType.month:
        crossAxisCount = 4;
        headers.add(Container(margin: const EdgeInsets.only(right: 15), child: Text("$year", style: const TextStyle(color: Colors.white))));
        for (i; i <= 12; i++) {
          int mo = i;
          DateTime dateTime = DateTime(year, mo);
          Widget wid;
          if(dateTime.isAfter(widget.minDate) && dateTime.isBefore(widget.maxDate)){
            wid = TextButton(
              onPressed: () {
                setState(() {
                  month = mo;
                  dateType = DateDisplayType.day;
                });
              },
              child: Text(DateFormat('MMM', 'FR').format(dateTime), style: const TextStyle(color: Colors.white)),
            );
          } else {
            wid = Text(DateFormat('MMM', 'FR').format(dateTime), style: const TextStyle(color: Colors.grey));
          }
          childrens.add(Center(child: wid));
          
        }
        break;
      case DateDisplayType.year:
        break;
      default:
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: headers,
          )
        ),
        Column(
          children: [
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              crossAxisCount: crossAxisCount,
              children: childrens,
            )
          ]
        )
      ],
    );
  }
}

enum DateDisplayType {

  day, 
  month, 
  year 
}