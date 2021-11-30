import 'package:flutter/material.dart';
import 'package:soap_app/config/config.dart';

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
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
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
