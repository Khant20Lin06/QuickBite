import 'package:flutter/material.dart';

class InlineLoadingState extends StatelessWidget {
  const InlineLoadingState({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 10),
        Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
