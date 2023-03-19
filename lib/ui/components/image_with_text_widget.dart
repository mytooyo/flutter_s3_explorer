import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageWithTextWidget extends StatelessWidget {
  const ImageWithTextWidget({
    super.key,
    required this.path,
    this.message,
    this.subMessage,
  });

  final String path;
  final String? message;
  final String? subMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              path,
              height: 240,
            ),
            const SizedBox(height: 40),
            Text(
              message ?? '',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (subMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    subMessage!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
