import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String text;
  final Widget? below;
  final double? fontSize;

  const Message({
    Key? key,
    required this.text,
    this.below,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 24,
        color: Theme.of(context).secondaryHeaderColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize ?? 24,
                ),
                textAlign: TextAlign.center,
              ),
              if (below != null) ...[
                const Divider(),
                below!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
