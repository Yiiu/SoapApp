import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/widget/input.dart';

class InputModalModalBottom extends StatefulWidget {
  const InputModalModalBottom({
    Key? key,
    this.label,
    this.title,
    this.defaultValue,
    this.maxLines,
    required this.onOk,
  }) : super(key: key);

  final String? label;
  final String? title;
  final String? defaultValue;
  final int? maxLines;
  final Future<void> Function(String) onOk;

  @override
  _InputModalModalBottomState createState() => _InputModalModalBottomState();
}

class _InputModalModalBottomState extends State<InputModalModalBottom> {
  final TextEditingController _textController = TextEditingController();

  final FocusNode _textFocusNode = FocusNode();

  bool _okBind = false;

  @override
  void initState() {
    _textController.text = widget.defaultValue ?? '';
    super.initState();
  }

  void _onOk() {
    if (!_okBind) {
      _okBind = true;
      final Future<void> data = widget.onOk.call(_textController.text.trim());
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    SizedBox(
                      // height: 40,
                      width: double.infinity,
                      child: SoapInput(
                        autofocus: true,
                        maxLines: widget.maxLines,
                        focusNode: _textFocusNode,
                        label: widget.label ?? '请输入',
                        controller: _textController,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
