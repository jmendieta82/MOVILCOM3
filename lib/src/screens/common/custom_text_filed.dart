import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MrnFieldBox extends StatelessWidget {
  final ValueChanged<String>? onValue;
  final ValueChanged<String>? onValueChange;
  final TextEditingController? controller;
  final TextInputType? kbType;
  final String? label;
  final double? size;
  final TextAlign align;
  final Widget? icon;
  final bool enabled;
  final String? placeholder;
  final List<TextInputFormatter>? formatters;

  const MrnFieldBox({
    super.key,
    this.onValue,
    this.controller,
    this.kbType,
    this.label,
    this.size,
    this.icon,
    this.align = TextAlign.left,
    this.formatters,
    this.enabled = true,
    this.placeholder,
    this.onValueChange
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    final inputDecoration = InputDecoration(
      border: const OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelText: label,
      suffixIcon: icon,
      hintText: placeholder
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
          enabled: enabled,
          keyboardType: kbType,
          inputFormatters: formatters ?? [],
          focusNode: focusNode,
          controller: controller,
          decoration: inputDecoration,
          onFieldSubmitted: (value) {
            focusNode.requestFocus();
            onValue!(value);
          },
          /*onChanged: (value) {
            focusNode.requestFocus();
            onValueChange!(value);
          },*/
        ),
      ],
    );
  }
}