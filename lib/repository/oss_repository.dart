import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:soap_app/store/index.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Uuid uuid = const Uuid();

// ignore: avoid_classes_with_only_static_members
class SignUtil {
  //验证文本域
  static String policyText =
      '{"expiration": "2099-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

  static String getBase64Policy() {
    assert(policyText.isNotEmpty);
    //进行utf8编码
    final List<int> policyTextUtf8 = utf8.encode(policyText);

    //进行base64编码
    final String policyBase64 = base64.encode(policyTextUtf8);
    return policyBase64;
  }

  static String getSignature(String accessKeySecret) {
    assert(accessKeySecret.isNotEmpty);
    final String base64Policy = getBase64Policy();
    //再次进行utf8编码
    final List<int> policy = utf8.encode(base64Policy);

    //进行utf8 编码
    final List<int> utf8AccessKeySecret = utf8.encode(accessKeySecret);

    //通过hmac,使用sha1进行加密
    final List<int> signaturePre =
        Hmac(sha1, utf8AccessKeySecret).convert(policy).bytes;

    //最后一步，将上述所得进行base64 编码
    final String signature = base64.encode(signaturePre);
    return signature;
  }
}

class OssProvider {
  OssProvider() {
    httpClient = Dio()
      ..options.baseUrl = dotenv.env['API_URL']!
      ..options.connectTimeout = 5000;
  }
  String bucketName = 'soapphoto';
  String endPoint = 'oss-cn-shanghai.aliyuncs.com';

  late Dio httpClient;

  String _base64Encode(String data) {
    final List<int> content = utf8.encode(data);
    final String digest = base64Encode(content);
    return digest;
  }

  Future<Response> sts() {
    final Map<String, String> map = {
      'Authorization': 'Bearer ${accountStore.accessToken}'
    };
    return httpClient.get<dynamic>(
      '/api/file/sts',
      options: Options(
        headers: map,
      ),
    );
  }

  Future<Response> addPicture(Map<String, Object?> data) {
    final Map<String, String> map = {
      'Authorization': 'Bearer ${accountStore.accessToken}'
    };
    return httpClient.post<dynamic>(
      '/api/picture',
      data: data,
      options: Options(
        headers: map,
      ),
    );
  }

  Future<Response> putObject(
    AssetEntity asset, {
    required String accessKeyID,
    required String accessKeySecret,
    required String stsToken,
    required String userId,
    void Function(double)? onSendProgress,
  }) async {
    final Dio dio = Dio();
    final Uint8List? btyes = await asset.originBytes;
    final Map<String, Object?> callback = {
      'callbackUrl': 'https://soapphoto.com/api/file/upload/oss/callback',
      'callbackBody':
          '{"userId":$userId,"originalname":\${x:originalname},"type":\${x:type},"object":\${object},"bucket":\${bucket},"etag":\${etag},"size":\${size},"mimetype":\${mimeType}}',
      'callbackBodyType': 'application/json',
    };
    final MediaType contentType;
    if (Platform.isIOS) {
      final String mimeType = mime(await asset.titleAsync)!;
      contentType = MediaType(
        mimeType.split('/')[0],
        mimeType.split('/')[1],
      );
    } else {
      contentType = MediaType(
        asset.mimeType!.split('/')[0],
        asset.mimeType!.split('/')[1],
      );
    }
    final Map<String, Object?> map = {
      'key': dotenv.env['OSS_PREFIX_PATH']! + uuid.v4(),
      'OSSAccessKeyId': accessKeyID,
      'success_action_status': '200',
      'signature': SignUtil.getSignature(accessKeySecret),
      'policy': SignUtil.getBase64Policy(),
      'x-oss-security-token': stsToken,
      'x:originalname': asset.title,
      'x:type': 'PICTURE',
      'callback': _base64Encode(jsonEncode(callback)),
      'file': MultipartFile.fromBytes(
        btyes!,
        filename: asset.title,
        contentType: contentType,
      ),
    };
    final FormData data = FormData.fromMap(map);
    return dio.post<dynamic>(
      'https://soapphoto.oss-cn-shanghai.aliyuncs.com',
      options: Options(
        responseType: ResponseType.plain,
      ),
      onSendProgress: (progress, total) {
        if (onSendProgress != null) {
          onSendProgress(progress / total);
        }
      },
      data: data,
    );
  }
}
