import 'package:flutter/material.dart';

extension MediaQueryExtension on MediaQueryData {
  bool get isSmall {
    return size.width < 440;
  }
}
