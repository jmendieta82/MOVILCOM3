import 'package:flutter/material.dart';

class MrnFieldBox extends StatelessWidget {
  final ValueChanged<String>? onValue;
  final TextEditingController? controller;
  final TextInputType? kbType;
  final String? label;
  final double? size;
  final TextAlign align;

  const MrnFieldBox({
    super.key,
    this.onValue,
    this.controller,
    this.kbType,
    this.label,
    this.size,
    this.align = TextAlign.left
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    final inputDecoration = InputDecoration(
      border: const OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelText: label,
    );

    return Column(
      children: [
        const SizedBox(height: 25,),
        TextFormField(
          onTapOutside: (event) {
            focusNode.unfocus();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Falta informacion.';
            }
            return null;
          },
          style: TextStyle(
            fontSize: size??size,
          ),
          textAlign: align,
          keyboardType: kbType,
          focusNode: focusNode,
          controller: controller,
          decoration: inputDecoration,
          onFieldSubmitted: (value) {
            focusNode.requestFocus();
            onValue!(value);
          },
        ),
      ],
    );
  }
}