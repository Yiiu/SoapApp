import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data' as typed_data;

import 'package:blurhash/blurhash.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart' as extended_image;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:octo_image/octo_image.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:soap_app/utils/octo_bluehash.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../model/location.dart';
import '../../model/picture.dart';
import '../../repository/repository.dart';
import '../../store/index.dart';
import '../../utils/utils.dart';
import '../../widget/widgets.dart';
import 'location_setting.dart';
import 'more_setting.dart';
import 'stores/add_store.dart';
import 'widgets/widgets.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    Key? key,
    this.edit = false,
    this.assets,
    this.picture,
  }) : super(key: key);
  final List<AssetEntity>? assets;
  final bool edit;
  final Picture? picture;

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late FocusNode _titleFocusNode;
  late FocusNode _bioFocusNode;

  final AddStore _addStore = AddStore();

  final BaiduProvider _baiduProvider = BaiduProvider();

  final OssProvider _ossProvider = OssProvider();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  dynamic _classify;

  double progressValue = 1;

  @override
  void initState() {
    _titleFocusNode = FocusNode();
    _bioFocusNode = FocusNode();
    if (widget.edit) {
      editInit();
    } else {
      // 获取图片关键词，方便搜索分类
      _getImageClassify();
    }
    super.initState();
  }

  void editInit() {
    if (widget.picture != null) {
      _addStore.editInit(widget.picture!);
      _titleController.text = widget.picture!.title;
      _bioController.text = widget.picture!.bio ?? '';
    }
  }

  Future<void> _getImageClassify() async {
    if (widget.assets != null) {
      final typed_data.Uint8List? thumb =
          await widget.assets![0].thumbnailDataWithSize(
        const ThumbnailSize(
          200,
          200,
        ),
      );
      if (thumb != null) {
        final String base64Image = convert.base64Encode(thumb);
        final Response? result =
            await _baiduProvider.getImageClassify(base64Image);
        if (result?.data?['result'] != null) {
          _classify = result!.data!['result'];
        }
      }
    }
  }

  Future<void> _onOk() async {
    if (widget.edit) {
      _addStore.setLoading(true);
      try {
        await _addStore.update(
            widget.picture!.id, _titleController.text, _bioController.text);
        SoapToast.success('修改成功！');
        Navigator.of(context).pop();
      } catch (e) {
        captureException(e);
        _addStore.setLoading(false);
        // SoapToast.error('修改失败');
      }
    } else {
      if (widget.assets == null) {
        return;
      }
      final File? file = await widget.assets![0].loadFile();

      if (file != null) {
        if (_titleController.text.isEmpty) {
          SoapToast.error('请填写标题！');
          return;
        }
        final int size = await file.length();
        final double mb = size / 1024 / 1024;
        if (mb > 19) {
          SoapToast.error('图片过大无法上传，请压缩后在上传！');
          return;
        }
        final typed_data.Uint8List? thumb =
            await widget.assets![0].thumbnailData;
        final Map<String, Object?> info = {};
        final List<Future> futures = <Future>[];
        futures.add(
            PaletteGenerator.fromImageProvider(Image.memory(thumb!).image));
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
        info['height'] = widget.assets![0].height;
        info['width'] = widget.assets![0].width;
        info['make'] = exif?['make'];
        info['model'] = exif?['model'];
        info['blurhash'] = blurHash;
        if (_classify != null) {
          info['classify'] = _classify;
        }
        _addStore.setLoading(true);
        try {
          final Response sts = await _ossProvider.sts();
          final Response ossData = await _ossProvider.putObject(
            widget.assets![0],
            accessKeyID: sts.data['AccessKeyId'] as String,
            accessKeySecret: sts.data['AccessKeySecret'] as String,
            stsToken: sts.data['SecurityToken'] as String,
            userId: accountStore.userInfo!.id.toString(),
            onSendProgress: (double progress) => setState(() {
              progressValue = progress;
            }),
          );
          await _ossProvider.addPicture({
            'info': info,
            'key': convert.jsonDecode(ossData.data as String)['key'],
            'tags': _addStore.tags
                .map((String e) => <String, String>{'name': e})
                .toList(),
            'title': _titleController.text,
            'isPrivate': _addStore.isPrivate,
            'bio': _bioController.text,
            'location': _addStore.location,
          });
          SoapToast.success('上传成功！');
          Navigator.of(context).pop();
        } catch (e) {
          captureException(e);
          _addStore.setLoading(false);
          SoapToast.error('上传失败，请重试！');
        }
      }
    }
  }

  Widget _itemBuild({
    required Widget title,
    required IconData icon,
    void Function()? onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 15,
                    color: iconColor ??
                        Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .color!
                            .withOpacity(.4),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: title,
                  ),
                ],
              ),
            ),
            Icon(
              FeatherIcons.chevronRight,
              size: 22,
              color:
                  Theme.of(context).textTheme.bodyText2!.color!.withOpacity(.5),
            )
          ],
        ),
      ),
    );
  }

  void _unfocus() {
    _bioFocusNode.unfocus();
    _titleFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: FixedAppBarWrapper(
        appBar: const SoapAppBar(
          elevation: 0.5,
          automaticallyImplyLeading: true,
        ),
        body: Stack(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _unfocus();
              },
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              child: Column(
                                // direction: Axis.vertical,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: widget.edit
                                          ? OctoImage(
                                              placeholderBuilder:
                                                  OctoBlurHashFix.placeHolder(
                                                widget.picture!.blurhash,
                                              ),
                                              image: extended_image
                                                  .ExtendedImage.network(
                                                widget.picture!.pictureUrl(
                                                  style: PictureStyle.small,
                                                ),
                                              ).image,
                                              fit: BoxFit.cover,
                                            )
                                          : Image(
                                              image: AssetEntityImageProvider(
                                                  widget.assets![0]),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Flex(
                                    direction: Axis.vertical,
                                    children: <Widget>[
                                      SizedBox(
                                        width: double.infinity,
                                        child: AddInput(
                                          focusNode: _titleFocusNode,
                                          label: '给你的照片起个标题吧！',
                                          controller: _titleController,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: 80,
                                        width: double.infinity,
                                        child: AddInput(
                                          focusNode: _bioFocusNode,
                                          controller: _bioController,
                                          label: '随便说点什么',
                                          isBio: true,
                                        ),
                                      ),
                                      Observer(
                                        builder: (_) => _itemBuild(
                                          iconColor: _addStore.tags.isNotEmpty
                                              ? const Color(0xff1890ff)
                                              : null,
                                          title: _addStore.tags.isNotEmpty
                                              ? Text(
                                                  _addStore.tags.join('   '),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xff1890ff),
                                                  ),
                                                )
                                              : const Text(
                                                  '添加标签',
                                                ),
                                          icon: FeatherIcons.hash,
                                          onTap: () {
                                            showSoapBottomSheet<void>(
                                              context,
                                              isScrollControlled: true,
                                              child: EditTag(
                                                onOk: (List<String> _tags) {
                                                  _unfocus();
                                                  _addStore.setTags(_tags);
                                                },
                                                tags: _addStore.tags,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SoapDivider(),
                                      _itemBuild(
                                        title: const Text(
                                          '更多设置',
                                        ),
                                        icon: FeatherIcons.settings,
                                        onTap: () {
                                          _unfocus();
                                          Navigator.of(context).push(
                                            CupertinoPageRoute<void>(
                                              builder: (_) => MoreSettingPage(
                                                isPrivate: _addStore.isPrivate,
                                                onChange: (bool _isPrivate) {
                                                  _addStore
                                                      .setPrivate(_isPrivate);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SoapDivider(),
                                      Observer(
                                        builder: (_) => _itemBuild(
                                          title: _addStore.location != null
                                              ? Text(
                                                  _addStore.location!.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xff1890ff),
                                                  ),
                                                )
                                              : const Text(
                                                  '拍摄位置',
                                                ),
                                          icon: FeatherIcons.mapPin,
                                          onTap: () {
                                            _unfocus();
                                            Navigator.of(context).push(
                                              CupertinoPageRoute<void>(
                                                builder: (_) =>
                                                    LocationSettingPage(
                                                  // isPrivate: _addStore.isPrivate,
                                                  onChange: (Location? data) {
                                                    _addStore.setLocation(data);
                                                  },
                                                ),
                                              ),
                                            );
                                          },
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
                    child: Observer(
                        builder: (_) => SoapButton(
                              loading: _addStore.loading,
                              title: widget.edit ? '修改' : '发布',
                              onTap: () => _onOk(),
                            )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
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
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xff52c41a)),
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
