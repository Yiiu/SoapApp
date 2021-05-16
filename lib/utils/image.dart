import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:exif/exif.dart';

enum ExifProperties {
  model,
  make,
  focalLength,
  aperture,
  exposureTime,
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

  final Map<String?, IfdTag>? data = await readExifFromBytes(
    await File(path).readAsBytes(),
  );

  if (data == null || data.isEmpty) {
    print('No EXIF information found\n');
    return null;
  }
  final Map<String, Object?> exif = {};
  // print(data.keys);
  for (String? key in data.keys) {
    if (key != null && data[key] != null) {
      switch (key) {
        case 'Image Model':
          exif['model'] = data[key]?.printable;
          break;
        case 'Image Make':
          exif['make'] = data[key]?.printable;
          break;
        case 'EXIF FocalLength':
          exif['focalLengthke'] = formatValue(data[key]!.values);
          break;
        case 'EXIF FNumber':
          exif['aperture'] = formatValue(data[key]!.values);
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
          exif['orientation'] = data[key]!.values![0];
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
}
