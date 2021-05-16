import 'package:flutter/material.dart';

class AddInput extends StatelessWidget {
  const AddInput({
    Key? key,
    this.isBio = false,
    required this.label,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool isBio;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isBio ? TextInputType.multiline : null,
      maxLines: isBio ? 4 : 1,
      controller: controller,
      textInputAction: isBio ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
        hintText: label,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: .5,
            color:
                Theme.of(context).textTheme.bodyText2!.color!.withOpacity(.1),
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
