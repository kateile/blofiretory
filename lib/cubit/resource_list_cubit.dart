import 'resource_cubit.dart';
import 'resource_list_data.dart';

class ResourceListCubit<T> extends ResourceCubit<ResourceListData<T>> {
  ResourceListCubit() : super();

  addItem(T item) {
    final list = state.data?.items;
    list?.insert(0, item);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: [item],
      updatedItems: [],
    ));
  }

  addItems(List<T> items) {
    final list = state.data?.items;
    list?.insertAll(0, items);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: items,
      updatedItems: [],
    ));
  }

  updateItem(T Function(List<T> e) test, T newItem) {
    final list = state.data?.items;

    try {
      final old = test(list ?? <T>[]);
      list?.remove(old);
    } catch (_) {}

    list?.insert(0, newItem);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: [], //So indicator will be in one place
      updatedItems: [newItem],
    ));
  }

  T? findItem(bool Function(T e) test) {
    final list = state.data?.items;

    try {
      final old = list?.firstWhere(test);
      return old;
    } catch (_) {
      return null;
    }
  }
}
