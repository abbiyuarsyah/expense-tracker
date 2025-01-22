import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.textEditingController,
    required this.labelText,
    required this.hintText,
    this.textInputType,
    this.inputFormatters,
    this.prefixText,
    this.validator,
    this.prefixIcon,
    this.alignLabelWithHint,
    this.maxLines,
    this.readOnly,
    this.onTap,
  });

  final TextEditingController textEditingController;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String labelText;
  final String hintText;
  final String? prefixText;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final bool? alignLabelWithHint;
  final int? maxLines;
  final bool? readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: textInputType,
      readOnly: readOnly ?? false,
      maxLines: maxLines,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: prefixText,
        border: const OutlineInputBorder(),
        hintText: hintText,
        prefixIcon: prefixIcon,
        alignLabelWithHint: alignLabelWithHint,
      ),
      validator: validator,
      onTap: onTap,
    );
  }
}