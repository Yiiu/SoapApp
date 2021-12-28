import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';

import '../../repository/account_repository.dart';
import '../../store/index.dart';
import '../../utils/utils.dart';
import '../../widget/widgets.dart';
import '../setting/widgets/setting_item.dart';
import 'widgets/edit_birthday.dart';
import 'widgets/edit_gender_modal.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);

  final AccountProvider _accountProvider = AccountProvider();

  void initState() {
    accountStore.getUserInfo();
  }

  Future<void> _updateProfile(Map<String, Object?> newData) async {
    final Map<String, Object?> data = {
      'name': accountStore.userInfo!.fullName,
      'bio': accountStore.userInfo!.bio,
      'key': accountStore.userInfo!.avatar,
      'gender': accountStore.userInfo!.gender,
      'genderSecret': accountStore.userInfo!.genderSecret,
      'birthday': accountStore.userInfo!.birthday,
      'birthdayShow': accountStore.userInfo!.birthdayShow,
      ...newData,
    };
    // if (accountStore.userInfo!.birthday == null) {
    //   data['birthday'] = accountStore.userInfo!.birthday.toString();
    // }
    try {
      await _accountProvider.updateProfile(data);
      SoapToast.success('保存成功');
    } on OperationException catch (_, stackTrace) {
      captureException(_, stackTrace: stackTrace);
      // print(_.graphqlErrors[0].extensions?['exception']['message']);
      SoapToast.error('保存失败，服务器坏掉了!');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.backgroundColor,
      child: FixedAppBarWrapper(
        appBar: const SoapAppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          actionsPadding: EdgeInsets.only(
            right: 12,
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '编辑个人资料',
            ),
          ),
        ),
        body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                color: theme.cardColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 86,
                    height: 86,
                    child: Stack(
                      children: [
                        Center(
                          child: Observer(
                            builder: (_) => Avatar(
                              size: 86,
                              image: accountStore.userInfo!.avatarUrl,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              FeatherIcons.edit3,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: theme.cardColor,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    SettingItem(
                      title: 'ID',
                      actionIcon: false,
                      border: false,
                      action: Observer(builder: (_) {
                        return Text(
                          accountStore.userInfo!.id.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        );
                      }),
                    ),
                    SoapDivider(),
                    SettingItem(
                      title: '用户名',
                      actionIcon: false,
                      border: false,
                      action: Observer(builder: (_) {
                        return Text(
                          accountStore.userInfo!.username,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        );
                      }),
                    ),
                    const SoapDivider(),
                    SettingItem(
                      title: '昵称',
                      actionIcon: true,
                      border: false,
                      action: Expanded(
                        child: Observer(builder: (_) {
                          return Text(
                            accountStore.userInfo!.fullName,
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          );
                        }),
                      ),
                      onPressed: () {
                        showSoapBottomSheet<dynamic>(
                          context,
                          isScrollControlled: true,
                          child: InputModalModalBottom(
                            defaultValue: accountStore.userInfo!.fullName,
                            title: '编辑昵称',
                            onOk: (String value) async {
                              await _updateProfile({'name': value});
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
                    const SoapDivider(),
                    SettingItem(
                      title: '性别',
                      actionIcon: true,
                      border: false,
                      action: Expanded(
                        child: Observer(builder: (_) {
                          return Text(
                            accountStore.userInfo!.genderString,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          );
                        }),
                      ),
                      onPressed: () {
                        showSoapBottomSheet<dynamic>(
                          context,
                          child: EditGenderModal(
                            gender: accountStore.userInfo!.gender,
                            onOk: (Map<String, Object?> data) async {
                              await _updateProfile(data);
                              Navigator.of(context).pop();
                            },
                            genderSecret: accountStore.userInfo!.genderSecret!,
                          ),
                        );
                      },
                    ),
                    const SoapDivider(),
                    SettingItem(
                      title: '生日',
                      border: false,
                      action: Expanded(
                        child: Observer(builder: (_) {
                          return Text(
                            accountStore.userInfo!.birthday != null
                                ? Jiffy(accountStore.userInfo!.birthday!).MMMd
                                : '暂无',
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          );
                        }),
                      ),
                      onPressed: () {
                        showSoapBottomSheet<dynamic>(
                          context,
                          isScrollControlled: true,
                          child: EditBirthday(
                            birthday: accountStore.userInfo!.birthday,
                            birthdayShow: accountStore.userInfo!.birthdayShow,
                            onOk: (Map<String, Object?> data) async {
                              print(data);
                              await _updateProfile(data);
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
                    const SoapDivider(),
                    Observer(
                      builder: (_) {
                        return SettingItem(
                          title: '简介',
                          actionIcon: true,
                          border: false,
                          action: Expanded(
                            child: Text(
                              accountStore.userInfo!.bio ?? '',
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          onPressed: () {
                            showSoapBottomSheet<dynamic>(
                              context,
                              isScrollControlled: true,
                              child: InputModalModalBottom(
                                maxLines: 4,
                                defaultValue: accountStore.userInfo!.bio,
                                title: '编辑简介',
                                onOk: (String value) async {
                                  await _updateProfile({'bio': value});
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
