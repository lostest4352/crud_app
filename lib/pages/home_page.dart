import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp1/database/users_db.dart';
import 'package:testapp1/pages/other_pages/listinsert.dart';
import 'package:testapp1/pages/other_pages/listpage.dart';
import 'package:testapp1/pages/widgets/entry_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDatabase get driftDB => context.read<UserDatabase>();

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
              return const EntryDialog(
                editMode: false,
              );
            },
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: SizedBox(),
            ),
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
              title: const Text("Go to List page"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const ListInsert();
                    },
                  ),
                );
              },
              title: const Text("Go to List Insert Page"),
            ),
          ],
        ),
      ),
      body: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Consumer<List<UserItem>?>(
                  builder: (context, value, child) {
                    if (value == null) {
                      return const Center(
                        child: Text('No data'),
                      );
                    }
                    if (value.isEmpty) {
                      driftDB.addDefaultData();
                    }
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
