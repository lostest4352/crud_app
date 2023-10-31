import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp1/database/users_db.dart';
import 'package:testapp1/pages/listpage.dart';
import 'package:testapp1/pages/widgets/entry_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // UserDatabase driftDB = getIt.get<UserDatabase>();
  // Stream<List<UserItem>> get getDriftData => driftDB.listenToData();

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
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const ListPage();
                    },
                  ));
                },
                title: const Text("Go to list page"),
              ),
              Expanded(
                child: Consumer<List<UserItem>>(
                  // stream: getDriftData,
                  builder: (context, value, child) {
                    // if (!snapshot.hasData) {
                    //   return const Center(
                    //     child: Text("No data yet"),
                    //   );
                    // }

                    return ListView.builder(
                      itemCount: value.length,
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
                                      selectedId: value[index].id,
                                      userItem: value[index],
                                    );
                                  },
                                );
                              },
                              title: Text(value[index].name),
                              subtitle: Text(value[index].description ?? ""),
                              leading: CircleAvatar(
                                child: Text(
                                  value[index].age.toString(),
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
