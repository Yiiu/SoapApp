import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/mutations.dart' as mutations;
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/soap_toast.dart';

class AccountProvider {
  AccountProvider() {
    httpClient = Dio()
      ..options.baseUrl = env['API_URL']!
      ..options.connectTimeout = 5000;
  }

  late Dio httpClient;

  Future<Response> oauth(dynamic data) {
    final Map<String, String> map = {
      'Authorization': 'Basic ${env['BASIC_TOKEN']}'
    };
    return httpClient.post<dynamic>(
      '/oauth/token',
      data: data,
      options: Options(
        headers: map,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }

  Future<Response> oauthToken(String type, dynamic data) {
    final Map<String, String> map = {
      'Authorization': 'Basic ${env['BASIC_TOKEN']}'
    };
    return httpClient.post<dynamic>(
      '/oauth/$type/token',
      data: data,
      options: Options(
        headers: map,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final variables = {
      'data': data,
    };
    final graphql.QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      graphql.MutationOptions(
        document: addFragments(mutations.updateProfile, [
          userFragment,
        ]),
        variables: variables,
        update: (graphql.GraphQLDataProxy cache,
            graphql.QueryResult? result) async {
          if (result?.data?['updateProfile'] != null) {
            accountStore.getUserInfo();
            // _setFollowInfoCache(cache, username);
          }
        },
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    } else {
      SoapToast.success('保存成功');
    }
  }
}
