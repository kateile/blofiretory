import 'package:flutter/material.dart';

class LoadMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoadMoreButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        fillColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 30.0,
        ),
        padding: const EdgeInsets.all(10.0),
        shape: const CircleBorder(),
      ),
    );
  }
}
