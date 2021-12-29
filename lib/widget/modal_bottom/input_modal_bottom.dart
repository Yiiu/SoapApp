import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:soap_app/widget/input.dart';
import 'package:soap_app/widget/modal_bottom/confirm_modal_bottom.dart';

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

  @override
  void initState() {
    _textController.text = widget.defaultValue ?? '';
    super.initState();
  }

  Future<void> _onOk() async {
    await widget.onOk.call(_textController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmModalBottom(
      title: widget.title,
      onOk: _onOk,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            SizedBox(
              // height: 40,
              width: double.infinity,
              child: SoapInput(
                autofocus: true,
                maxLines: widget.maxLines,
                focusNode: _textFocusNode,
                label: widget.label ??
                    FlutterI18n.translate(context, 'common.label.please_enter'),
                controller: _textController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
