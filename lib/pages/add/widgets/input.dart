import 'package:flutter/material.dart';

class AddInput extends StatelessWidget {
  const AddInput({
    Key? key,
    this.isBio = false,
    this.focusNode,
    required this.label,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool isBio;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      focusNode: focusNode,
      keyboardType: isBio ? TextInputType.multiline : null,
      maxLines: isBio ? 4 : 1,
      controller: controller,
      cursorColor: theme.textTheme.bodyText2!.color!.withOpacity(.2),
      style: isBio
          ? const TextStyle(
              fontSize: 16,
            )
          : const TextStyle(
              fontSize: 18,
            ),
      textInputAction: isBio ? TextInputAction.done : TextInputAction.next,
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
            width: 1,
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
