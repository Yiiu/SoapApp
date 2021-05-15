import 'dart:io';
import 'dart:ui';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
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

  Future<void> printExifOf(String path) async {
    final Map<String?, IfdTag>? data = await readExifFromBytes(
      await File(path).readAsBytes(),
    );

    if (data == null || data.isEmpty) {
      print('No EXIF information found\n');
      return;
    }

    if (data.containsKey('JPEGThumbnail')) {
      print('File has JPEG thumbnail');
      data.remove('JPEGThumbnail');
    }
    if (data.containsKey('TIFFThumbnail')) {
      print('File has TIFF thumbnail');
      data.remove('TIFFThumbnail');
    }

    for (String? key in data.keys) {
      print('$key: ${data[key]}');
    }
  }

  Future<void> _onOk() async {
    final File? file = await assets[0].loadFile();
    if (file != null) {
      print(file.path);
      printExifOf(file.path);
    }
  }

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
                onTap: _onOk,
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
