import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_indicator.dart';
import '../../widgets/retry_widget.dart';
import 'resource_state.dart';

/// Cubit has its own uses here like in [BalanceText] etc
typedef ResourceQueryBuilder<D> = Widget Function(
  BuildContext context,
  D data,
);

typedef ResourceQueryRetryBuilder<B> = void Function(B cubit);

typedef ResourceQueryOnSuccess<D> = void Function(
  BuildContext context,
  D data,
);

/// Responsible for handling loading, retrying
/// Useful for non-paged-list data
class QueryBuilder<T, B extends Cubit<ResourceState<T>>>
    extends StatelessWidget {
  /// On success this child is what will be shown.
  final ResourceQueryBuilder<T> builder;

  /// Responsible for things like bottom sheet, navigation.
  final ResourceQueryOnSuccess<T>? onSuccess;

  /// This will retry request in-case error occurred
  final ResourceQueryRetryBuilder<B>? retry;

  /// This will invoke current cubit wallet when build
  final ResourceQueryRetryBuilder<B>? initializer;

  /// Widget that will be shown instead of default loading indicator
  final Widget? loadingWidget;

  /// When request fail this will be responsible for handling re-fetch
  final Widget? retryWidget;

  const QueryBuilder({
    Key? key,
    required this.builder,
    required this.retry,
    this.onSuccess,
    this.loadingWidget,
    this.retryWidget,
    this.initializer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<B>(context);

    if (initializer != null) initializer!(cubit);

    return BlocConsumer<B, ResourceState>(
      listener: (context, state) {
        if (state.status == ResourceStatus.success) {
          if (onSuccess != null) {
            onSuccess!(context, state.data);
          }
        }
      },
      builder: (context, state) {
        if (state.status == ResourceStatus.error) {
          if (retryWidget != null) {
            //When that widget is clicked amazing things happen
            return InkWell(
              child: retryWidget,
              onTap: () => retry!(cubit),
            );
          }

          return RetryWidget(
            message: state.message,
            callback: () => retry!(cubit),
          );
        }

        if (state.status == ResourceStatus.success) {
          //Means there are data here.
          return RefreshIndicator(
            onRefresh: () async {
              if (retry != null) retry!(cubit);
            },
            child: builder(context, state.data),
          );
        }

        //Means state is initial or loading
        return loadingWidget ?? const LoadingIndicator();
      },
    );
  }
}
