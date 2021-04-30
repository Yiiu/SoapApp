import 'package:flutter/material.dart';
import 'package:soap_app/model/tag.dart';

class TagItem extends StatelessWidget {
  const TagItem({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(tag.name),
    );
  }
}
