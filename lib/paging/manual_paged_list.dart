import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/widgets.dart';
import '../cubit/fire_data.dart';
import '../widgets/snack_bars.dart';
import 'bottom_loader.dart';
import 'load_more_button.dart';
import 'paged_cubit.dart';
import 'paged_state.dart';

class ManualPagedMeta {
  final bool isNew;
  final bool isUpdated;
  final bool isLast;
  final int index;

  ManualPagedMeta({
    required this.isNew,
    required this.isUpdated,
    required this.isLast,
    required this.index,
  });
}

typedef ManualPagedWidgetBuilder<T> = Widget Function(
  BuildContext context,
  FireData<T> data,
  ManualPagedMeta meta,
);

///this is for showing current balance and 10 recent payments made.
class ManualPagedList<C extends PagedCubit<T>, T> extends StatelessWidget {
  final ManualPagedWidgetBuilder<T> builder;
  final bool reverse;

  const ManualPagedList({
    Key? key,
    required this.builder,
    this.reverse = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<C, PagedState<T>>(
      listener: (context, state) {
        if (state.refreshStatus == RefreshStatus.failure) {
          displayError(
            context: context,
            message: state.message ?? "Failed",
          );
        }

        if (state.refreshStatus == RefreshStatus.success) {
          displaySuccess(
            context: context,
            message: 'Refreshed!',
            duration: 1,
          );
        }
      },
      builder: (context, state) {
        final C bloc = context.watch<C>();

        return RefreshIndicator(
          onRefresh: () async => !reverse
              ? bloc.refresh()
              : () {
                  //todo or pass custom refresh which will be used in history alone
                  //todo find a way to pass connection parameter in history refresh and
                  //  remove this bloc
                },
          child: ListView.builder(
            reverse: reverse,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (BuildContext context, int index) {
              if (index == state.items.length) {
                if (state.status == PagedStatus.loading) {
                  return const BottomLoader();
                }
                if (state.status == PagedStatus.failure) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RetryWidget(
                      message: state.message,
                      callback: () => bloc.fetch(),
                    ),
                  );
                }
                if (state.status == PagedStatus.end) {
                  //End of the list
                  return const Center(
                    child: Text(
                      '....',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  );
                } else {
                  //More data could be available.
                  return LoadMoreButton(onPressed: bloc.fetch);
                }
              } else {
                final item = state.items[index];

                return builder(
                  context,
                  item,
                  ManualPagedMeta(
                    isUpdated: state.updatedItems.contains(item),
                    isNew: state.newItems.contains(item),
                    isLast: index == 0, //This is reversed
                    index: index,
                  ),
                );
              }
            },
            itemCount: state.items.length + 1, //we always have one more widget
          ),
        );
      },
    );
  }
}
