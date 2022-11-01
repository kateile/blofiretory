import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/button.dart';
import '../../widgets/loading_indicator.dart';
import '../widgets/helper.dart';
import 'resource_state.dart';

typedef ResourceMutationBuilder<B, D> = Widget Function(
  BuildContext context,
  B cubit,
  D? data,
);

typedef ResourceMutationOnSuccess<D> = void Function(
  BuildContext context,
  D data,
);

typedef ResourceMutationOnError = void Function(
  BuildContext context,
  String? message,
);

class MutationBuilder<T, B extends Cubit<ResourceState<T>>>
    extends StatelessWidget {
  /// This will build a widget that will be shown before mutation like form etc.
  final ResourceMutationBuilder<B, T> builder;

  /// If error occurred during mutation
  final ResourceMutationOnError? onError;

  /// What to do when mutation succeed
  final ResourceMutationOnSuccess<T>? onSuccess;

  /// This will be shown via snack bar when mutation succeed
  final String? successMessage;

  /// Custom loading widget
  final Widget? loadingWidget;
  final Color? loadingWidgetColor;

  /// If this is true [successMessage] will be rendered as body instead of
  /// snack bar
  final bool showSuccessBody; //todo alertType body|dialog|snackBar|sheet
  final bool pop; //todo alertType body|dialog|snackBar|sheet

  const MutationBuilder({
    Key? key,
    required this.builder,
    this.onError,
    this.onSuccess,
    this.successMessage,
    this.loadingWidget,
    this.loadingWidgetColor,
    this.showSuccessBody = false,
    this.pop = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, ResourceState>(
      listener: (context, state) {
        //todo use this mwanana
        // if (state.status == ResourceStatus.loading) {
        //   /// When this is invoked we fake loading and later call on success
        //   EasyLoading.show(
        //     status: 'loading...',
        //     maskType: EasyLoadingMaskType.black,
        //   );
        // } else {
        //   EasyLoading.dismiss();
        // }

        //Here onSuccess can have side effects like navigation
        if (state.status == ResourceStatus.success && !showSuccessBody) {
          if (onSuccess != null) {
            onSuccess!(context, state.data);
          } else {
            Helper.displaySuccess(
              context: context,
              message: successMessage ?? 'Success',
            );

            if (pop) Navigator.of(context).pop();
          }
        }

        if (state.status == ResourceStatus.error) {
          //If onError is null we use snack bar to show error.
          if (onError != null) {
            onError!(context, state.message);
          } else {
            Helper.displayError(
              context: context,
              message: state.message,
            );

            if (pop) Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        final cubit = BlocProvider.of<B>(context);

        if (state.status == ResourceStatus.loading) {
          return loadingWidget ?? const LoadingIndicator();
        }

        //todo should we also use alert here
        if (showSuccessBody && state.status == ResourceStatus.success) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                successMessage ?? 'Action Completed',
                //minFontSize: 24,
                maxLines: 2,
                //maxFontSize: 64,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Button(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                title: 'Go Back',
              )
            ],
          );
        }

        //We always show form when not loading.
        return builder(context, cubit, state.data);
      },
    );
  }
}
