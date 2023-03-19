import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/profiles/views/update_profile_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/copyright_widget.dart';

class InitView extends ConsumerStatefulWidget {
  const InitView({super.key});

  @override
  ConsumerState<InitView> createState() => _InitViewState();
}

class _InitViewState extends ConsumerState<InitView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Flutter AWS S3 Explorer',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      child: Opacity(
                        opacity: 0.8,
                        child: Text(
                          'Enter your AWS profile information to get started.\nThis is the content to be registered when using AWS CLI (`aws configure`).',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.6,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const UpdateProfileView(initAdd: true),
                  ],
                ),
              ),
            ),
            Container(
              height: 48,
              alignment: Alignment.center,
              child: const CopyrightWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
