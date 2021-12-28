import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:soap_app/widget/more_handle_modal/more_handle_modal.dart';

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
    return MoreHandleModal(
      title: '标签',
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: SizedBox(
            // height: 200,
            child: TagEditor(
              maxLines: 6,
              autofocus: true,
              focusNode: focusNode,
              controller: _controller,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              length: values.length,
              delimiters: const [',', ' '],
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
            ),
          ),
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
    return Chip(
      backgroundColor: const Color(0xff1890ff).withOpacity(.15),
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xff1890ff),
        ),
      ),
      deleteIcon: const Icon(
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
