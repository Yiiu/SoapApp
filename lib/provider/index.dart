import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:soap_app/provider/account.dart';
import 'package:soap_app/provider/home.dart';
import 'package:soap_app/repository/account_repository.dart';
import 'package:soap_app/repository/picture_repository.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<HomeProvider>(
    create: (context) => HomeProvider(repository: PictureRepository()),
  ),
  ChangeNotifierProvider<AccountProvider>(
    create: (context) => AccountProvider(repository: AccountRepository()),
  ),
];
