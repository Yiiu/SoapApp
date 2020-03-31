import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'test.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<Counter>(
    create: (context) => Counter(),
  )
];
