import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final ButtonStyle? style;

  const Button({
    Key? key,
    required this.onPressed,
    required this.title,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: style,
            onPressed: onPressed,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
