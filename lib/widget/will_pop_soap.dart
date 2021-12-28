import 'package:flutter/material.dart';
import 'widgets.dart';

class WillPopSoap extends StatefulWidget {
  const WillPopSoap({
    required this.child,
  });

  final Widget child;

  @override
  _WillPopSoapState createState() => _WillPopSoapState();
}

class _WillPopSoapState extends State<WillPopSoap> {
  bool _willPop = false;

  void _updateWillPop() {
    _willPop = true;
    Future<void>.delayed(const Duration(seconds: 5)).then(
      (_) => _willPop = false,
    );
  }

  Future<bool> _onWillPop() async {
    print('test');
    // if the current pop request will close the application
    if (!Navigator.of(context).canPop()) {
      if (_willPop) {
        return true;
      } else {
        SoapToast.toast('test');
        _updateWillPop();
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child,
    );
  }
}
