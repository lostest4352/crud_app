import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopupTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String labelText;
  const PopupTextField({
    super.key,
    required this.textEditingController,
    this.keyboardType,
    this.inputFormatters,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        minLines: 1,
        maxLines: 4,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: textEditingController,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          isDense: true,
          contentPadding: const EdgeInsets.all(12),
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
