import 'package:flutter/material.dart';

import 'package:testapp1/isar_dbs/isar_service.dart';
import 'package:testapp1/isar_dbs/user_details_isar.dart';
import 'package:testapp1/main.dart';
import 'package:testapp1/pages/widgets/entry_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IsarService isarService = getIt.get<IsarService>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Stream<List<UserDetails>> get getIsarData => isarService.listenToData();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return EntryDialog(
                nameController: nameController,
                ageController: ageController,
                descriptionController: descriptionController,
                editMode: false,
              );
            },
          );
        },
      ),
      body: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: getIsarData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No data yet"),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return EntryDialog(
                                      nameController: nameController,
                                      ageController: ageController,
                                      descriptionController:
                                          descriptionController,
                                      editMode: true,
                                      selectedId: snapshot.data?[index].id,
                                      userDetails: snapshot.data?[index],
                                    );
                                  },
                                );
                              },
                              title: Text(snapshot.data?[index].name ?? ""),
                              subtitle:
                                  Text(snapshot.data?[index].description ?? ""),
                              leading: CircleAvatar(
                                child: Text(
                                  snapshot.data?[index].age.toString() ?? "N",
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
