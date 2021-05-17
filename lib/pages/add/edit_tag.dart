import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:material_tag_editor/tag_editor.dart';

class EditTag extends StatefulWidget {
  const EditTag({
    Key? key,
    required this.onOk,
    required this.tags,
  }) : super(key: key);

  final Function(List<String>) onOk;
  final List<String> tags;

  @override
  _EditTagState createState() => _EditTagState();
}

class _EditTagState extends State<EditTag> {
  late FocusNode focusNode;
  final TextEditingController _controller = TextEditingController();
  List<String> values = [];

  @override
  void initState() {
    focusNode = FocusNode();
    values = widget.tags;
    super.initState();
  }

  void _onDelete(int index) {
    setState(() {
      values.removeAt(index);
    });
  }

  void _onAdd(String newValue) {
    if (newValue.isEmpty) {
      return;
    }
    if (!values.contains(newValue.trim())) {
      _controller.text = '';
      setState(() {
        values.add(newValue.trim());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        height: 220,
        child: Column(
          children: [
            Text(
              '添加标签',
              style: TextStyle(
                color: Theme.of(context).textTheme.caption!.color,
                fontSize: 14,
              ),
            ),
            TagEditor(
              autofocus: true,
              focusNode: focusNode,
              controller: _controller,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              length: values.length,
              delimiters: [',', ' '],
              hasAddButton: false,
              inputDecoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '空格或者逗号添加标签',
              ),
              onTagChanged: _onAdd,
              onSubmitted: (String title) {
                widget.onOk(values);
                Navigator.of(context).pop();
                // _onAdd(title);
                // FocusScope.of(context).requestFocus(focusNode);
              },
              tagBuilder: (context, index) => _Chip(
                index: index,
                label: values[index],
                onDeleted: _onDelete,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    const double height = 24;
    return Chip(
      backgroundColor: Color(0xff1890ff).withOpacity(.15),
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(
        label,
        style: TextStyle(
          color: Color(0xff1890ff),
        ),
      ),
      deleteIcon: Icon(
        FeatherIcons.x,
        size: 18,
        color: Color(0xff1890ff),
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
