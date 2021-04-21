import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

DocumentNode pictures = gql(r'''
  query Pictures() {
    pictures(query: {}) {
      data {
        ...PictureFragment
      }
    }
  }
''');
