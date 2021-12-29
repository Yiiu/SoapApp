import 'package:flutter/material.dart';

class SoapInput extends StatelessWidget {
  const SoapInput({
    Key? key,
    this.maxLines,
    this.focusNode,
    this.autofocus = false,
    this.textInputAction,
    required this.label,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final bool? autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      autofocus: autofocus!,
      focusNode: focusNode,
      keyboardType:
          (maxLines ?? 1) > 1 ? TextInputType.multiline : TextInputType.text,
      maxLines: maxLines,
      controller: controller,
      cursorColor: theme.textTheme.bodyText2!.color!.withOpacity(.2),
      style: const TextStyle(
        fontSize: 16,
      ),
      textInputAction: textInputAction ?? TextInputAction.done,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          color: theme.textTheme.bodyText2!.color!.withOpacity(.3),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: .2,
            color:
                Theme.of(context).textTheme.bodyText2!.color!.withOpacity(.2),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(0),
          ),
        ),
      ),
    );
  }
}
