import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum OauthType { github, google, weibo }
enum OauthStateType { login, authorize }

enum OauthActionType { login, authorize, active }

Uri getOauthUrl(
  OauthType type,
  OauthStateType state,
) {
  String authority = '';
  String unencodedPath = '';
  Map<String, String> query = {};
  String cb =
      'https://soapphoto.com/oauth/${EnumToString.convertToString(type)}/redirect';
  switch (type) {
    case OauthType.github:
      authority = 'github.com';
      unencodedPath = '/login/oauth/authorize';
      query = {
        'state': EnumToString.convertToString(state),
        'client_id': dotenv.env['OAUTH_GITHUB_CLIENT_ID']!,
        'redirect_uri': cb,
      };
      break;
    case OauthType.weibo:
      authority = 'api.weibo.com';
      unencodedPath = '/oauth2/authorize';
      query = {
        'state': EnumToString.convertToString(state),
        'client_id': dotenv.env['OAUTH_WEIBO_CLIENT_ID']!,
        'response_type': 'code',
        'redirect_uri': cb,
      };
      break;
    default:
  }
  return Uri.https(authority, unencodedPath, query);
}
