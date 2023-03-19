import 'package:flutter/material.dart';

class CopyrightWidget extends StatelessWidget {
  const CopyrightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Application version: v0.0.1 - ©︎2023, mytooyo',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            height: 1.6,
            fontSize: 11,
          ),
      textAlign: TextAlign.center,
    );
  }
}
