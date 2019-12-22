import 'package:provider/provider.dart';
import 'package:soap_app/provider/test.dart';

List<SingleChildCloneableWidget> providers = [
  ChangeNotifierProvider<Counter>(
    create: (context) => Counter(),
  )
];
