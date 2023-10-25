import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testapp1/database/drift_service.dart';
import 'package:testapp1/database/users_db.dart';
import 'package:testapp1/main.dart';
import 'package:testapp1/pages/widgets/popup_textfield.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog({
    Key? key,
    required this.nameController,
    required this.ageController,
    required this.descriptionController,
    required this.editMode,
    this.selectedId,
    this.userItem,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController descriptionController;
  final bool editMode;
  final int? selectedId;
  final UserItem? userItem;

  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  @override
  void initState() {
    super.initState();
    widget.nameController.text = widget.userItem?.name ?? "";
    widget.ageController.text = widget.userItem?.age.toString() ?? "";
    widget.descriptionController.text = widget.userItem?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    DriftService driftService = getIt.get<DriftService>();
    Future<List<UserItem>> getDriftData = driftService.userDatabase.getData();
    return FutureBuilder(
      future: getDriftData,
      builder: (context, snapshot) {
        return Dialog(
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
                            driftService.userDatabase
                                .deleteData(widget.userItem!.id);
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
                  textEditingController: widget.nameController,
                  labelText: "Enter your name",
                ),
                PopupTextField(
                  textEditingController: widget.ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  labelText: "Enter your age",
                ),
                PopupTextField(
                  textEditingController: widget.descriptionController,
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
                          if (widget.nameController.text.trim() != "" &&
                              widget.ageController.text.trim() != "") {
                            if (widget.editMode == false) {
                              driftService.userDatabase.saveData(
                                  widget.nameController.text.trim(),
                                  int.parse(widget.ageController.text.trim()),
                                  widget.descriptionController.text.trim());

                              Navigator.pop(context);
                            } else {
                              final newUserItem = UserItemsCompanion(
                                id: Value.ofNullable(widget.selectedId),
                                name: Value.ofNullable(
                                  widget.nameController.text.trim(),
                                ),
                                age: Value.ofNullable(int.parse(
                                    widget.ageController.text.trim())),
                                description: Value.ofNullable(
                                    widget.descriptionController.text.trim()),
                              );

                              driftService.userDatabase.updateData(newUserItem);

                              if (!context.mounted) return;
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
      },
    );
  }
}
