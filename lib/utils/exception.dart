import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:soap_app/widget/soap_toast.dart';

void captureException(dynamic throwable, {dynamic stackTrace}) {
  if (throwable is OperationException) {
    if (throwable.linkException is NetworkException) {
      print('网络错误：' + throwable.linkException.toString());
      // handle network issues, maybe
    } else {
      if (throwable.graphqlErrors.isNotEmpty) {
        if (throwable.graphqlErrors[0].extensions?['exception']['message'] ==
            'Unauthorized') {
          SoapToast.error('没权限！');
        }
      }
      Sentry.captureException(throwable);
      print(throwable);
    }
  }
}
