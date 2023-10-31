// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final dataSet = [
    {
      "time": "2020-06-16T10:31:12.000Z",
      "message": "Message1",
    },
    {
      "time": "2020-06-16T10:29:35.000Z",
      "message": "Message2",
    },
    {
      "time": "2020-06-15T09:41:18.000Z",
      "message": "Message3",
    },
    {
      "time": "2020-04-07T09:41:18.000Z",
      "message": "Message4",
    },
    {
      "time": "2020-05-25T09:41:18.000Z",
      "message": "Message5",
    },
  ];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("List page"),
  //     ),
  //     body: () {
  //       dataSet.sort((a, b) => b['time']!.compareTo(a['time']!));

  //       final groupByMonth =
  //           groupBy(dataSet, (obj) => obj['time']?.substring(0, 7));

  //       for (final month in groupByMonth.keys) {
  //         return Column(
  //           children: [
  //             ListTile(
  //               title: Text(month ?? ""),
  //             ),
  //           ],
  //         );
  //       }
  //     }(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    dataSet.sort((a, b) => b['time']!.compareTo(a['time']!));

    final groupByMonth =
        groupBy(dataSet, (obj) => obj['time']?.substring(0, 7));

    return Scaffold(
      appBar: AppBar(
        title: Text('Grouped Data'),
      ),
      body: ListView(
        children: groupByMonth.keys.map((month) {
          final monthGroupedList = groupByMonth[month];
          final groupByDay = groupBy(
              monthGroupedList!, (obj) => obj['time']?.substring(0, 10));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$month:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupByDay.keys.map((day) {
                  final dayGroupedlist = groupByDay[day];

                  return Column(
                    children: [
                      Text('$day:'),
                      Column(
                        children: dayGroupedlist!.map((listItem) {
                          return Text(
                              '${listItem["time"]}, ${listItem["message"]}');
                        }).toList(),
                      ),
                      Divider(
                        height: 1,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
