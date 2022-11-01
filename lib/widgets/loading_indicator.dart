import 'package:flutter/material.dart';

enum LoadingType { small, normal }

//todo add text here.
class LoadingIndicator extends StatelessWidget {
  final LoadingType type;

  const LoadingIndicator({
    Key? key,
  })  : type = LoadingType.normal,
        super(key: key);

  const LoadingIndicator.small({
    Key? key,
  })  : type = LoadingType.small,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == LoadingType.small) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 16.0,
          left: 16.0,
        ),
        child: Container(
          alignment: Alignment.center,
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.all(36.0), //important in BottomSheets
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
