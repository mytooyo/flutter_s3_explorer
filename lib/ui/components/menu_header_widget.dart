import 'package:flutter/material.dart';

class MenuHeaderWidget extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String text;

  const MenuHeaderWidget({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      margin: const EdgeInsets.only(top: 16),
      height: 32,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.08,
                ),
          ),
        ],
      ),
    );
  }
}
