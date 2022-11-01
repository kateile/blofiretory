import 'package:equatable/equatable.dart';

/// This is used for showing what data has been added or updated in list
///
/// This is used in non paged lists like contactsList and walletsList
class ResourceListData<T> extends Equatable {
  ResourceListData({
    List<T>? items,
    List<T>? addedItems,
    List<T>? updatedItems,
  })  : items = items ?? <T>[],
        newItems = addedItems ?? <T>[],
        updatedItems = updatedItems ?? <T>[];

  /// This represents initial fetched data
  final List<T> items;

  /// New items from subscription/Mutation
  final List<T> newItems;

  /// When item is updated, it is also added in this list
  final List<T> updatedItems;

  @override
  List<Object?> get props => [items, newItems, updatedItems];

  ResourceListData<T> copyWith({
    List<T>? items,
    List<T>? addedItems,
    List<T>? updatedItems,
  }) {
    return ResourceListData(
      items: items ?? this.items,
      addedItems: addedItems ?? newItems,
      updatedItems: updatedItems ?? this.updatedItems,
    );
  }
}
