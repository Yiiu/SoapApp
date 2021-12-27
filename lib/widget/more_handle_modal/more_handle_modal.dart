import 'package:flutter/material.dart';
import 'package:soap_app/config/config.dart';

class MoreHandleModal extends StatelessWidget {
  const MoreHandleModal({
    Key? key,
    this.title,
    this.removeBottom = false,
    this.position,
    required this.child,
  }) : super(key: key);

  final bool removeBottom;
  final String? title;
  final Widget child;
  final Widget? position;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: !removeBottom,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16)
            ],
            child,
          ],
        ),
      ),
    );
  }
}
