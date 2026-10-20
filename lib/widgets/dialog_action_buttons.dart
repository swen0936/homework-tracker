import 'package:flutter/material.dart';

class DialogActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onAdd;

  const DialogActionButtons({
    super.key,
    required this.onCancel,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}