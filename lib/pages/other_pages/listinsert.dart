import 'package:flutter/material.dart';

class ListInsert extends StatefulWidget {
  const ListInsert({super.key});

  @override
  State<ListInsert> createState() => _ListInsertState();
}

class _ListInsertState extends State<ListInsert> {
  final items = List.generate(30, (index) {
    return "Item ${index + 1}";
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Test"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (index != 0 && (index) % 5 == 0) {
              return Column(
                children: [
                  const Text("Inserted text here"),
                  Text(items[index]),
                ],
              );
            } else {
              return Column(
                children: [
                  Text(items[index]),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
