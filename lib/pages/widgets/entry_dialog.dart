import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testapp1/database/users_db.dart';
import 'package:testapp1/pages/widgets/popup_textfield.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog({
    Key? key,
    required this.editMode,
    this.selectedId,
    this.userItem,
  }) : super(key: key);

  final bool editMode;
  final int? selectedId;
  final UserItem? userItem;

  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  // UserDatabase driftDB = getIt.get<UserDatabase>();
  UserDatabase get driftDB => context.read<UserDatabase>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userItem?.name ?? "";
    ageController.text = widget.userItem?.age.toString() ?? "";
    descriptionController.text = widget.userItem?.description ?? "";
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
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: SizedBox(
        height: 250,
        child: ListView(
          children: [
            () {
              if (widget.editMode == true) {
                return Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 20,
                    onPressed: () {
                      if (widget.userItem != null) {
                        driftDB.deleteData(widget.userItem!.id);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              } else {
                return const SizedBox(
                  height: 30,
                );
              }
            }(),
            PopupTextField(
              textEditingController: nameController,
              labelText: "Enter your name",
            ),
            PopupTextField(
              textEditingController: ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              labelText: "Enter your age",
            ),
            PopupTextField(
              textEditingController: descriptionController,
              labelText: "Give description",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (nameController.text.trim() != "" &&
                          ageController.text.trim() != "") {
                        if (widget.editMode == false) {
                          driftDB.addData(
                              nameController.text.trim(),
                              int.parse(ageController.text.trim()),
                              descriptionController.text.trim());
                          Navigator.pop(context);
                        } else {
                          final newUserItem = UserItemsCompanion(
                            id: Value.ofNullable(widget.selectedId),
                            name: Value.ofNullable(
                              nameController.text.trim(),
                            ),
                            age: Value.ofNullable(
                                int.parse(ageController.text.trim())),
                            description: Value.ofNullable(
                                descriptionController.text.trim()),
                          );
                          driftDB.updateData(newUserItem);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Save"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
