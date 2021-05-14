import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/pages/add/widgets/input.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddPage extends StatelessWidget {
  const AddPage({
    Key? key,
    required this.assets,
  }) : super(key: key);

  final List<AssetEntity> assets;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: FixedAppBarWrapper(
        appBar: const SoapAppBar(
          border: true,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Column(
                          // direction: Axis.vertical,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                  image: AssetEntityImageProvider(assets[0],
                                      isOriginal: false),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Flex(
                              direction: Axis.vertical,
                              children: const <Widget>[
                                SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: AddInput(
                                    label: '标题',
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  height: 80,
                                  width: double.infinity,
                                  child: AddInput(
                                    label: '简介',
                                    isBio: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TouchableOpacity(
                activeOpacity: activeOpacity,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Center(
                    child: Text('发布',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
