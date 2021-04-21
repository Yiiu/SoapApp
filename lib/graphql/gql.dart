import 'package:gql/ast.dart';
import 'package:gql/operation.dart';

import 'fragments.dart';

DocumentNode addFragments(DocumentNode doc, List<DocumentNode> fragments) {
  final newDefinitions = Set<DefinitionNode>.from(doc.definitions);
  for (final frag in fragments) {
    newDefinitions.addAll(frag.definitions);
  }
  return DocumentNode(definitions: newDefinitions.toList(), span: doc.span);
}
