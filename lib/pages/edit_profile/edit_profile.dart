import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
      accountStore.getUserInfo();
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
        appBar: SoapAppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          actionsPadding: const EdgeInsets.only(
            right: 12,
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              FlutterI18n.translate(context, 'profile.edit.title'),
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
                  child: SizedBox(
                    width: 86,
                    height: 86,
                    child: Stack(
                      children: <Widget>[
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
                  children: <Widget>[
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
                    const SoapDivider(),
                    SettingItem(
                      title: FlutterI18n.translate(
                          context, 'profile.edit.label.username'),
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
                      title: FlutterI18n.translate(
                        context,
                        'profile.edit.label.fullname',
                      ),
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
                            title: FlutterI18n.translate(
                                    context, 'profile.edit.label.edit') +
                                FlutterI18n.translate(
                                    context, 'profile.edit.label.fullname'),
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
                      title: FlutterI18n.translate(
                          context, 'profile.edit.label.gender'),
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
                      title: FlutterI18n.translate(
                          context, 'profile.edit.label.birthday'),
                      border: false,
                      action: Expanded(
                        child: Observer(builder: (_) {
                          return Text(
                            accountStore.userInfo!.birthday != null
                                ? Jiffy.parse(accountStore.userInfo!.birthday!)
                                    .MMMd
                                : FlutterI18n.translate(
                                    context, 'profile.edit.label.none'),
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
                          title: FlutterI18n.translate(
                              context, 'profile.edit.label.bio'),
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
                                title: FlutterI18n.translate(
                                        context, 'profile.edit.label.edit') +
                                    FlutterI18n.translate(
                                        context, 'profile.edit.label.bio'),
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
