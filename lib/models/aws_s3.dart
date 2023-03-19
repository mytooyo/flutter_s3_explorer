import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/bridge/bridge_definitions.dart';
import 'package:intl/intl.dart';

extension S3ObjectExtension on S3Object {
  String get formatKey {
    if (key.endsWith('/') && key.length != 1) {
      return key.substring(0, key.length - 1);
    }
    return key;
  }

  String get formatSize {
    if (size == null) return '-';

    final formatter = NumberFormat('#,###.0#');

    // GBまで表示する
    const gb = 1024 * 1024 * 1024;
    const mb = 1024 * 1024;
    const kb = 1024;

    if (size! >= gb) {
      return '${formatter.format((size! / gb))} GB';
    }
    if (size! >= mb) {
      return '${formatter.format((size! / mb))} MB';
    }
    if (size! >= kb) {
      return '${formatter.format((size! / kb))} KB';
    }
    return '${size!} B';
  }

  String get formatTime {
    if (lastModified == null) return '-';

    final datetime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(lastModified!),
    );

    return DateFormat('yyyy-MM-dd HH:mm').format(datetime);
  }

  Icon get icon {
    return Icon(
      isFolder ? Icons.folder_outlined : Icons.description_outlined,
      size: 16,
      color: isFolder ? Colors.orange[700] : Colors.green[700],
    );
  }
}
