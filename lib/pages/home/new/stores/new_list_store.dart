import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/graphql/graphql.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/utils.dart';

part 'new_list_store.g.dart';

class NewListStore = _NewListStoreBase with _$NewListStore;

abstract class _NewListStoreBase with Store {
  graphql.ObservableQuery? _observableQuery;

  @observable
  List<Picture>? pictureList;

  @observable
  ListData<Picture>? listData;

  @observable
  int page = 1;

  @observable
  int pageSize = 30;

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
    final Map<String, dynamic> variables2 = {
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
    print('refesh');
    await GraphqlConfig.graphQLClient.query(graphql.QueryOptions(
      document: document,
      fetchPolicy: graphql.FetchPolicy.networkOnly,
      variables: {'query': query, 'type': type},
    ));
    // if (result.data != null) {
    //   setPictureList(result.data);
    // }
  }

  @action
  Future<void> fetchMore(int page) async {
    final graphql.QueryResult result =
        await GraphqlConfig.graphQLClient.query(graphql.QueryOptions(
      document: document,
      fetchPolicy: graphql.FetchPolicy.networkOnly,
      variables: {
        'query': {...query, 'page': page},
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
        pictureList = <Picture>[
          ...pictureList!,
          ...more.list,
        ];
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
        variables: {'query': query, 'type': type},
      ),
    );
    _observableQuery!.stream.listen((graphql.QueryResult result) {
      if (!result.isLoading && result.data != null) {
        if (result.hasException) {
          print(result.exception);
          return;
        }
        if (result.isLoading) {
          print('loading');
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
      final result = pictureListDataFormat(
        data,
        label: 'pictures',
      );
      page = result.page;
      pageSize = result.pageSize;
      count = result.count;
      if (!noList) {
        pictureList = result.list;
      }
      // listData = pictureListDataFormat(
      //   data,
      //   label: 'pictures',
      // );
    }
  }
}

NewListStore newListStore = NewListStore();
