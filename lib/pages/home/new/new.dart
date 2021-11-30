import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/home/new/widgets/list.dart';
import 'package:soap_app/utils/exception.dart';
import 'package:soap_app/utils/list.dart';
import 'package:soap_app/utils/query.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/list/error.dart';
import 'package:soap_app/widget/list/loading.dart';
import 'package:soap_app/widget/soap_toast.dart';

class NewView extends StatefulWidget {
  const NewView({
    Key? key,
    required this.refreshController,
  }) : super(key: key);

  final RefreshController refreshController;

  @override
  NewViewState createState() {
    return NewViewState();
  }
}

class NewViewState extends State<NewView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, int> query = {
    'page': 1,
    'pageSize': 30,
  };

  String type = 'NEW';

  static List<String> get tabs => <String>['最新', '热门'];

  final RefreshController _loadingRefreshController =
      RefreshController(initialRefresh: false);

  final RefreshController _errorRefreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 350)).then(
      (dynamic value) async {
        await widget.refreshController.requestRefresh(
          duration: const Duration(milliseconds: 150),
        );
        unawaited(HapticFeedback.lightImpact());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, Object> variables = {'query': query, 'type': type};
    return FixedAppBarWrapper(
      backdropBar: true,
      appBar: SoapAppBar(
        backdrop: true,
        centerTitle: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            FlutterI18n.translate(context, "nav.home"),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Container(
        color: theme.backgroundColor,
        child: Query(
          options: QueryOptions(
            fetchPolicy: FetchPolicy.cacheFirst,
            document: addFragments(
              pictures,
              [...pictureListFragmentDocumentNode],
            ),
            variables: variables,
          ),
          builder: (
            QueryResult result, {
            Refetch? refetch,
            FetchMore? fetchMore,
          }) {
            Future<void> onRefresh() async {
              final QueryResult? data = await refetch!();
              if (data != null && data.hasException) {
                widget.refreshController.refreshFailed();
                if (data.exception?.linkException != null) {
                  SoapToast.error('连接出错，请稍后再试！');
                }
                return;
              }
              widget.refreshController.refreshCompleted();
              unawaited(HapticFeedback.lightImpact());
            }

            if (result.hasException) {
              captureException(result.exception);
            }

            if (result.hasException && result.data == null) {
              return SoapListError(
                controller: _errorRefreshController,
                onRefresh: onRefresh,
                // message: result.exception.toString(),
              );
            }

            if (result.isLoading && result.data == null) {
              return SoapListLoading(
                controller: _loadingRefreshController,
              );
            }

            final ListData<Picture> listData = pictureListDataFormat(
              result.data!,
              label: 'pictures',
            );

            return NewList(
              controller: widget.refreshController,
              listData: listData,
              onRefresh: onRefresh,
              loading: (int page) async {
                final Map<String, Object> fetchMoreVariables = {
                  'query': {...query, 'page': page},
                  'type': type
                };
                await fetchMore!(
                  listFetchMoreOptions(
                    variables: fetchMoreVariables,
                    label: 'pictures',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
