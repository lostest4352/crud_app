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

  UserDatabase get driftDB => context.read<UserDatabase>();

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const ListPage();
                      },
                    ),
                  );
                },
                title: const Text("Go to list page"),
              ),
              Expanded(
                child: StreamProvider<List<UserItem>>.value(
                  value: context.read<UserDatabase>().listenToData(),
                  initialData: const [UserItem(id: 0, name: '', age: 0)],
                  builder: (context, child) {
                    return Consumer<List<UserItem>>(
                      builder: (context, value, child) {
                        if (value.isEmpty) {
                          driftDB.addDefaultData();
                        }
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            debugPrint("length is");
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
                                  subtitle:
                                      Text(value[index].description ?? ""),
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
