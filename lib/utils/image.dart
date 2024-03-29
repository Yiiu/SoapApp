import 'dart:io' as io;
import 'dart:typed_data' as typed_data;

import 'package:decimal/decimal.dart';
import 'package:exif/exif.dart';
import 'package:extended_image/extended_image.dart' as extended_image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widget/soap_toast.dart';

enum ExifProperties {
  model,
  make,
  focalLength,
  aperture,
  exposureTime,
  // ignore: constant_identifier_names
  ISO,
  meteringMode,
  exposureMode,
  exposureBias,
  date,
  software,
  orientation,
  lensModel,
  whiteBalance,
}

Future<Map<String, Object?>?> getEXIF(String path) async {
  String? formatValue(List<dynamic>? values) {
    if (values != null && values[0] != null && values[0].numerator != null) {
      return Decimal.parse(
              (values[0].numerator / values[0].denominator as double)
                  .toStringAsFixed(2))
          .toString();
    }
  }

  try {
    final Map<String?, IfdTag> data = await readExifFromBytes(
      await io.File(path).readAsBytes(),
    );

    if (data.isEmpty) {
      print('No EXIF information found\n');
      return null;
    }
    final Map<String, Object?> exif = {};
    // print(data.keys);
    for (final String? key in data.keys) {
      if (key != null && data[key] != null) {
        switch (key) {
          case 'Image Model':
            exif['model'] = data[key]?.printable;
            break;
          case 'Image Make':
            exif['make'] = data[key]?.printable;
            break;
          case 'EXIF FocalLength':
            exif['focalLengthke'] = formatValue(data[key]!.values.toList());
            break;
          case 'EXIF FNumber':
            exif['aperture'] = formatValue(data[key]!.values.toList());
            break;
          case 'EXIF ExposureTime':
            // final String? value = formatValue(data[key]!.values);
            // if (value != null) {
            //   print((1 / double.parse(value)).round());
            // }
            exif['exposureTime'] = data[key]!.printable;
            break;
          case 'EXIF ISOSpeedRatings':
            exif['ISO'] = data[key]!.printable;
            break;
          case 'EXIF MeteringMode':
            exif['meteringMode'] = data[key]!.printable;
            break;
          case 'EXIF ExposureMode':
            exif['exposureMode'] = data[key]!.printable;
            break;
          case 'EXIF DateTimeOriginal':
            exif['date'] = data[key]!.printable;
            break;
          case 'Image Software':
            exif['software'] = data[key]!.printable;
            break;
          case 'Image Orientation':
            exif['orientation'] = data[key]!.values.toList()[0];
            break;
          case 'EXIF LensModel':
            exif['lensModel'] = data[key]!.printable;
            break;
          case 'EXIF WhiteBalance':
            exif['whiteBalance'] = data[key]!.printable;
            break;
          case 'Image ImageLength':
            exif['height'] = data[key]!.printable;
            break;
          case 'Image ImageWidth':
            exif['width'] = data[key]!.printable;
            break;
          default:
        }
      }
      // print('$key: ${data[key]}');
    }

    return exif;
  } catch (error) {
    print('No EXIF information found\n');
    return null;
  }
}

Future<void> saveImage(String imageUrl, {bool isAsset = false}) async {
  try {
    if (imageUrl == null) throw '保存失败，图片不存在！';

    /// 权限检测
    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.storage.request();
      if (storageStatus != PermissionStatus.granted) {
        throw '无法存储图片，请先授权！';
      }
    }

    /// 保存的图片数据
    typed_data.Uint8List imageBytes;

    if (isAsset) {
      /// 保存资源图片
      final ByteData bytes = await rootBundle.load(imageUrl);
      imageBytes = bytes.buffer.asUint8List();
    } else {
      /// 保存网络图片
      imageBytes = await extended_image.getNetworkImageData(imageUrl)
          as typed_data.Uint8List;
    }

    /// 保存图片
    final dynamic result = await ImageGallerySaver.saveImage(
      imageBytes,
      quality: 100,
    );

    if (result == null || result == '') {
      throw '图片保存失败';
    }
    SoapToast.success('保存成功');
  } catch (e) {
    SoapToast.error(e.toString());
  }
}

Future<io.File> getImageFile(
    {required typed_data.Uint8List bytes, String? name}) async {
  final typed_data.Uint8List sourceBytes = bytes.buffer.asUint8List();
  final io.Directory tempDir = await getTemporaryDirectory();

  final String storagePath = tempDir.path;
  final io.File file;
  file = io.File('$storagePath/$name');

  if (!file.existsSync()) {
    file.createSync();
  }
  file.writeAsBytesSync(sourceBytes);
  return file;
}

double? initScale({
  required Size imageSize,
  required Size size,
  double? initialScale,
}) {
  final double n1 = imageSize.height / imageSize.width;
  final double n2 = size.height / size.width;
  if (n1 > n2) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.width / destinationSize.width;
  } else if (n1 / n2 < 1 / 4) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    final Size destinationSize = fittedSizes.destination;
    return size.height / destinationSize.height;
  }

  return initialScale;
}
