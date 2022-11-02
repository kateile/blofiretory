import 'package:blofiretory/blofiretory.dart';
import 'package:equatable/equatable.dart';

enum PagedStatus { initial, success, failure, loading, end }
enum RefreshStatus { initial, success, failure, refreshing }

class PagedState<T> extends Equatable {
  PagedState({
    this.status = PagedStatus.initial,
    this.message,
    this.refreshStatus = RefreshStatus.initial,
    List<FireData<T>>? items,
    List<FireData<T>>? addedItems,
    List<FireData<T>>? updatedItems,
    this.updatedAt,
  })  : items = items ?? <FireData<T>>[],
        newItems = addedItems ?? <FireData<T>>[],
        updatedItems = updatedItems ?? <FireData<T>>[];

  final PagedStatus status;
  final RefreshStatus refreshStatus;
  final List<FireData<T>> items;

  /// New items from subscription/Mutation
  final List<FireData<T>> newItems;

  /// When item is updated, it is also added in this list
  final List<FireData<T>> updatedItems;
  final String? message;
  final int? updatedAt;

  PagedState<T> copyWith({
    PagedStatus? status,
    List<FireData<T>>? items,
    String? message,
    RefreshStatus? refreshStatus,
    List<FireData<T>>? addedItems,
    List<FireData<T>>? updatedItems,
    int? updatedAt,
  }) {
    return PagedState(
      status: status ?? this.status,
      items: items ?? this.items,
      message: message,
      refreshStatus: refreshStatus ?? RefreshStatus.initial,
      addedItems: addedItems ?? newItems,
      updatedItems: updatedItems ?? this.updatedItems,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        message,
        refreshStatus,
        updatedItems,
        updatedAt,
        newItems,
      ];
}
