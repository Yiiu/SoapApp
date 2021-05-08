import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    this.errorText,
    this.label,
    required this.onChanged,
  }) : super(key: key);

  final String? errorText;
  final void Function(String) onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      cursorColor: Colors.blue,
      textInputAction: TextInputAction.newline,
      style: const TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        fillColor: const Color(0xfff4f7f8),
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
        ),
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        errorText: errorText,
      ),
    );
  }
}
