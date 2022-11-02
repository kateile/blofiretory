import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef PagedListExecutor<T> = Future<QuerySnapshot<T>> Function(
  BuildContext context,
  int skip,
);

typedef PagedListWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

class AutoPagedList<T> extends StatefulWidget {
  final PagedListWidgetBuilder<T> widgetBuilder;
  final PagedListExecutor<T> executor; //executor
  final bool grid;
  final int crossAxisCount;

  const AutoPagedList({
    Key? key,
    required this.widgetBuilder,
    required this.executor,
    this.grid = false,
    this.crossAxisCount = 2,
  }) : super(key: key);

  @override
  AutoPagedListState createState() => AutoPagedListState<T>();
}

class AutoPagedListState<T> extends State<AutoPagedList<T>> {
  static const _pageSize = 10;

  final PagingController<int, T> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final QuerySnapshot<T> result = await widget.executor(context, pageKey);

      final List<T> newData = result.docs.cast<T>();

      final isLastPage = newData.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newData);
      } else {
        final nextPageKey = pageKey + newData.length;
        print('nextPageKey: $nextPageKey');
        _pagingController.appendPage(newData, nextPageKey);
      }
    } catch (error) {
      print('Paging exception: $error');
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    //todo is it working?
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: Builder(
        builder: (context) {
          if (widget.grid) {
            return PagedGridView<int, T>(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
              ),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<T>(
                itemBuilder: (context, item, index) {
                  return widget.widgetBuilder(context, item);
                },
              ),
            );
          }

          return PagedListView<int, T>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<T>(
              itemBuilder: (context, item, index) {
                return widget.widgetBuilder(context, item);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
