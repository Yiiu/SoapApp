import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:soap_app/provider/home.dart';
import 'package:soap_app/repository/picture_repository.dart';

import 'test.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<Counter>(
    create: (context) => Counter(),
  ),
  ChangeNotifierProvider<HomeProvider>(
    create: (context) => HomeProvider(repository: PictureRepository()),
  ),
];
