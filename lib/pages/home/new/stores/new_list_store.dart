import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:mobx/mobx.dart';

import '../../../../config/config.dart';
import '../../../../graphql/graphql.dart';
import '../../../../model/picture.dart';
import '../../../../utils/list.dart';
import '../../../../utils/utils.dart';

part 'new_list_store.g.dart';

// ignore: library_private_types_in_public_api
class NewListStore = _NewListStoreBase with _$NewListStore;

class ListStoreBase {
  ObservableList<Picture>? pictureList;
  int page = 1;
  int pageSize = 30;
  int count = 0;
}

abstract class _NewListStoreBase with Store implements ListStoreBase {
  graphql.ObservableQuery? _observableQuery;

  @override
  @observable
  @ObservablePictureListConverter()
  ObservableList<Picture>? pictureList;

  @observable
  ListData<Picture>? listData;

  @override
  @observable
  int page = 1;

  @override
  @observable
  int pageSize = 30;

  @override
  @observable
  int count = 0;

  @computed
  int get morePage {
    return (count / pageSize).ceil();
  }

  @computed
  bool get noMore {
    return page + 1 >= morePage;
  }

  Map<String, int> query = {
    'page': 1,
    'pageSize': 30,
  };
  String type = 'NEW';

  DocumentNode document = addFragments(
    pictures,
    [...pictureListFragmentDocumentNode],
  );

  @action
  void init() {
    setQueryCache();
    // if (!setQueryCache(data.id)) {
    // picture = data;
    // }
  }

  bool setQueryCache() {
    final Map<String, dynamic> variables2 = <String, dynamic>{
      'query': query,
      'type': type,
    };
    final graphql.Request queryRequest = graphql.Request(
      operation: graphql.Operation(
        document: document,
      ),
      variables: variables2,
    );
    final Map<String, dynamic>? data =
        GraphqlConfig.graphQLClient.readQuery(queryRequest);
    if (data != null) {
      setPictureList(data);
      // picture = Picture.fromJson(data['picture'] as Map<String, dynamic>);
      return true;
    }
    return false;
  }

  Future<void> refresh() async {
    await GraphqlConfig.graphQLClient.query(graphql.QueryOptions(
      document: document,
      fetchPolicy: graphql.FetchPolicy.networkOnly,
      variables: <String, dynamic>{'query': query, 'type': type},
    ));
    // if (result.data != null) {
    //   setPictureList(result.data);
    // }
  }

  @action
  Future<void> fetchMore() async {
    final graphql.QueryResult result =
        await GraphqlConfig.graphQLClient.query(graphql.QueryOptions(
      document: document,
      fetchPolicy: graphql.FetchPolicy.networkOnly,
      variables: <String, dynamic>{
        'query': {...query, 'page': page + 1},
        'type': type
      },
    ));
    // try {
    if (result.data != null) {
      final ListData<Picture> more = pictureListDataFormat(
        result.data!,
        label: 'pictures',
      );
      if (pictureList != null) {
        pictureList = ObservableList<Picture>.of([
          ...pictureList!,
          ...more.list,
        ]);
        setPictureList(result.data, noList: true);
      }
    }
    // } catch (err) {
    //   print(err);
    // }
  }

  Future<void> watchQuery() async {
    await Future<void>.delayed(Duration(milliseconds: screenDelayTimer));
    _observableQuery = GraphqlConfig.graphQLClient.watchQuery(
      graphql.WatchQueryOptions(
        document: document,
        fetchResults: true,
        fetchPolicy: graphql.FetchPolicy.networkOnly,
        variables: <String, dynamic>{'query': query, 'type': type},
      ),
    );
    _observableQuery!.stream.listen((graphql.QueryResult result) {
      if (!result.isLoading && result.data != null) {
        if (result.hasException) {
          print(result.exception);
          return;
        }
        if (result.isLoading) {
          return;
        }
        setPictureList(result.data);
        // setPicture(result.data!['picture'] as Map<String, dynamic>?);
      }
    });
  }

  // 设置list data
  @action
  void setPictureList(Map<String, dynamic>? data, {bool noList = false}) {
    if (data != null) {
      final ListData<Picture> result = pictureListDataFormat(
        data,
        label: 'pictures',
      );
      page = result.page;
      pageSize = result.pageSize;
      count = result.count;
      if (!noList) {
        pictureList = ObservableList<Picture>.of(result.list);
      }
      // listData = pictureListDataFormat(
      //   data,
      //   label: 'pictures',
      // );
    }
  }
}

NewListStore newListStore = NewListStore();
