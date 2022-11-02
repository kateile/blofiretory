import 'dart:async';

import 'package:blofiretory/blofiretory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef PagedQueryExecutor<T> = Future<QuerySnapshot<T>> Function(
  String? last,
);

typedef PagedRefreshExecutor<T> = Future<QuerySnapshot<T>> Function();

///
abstract class PagedCubit<R> extends Cubit<PagedState<R>> {
  PagedCubit() : super(PagedState());

  void paginate({
    required PagedQueryExecutor<R> executor,
  }) async {
    /// showing loading with other contents intact.
    emit(state.copyWith(status: PagedStatus.loading));

    if (state.status == PagedStatus.end) emit(state);

    /// This is inner function
    Future<QuerySnapshot<R>> fetch(String? skip) async {
      final result = await executor(skip);
      return result;
    }

    try {
      if (state.status == PagedStatus.initial) {
        final result = await fetch(null);
        final items = result.docs
            .map((e) => FireData(object: e.data(), id: e.id))
            .toList();

        emit(
          state.copyWith(
            status: _hasReachedEnd(items.length),
            items: items,
          ),
        );
      }

      final last = state.items.last.id;
      final result = await fetch(last);

      final items =
          result.docs.map((e) => FireData(object: e.data(), id: e.id)).toList();

      if (items.isEmpty) {
        emit(state.copyWith(status: PagedStatus.end));
      } else {
        emit(state.copyWith(
          status: _hasReachedEnd(items.length),
          items: List.of(state.items)..addAll(items),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PagedStatus.failure,
        message: e.toString(),
      ));
    }
  }

  void handleRefresh({
    required PagedRefreshExecutor<R> executor,
  }) async {
    final previousItems = state.items;

    /// showing is refreshing
    emit(state.copyWith(refreshStatus: RefreshStatus.refreshing));

    /// This is inner function
    Future<QuerySnapshot<R>> fetch() async {
      final result = await executor();
      return result;
    }

    try {
      /// fetch from zero
      final result = await fetch();
      final items =
          result.docs.map((e) => FireData(object: e.data(), id: e.id)).toList();

      /// Here we are not appending items we just set new ones.
      if (items.isEmpty) {
        emit(state.copyWith(
          status: PagedStatus.end,
          items: [],
          refreshStatus: RefreshStatus.success,
        ));
      } else {
        emit(state.copyWith(
          status: _hasReachedEnd(items.length),
          items: items,
          refreshStatus: RefreshStatus.success,
        ));
      }
    } catch (e) {
      //todo parse and format message.
      /// If there is error we just show previous items
      emit(state.copyWith(
        items: previousItems,
        refreshStatus: RefreshStatus.failure,
        message: e.toString(),
      ));
    }
  }

  void addItems(List<FireData<R>> newItems) async {
    final previousItems = state.items;

    emit(
      state.copyWith(
        items: [...newItems, ...previousItems],
        addedItems: newItems,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void addItem(FireData<R> newItem) async {
    emit(
      state.copyWith(
        items: [newItem, ...state.items],

        ///So that all items added will be shown as new
        addedItems: [newItem],
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Useful for deletable items eg contacts and requests
  void removeItem(FireData<R> item) async {
    final items = state.items;

    items.remove(item);

    emit(
      state.copyWith(
        items: items,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  PagedStatus _hasReachedEnd(int itemsCount) {
    return itemsCount < 10 ? PagedStatus.end : PagedStatus.success;
  }

  /// This is what is overridden and invoked to start and continue pagination
  fetch();

  refresh();
}
