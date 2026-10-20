import 'package:flutter/material.dart';

class AddFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const AddFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}