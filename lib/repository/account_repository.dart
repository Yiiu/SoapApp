import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:soap_app/env/env.dart';
import '../config/graphql.dart';
import '../graphql/fragments.dart';
import '../graphql/gql.dart';
import '../graphql/mutations.dart' as mutations;
import '../store/index.dart';
import '../widget/soap_toast.dart';

class AccountProvider {
  AccountProvider() {
    httpClient = Dio()
      ..options.baseUrl = Env.apiUrl
      ..options.connectTimeout = const Duration(seconds: 5);
  }

  late Dio httpClient;

  Future<Response> oauth(dynamic data) {
    final Map<String, String> map = {
      'Authorization': 'Basic ${Env.basicToken}'
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
      'Authorization': 'Basic ${Env.basicToken}'
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
    final Map<String, Map<String, dynamic>> variables = {
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
