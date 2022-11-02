import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'resource_state.dart';

/// This can be both query and mutation since they return similar result.
typedef QueryExecutor<T> = Future<T> Function();

/// Parser must return expected result.
typedef ResultParser<T> = T Function(T result);

/// Function which will be invoked after successful mutation/query
typedef OnSuccessCallback<T> = Future<void> Function(T result);
typedef OnExceptionCallback = void Function(String);

/// This abstracts calling repository and handling result.
class ResourceCubit<T> extends Cubit<ResourceState<T>> {
  ResourceCubit() : super(const ResourceState());

  execute({
    required QueryExecutor<T> executor,
    OnSuccessCallback<T>? onSuccess,
    OnExceptionCallback? onException,
  }) async {
    try {
      /// For showing loading
      emit(
        const ResourceState(
          status: ResourceStatus.loading,
        ),
      );

      /// Invoke query/mutation
      final T data = await executor();

      if (onSuccess != null) {
        /// This is useful in auth
        await onSuccess(data);
      }

      emit(
        ResourceState(
          status: ResourceStatus.success,
          data: data,
        ),
      );
    } catch (e) {
      log('caught exception ${e.toString()}');

      // FirebaseAnalytics.instance
      //     .logEvent(
      //       name: 'resource_cubit_exception',
      //       parameters: {
      //         'exception': e.toString(),
      //       },
      //     )
      //     .then((_) {})
      //     .catchError((_) {});

      emit(
        ResourceState(
          status: ResourceStatus.error,
          exception: e,
        ),
      );
    }
  }

  /// This will update the previous fetched result
  update(T? newData) {
    if (newData != null) {
      emit(
        ResourceState(
          status: ResourceStatus.success,
          data: newData,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }
}
