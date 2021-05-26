import 'package:flutter/material.dart';

class ConfirmModalBottom extends StatefulWidget {
  const ConfirmModalBottom({
    required this.onOk,
    required this.child,
    Key? key,
    this.title,
    this.bottomPadding = 24,
  }) : super(key: key);

  final String? title;
  final double? bottomPadding;
  final Future<void> Function() onOk;
  final Widget child;

  @override
  _ConfirmModalBottomState createState() => _ConfirmModalBottomState();
}

class _ConfirmModalBottomState extends State<ConfirmModalBottom> {
  bool _okBind = false;

  @override
  void initState() {
    super.initState();
  }

  void _onOk() {
    if (!_okBind) {
      _okBind = true;
      final Future<void> data = widget.onOk.call();
      if (data != null) {
        data.then((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 1000));
          _okBind = false;
        });
        data.onError((Object? error, StackTrace stackTrace) {
          _okBind = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .color!
                                .withOpacity(0.12);
                          return Colors
                              .transparent; // Defer to the widget's default.
                        },
                      ),
                    ),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption!.color,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    widget.title ?? '编辑',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Theme.of(context)
                                .primaryColor
                                .withOpacity(0.04);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .primaryColor
                                .withOpacity(0.12);
                          return Colors
                              .transparent; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () {
                      _onOk();
                    },
                    child: const Text(
                      '保存',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              widget.child,
              if (widget.bottomPadding != null && widget.bottomPadding! > 0)
                SizedBox(height: widget.bottomPadding!),
            ],
          ),
        ),
      ),
    );
  }
}
