import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'BASIC_TOKEN')
  static const String basicToken = _Env.basicToken;

  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _Env.apiUrl;

  @EnviedField(varName: 'SENTRY_URL')
  static const String sentryUrl = _Env.sentryUrl;

  @EnviedField(varName: 'OSS_PREFIX_PATH')
  static const String ossPrefixPath = _Env.ossPrefixPath;

  @EnviedField(varName: 'OAUTH_GITHUB_CLIENT_ID')
  static const String oauthGithubClientId = _Env.oauthGithubClientId;

  @EnviedField(varName: 'OAUTH_GOOGLE_CLIENT_ID')
  static const String oauthGoogleClientId = _Env.oauthGoogleClientId;

  @EnviedField(varName: 'OAUTH_WEIBO_CLIENT_ID')
  static const String oauthWeiboClientId = _Env.oauthWeiboClientId;
}
