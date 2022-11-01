import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 32,
      icon: Icon(icon),
      onPressed: onPressed,
      color: Theme.of(context).listTileTheme.iconColor,
    );
  }
}
