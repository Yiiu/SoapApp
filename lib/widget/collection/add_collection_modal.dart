import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:soap_app/model/collection.dart';
import 'package:soap_app/pages/add/widgets/input.dart';
import 'package:soap_app/repository/collection_repository.dart';
import 'package:soap_app/widget/soap_toast.dart';

class AddCollectionModal extends StatefulWidget {
  const AddCollectionModal({
    Key? key,
    this.collection,
    required this.refetch,
  }) : super(key: key);

  final VoidCallback refetch;
  final Collection? collection;

  @override
  _AddCollectionModalState createState() => _AddCollectionModalState();
}

class _AddCollectionModalState extends State<AddCollectionModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final AdvancedSwitchController _controller = AdvancedSwitchController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _bioFocusNode = FocusNode();

  final CollectionRepository _collectionRepository = CollectionRepository();

  @override
  void initState() {
    _titleFocusNode.requestFocus();
    if (widget.collection != null) {
      _titleController.text = widget.collection!.name;
      _bioController.text = widget.collection!.bio ?? '';
      _controller.value = widget.collection!.isPrivate ?? false;
    }
    super.initState();
  }

  bool get isEdit => widget.collection != null;

  Future<void> _onOk() async {
    if (_titleController.text.isEmpty) {
      SoapToast.error('标题是必填的');
      return;
    }
    final data = {
      'name': _titleController.text,
      'bio': _bioController.text,
      'isPrivate': _controller.value,
    };
    if (isEdit) {
      await _collectionRepository.update(widget.collection!.id, data);
    } else {
      await _collectionRepository.add(data);
      // widget.refetch();
    }
    Navigator.of(context).pop();
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
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption!.color,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    isEdit ? '编辑收藏夹' : '新增收藏夹',
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
                    child: Text(
                      isEdit ? '编辑' : '新增',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: AddInput(
                        focusNode: _titleFocusNode,
                        label: '标题',
                        controller: _titleController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: AddInput(
                        focusNode: _bioFocusNode,
                        controller: _bioController,
                        label: '说明',
                        isBio: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 0,
                      ),
                      title: const Text(
                        '仅自己可见',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: AdvancedSwitch(
                        controller: _controller,
                        width: 52,
                        height: 32,
                      ),
                      onTap: () {
                        _controller.value = !_controller.value;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
