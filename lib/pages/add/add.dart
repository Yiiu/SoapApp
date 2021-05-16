import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:blurhash/blurhash.dart';
import 'package:dio/dio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/pages/add/widgets/input.dart';
import 'package:soap_app/repository/oss_repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/colors.dart';
import 'package:soap_app/utils/image.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    Key? key,
    required this.assets,
  }) : super(key: key);
  final List<AssetEntity> assets;

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final OssProvider _ossProvider = OssProvider();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  double progressValue = 1;

  Future<void> _onOk() async {
    final File? file = await widget.assets[0].loadFile();
    if (file != null) {
      final Uint8List? thumb = await widget.assets[0].thumbData;
      final Map<String, Object?> info = {};
      final List<Future> futures = <Future>[];
      futures
          .add(PaletteGenerator.fromImageProvider(Image.memory(thumb!).image));
      futures.add(getEXIF(file.path));
      futures.add(BlurHash.encode(thumb, 4, 3));
      final List data = await Future.wait<dynamic>(futures);
      final PaletteGenerator paletteGenerator = data[0] as PaletteGenerator;
      final Map<String, Object?>? exif = data[1] as Map<String, Object?>?;
      final String blurHash = data[2] as String;
      final PaletteColor color = paletteGenerator.dominantColor!;
      info['color'] = color.color.toHex();
      info['isDark'] = false;
      info['exif'] = exif;
      info['height'] = widget.assets[0].height;
      info['width'] = widget.assets[0].width;
      info['make'] = exif?['make'];
      info['model'] = exif?['model'];
      info['blurhash'] = blurHash;
      print(_titleController.text);
      print(_bioController.text);
      // final Response sts = await _ossProvider.sts();
      // final Response ossData = await _ossProvider.putObject(
      //   widget.assets[0],
      //   accessKeyID: sts.data['AccessKeyId'] as String,
      //   accessKeySecret: sts.data['AccessKeySecret'] as String,
      //   stsToken: sts.data['SecurityToken'] as String,
      //   userId: accountStore.userInfo!.id.toString(),
      //   onSendProgress: (progress) => setState(() {
      //     print(progress);
      //     progressValue = progress;
      //   }),
      // );

      // final List<dynamic> tags = List<dynamic>.empty();
      // await _ossProvider.addPicture({
      //   'info': info,
      //   'key': jsonDecode(ossData.data as String)['key'],
      //   'tags': tags,
      //   'title': '',
      //   'isPrivate': false,
      //   'bio': '',
      // });
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
        body: Stack(
          children: [
            Flex(
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
                                      image: AssetEntityImageProvider(
                                          widget.assets[0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Flex(
                                  direction: Axis.vertical,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 40,
                                      width: double.infinity,
                                      child: AddInput(
                                        label: '标题',
                                        controller: _titleController,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    SizedBox(
                                      height: 80,
                                      width: double.infinity,
                                      child: AddInput(
                                        controller: _bioController,
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: progressValue == 0 || progressValue == 1 ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: 2,
                  child: LinearProgressIndicator(
                    value: progressValue,
                    valueColor: const AlwaysStoppedAnimation(Color(0xff52c41a)),
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

class _client {}
