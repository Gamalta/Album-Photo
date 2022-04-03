import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {

  DatePicker({Key? key, minDate, maxDate, dateType}) : super(key: key);
  DateTime minDate = DateTime(2000);
  DateTime maxDate = DateTime.now();
  DateDisplayType dateType = DateDisplayType.month;
  int month = 1;
  int year = 2000;
  String header = "mois";

  List<String> months = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Decembre'
  ]; 

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 0;
    List<Widget> childrens = [];
    int i = 0;

    switch (dateType) {
      case DateDisplayType.day:
        crossAxisCount = 7;
        break;
      case DateDisplayType.month:
        crossAxisCount = 4;
        for (i; i < 12; i++) {
          DateFormat month = DateFormat();
          childrens.add(Center(child: Text(months[i])));
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(header),
            Row(
              children: [
                IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.keyboard_arrow_left)),
                IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.keyboard_arrow_right))
              ],
            )
          ],
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