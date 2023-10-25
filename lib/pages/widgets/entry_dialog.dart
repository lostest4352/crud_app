import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testapp1/isar_dbs/isar_service.dart';
import 'package:testapp1/isar_dbs/user_details_isar.dart';
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
    this.userDetails,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController descriptionController;
  final bool editMode;
  final int? selectedId;
  final UserDetails? userDetails;

  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  IsarService isarService = getIt.get<IsarService>();
  Future<List<UserDetails>> get getIsarData => isarService.getData();

  @override
  void initState() {
    super.initState();
    widget.nameController.text = widget.userDetails?.name ?? "";
    widget.ageController.text = widget.userDetails?.age.toString() ?? "";
    widget.descriptionController.text = widget.userDetails?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIsarData,
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
                          if (widget.userDetails != null) {
                            isarService.deleteData(widget.userDetails!);
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
                            final userDetails = UserDetails()
                              ..name = widget.nameController.text.trim()
                              ..age =
                                  int.parse(widget.ageController.text.trim())
                              ..description =
                                  widget.descriptionController.text.trim();

                            if (widget.editMode == false) {
                              isarService.saveData(userDetails);
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            } else {
                              isarService.editData(
                                widget.selectedId!,
                                widget.nameController.text.trim(),
                                int.parse(widget.ageController.text.trim()),
                                widget.descriptionController.text.trim(),
                              );
                              //
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
