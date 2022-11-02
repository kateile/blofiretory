import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        alignment: Alignment.center,
        child: const Center(
          child: SizedBox(
            width: 33,
            height: 33,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
