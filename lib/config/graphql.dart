import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/utils/auth.dart';
import 'package:soap_app/utils/storage.dart';

class AuthLink extends Link {
  AuthLink()
      : super(
          request: (Operation operation, [NextLink forward]) {
            StreamController<FetchResult> controller;

            Future<void> onListen() async {
              try {
                final String token = AuthUtil.getToken();
                operation.setContext(<String, Map<String, String>>{
                  'headers': <String, String>{
                    'accept': 'application/json',
                    'Authorization': '''Bearer $token'''
                  },
                });
              } catch (error) {
                controller.addError(error);
              }

              await controller.addStream(forward(operation));
              await controller.close();
            }

            controller = StreamController<FetchResult>(onListen: onListen);

            return controller.stream;
          },
        );
}

class GraphqlConfig {
  static HttpLink httpLink = HttpLink(uri: 'https://soapphoto.com/graphql');

  static GraphQLClient graphQLClient = GraphQLClient(
    link: AuthLink().concat(httpLink),
    cache: NormalizedInMemoryCache(
      dataIdFromObject: typenameDataIdFromObject,
    ),
  );

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    graphQLClient,
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: NormalizedInMemoryCache(
        dataIdFromObject: typenameDataIdFromObject,
      ),
      link: httpLink,
    );
  }
}
