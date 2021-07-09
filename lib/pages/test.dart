import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late FocusNode focusNode;
  bool isTest = false;
  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: isTest ? 12 : 0,
              left: 0,
              right: 0,
              child: TextField(
                focusNode: focusNode,
              ),
            ),
            if (isTest)
              TextButton(
                child: Text('test'),
                onPressed: () {
                  FocusScope.of(context).requestFocus(focusNode);
                  // focusNode.requestFocus();
                  setState(() {
                    isTest = !isTest;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
