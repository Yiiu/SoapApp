import 'package:flutter/material.dart';

class MoreHandleModal extends StatelessWidget {
  const MoreHandleModal({
    Key? key,
    this.title,
    required this.child,
  }) : super(key: key);

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          if (title != null)
            Text(
              title!,
              style: TextStyle(
                color: Theme.of(context).textTheme.caption!.color,
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 6),
          child
        ]),
      ),
    );
  }
}
