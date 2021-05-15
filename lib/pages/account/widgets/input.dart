import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    required this.onChanged,
    this.errorText,
    this.label,
    this.password = false,
  }) : super(key: key);

  final String? errorText;
  final void Function(String) onChanged;
  final String? label;
  final bool password;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      obscureText: password,
      onChanged: onChanged,
      cursorColor: Colors.blue,
      style: const TextStyle(
        fontSize: 16,
      ),
      textInputAction: password ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
        fillColor: theme.backgroundColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.6),
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
