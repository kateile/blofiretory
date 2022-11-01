import 'package:flutter/material.dart';

import 'button.dart';


/// This handles retrying events
class RetryWidget extends StatelessWidget {
  final VoidCallback callback;
  final String? message;

  const RetryWidget({
    Key? key,
    required this.callback,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            message ?? 'Oops! Something went wrong.',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            height: 16.0,
          ),
          Button(
            //padding: EdgeInsets.zero,
            onPressed: callback,
            title: 'Retry',
          )
        ],
      ),
    );
  }
}
