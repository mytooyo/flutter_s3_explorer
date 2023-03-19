import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

BuildContext? _loadingContext;

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      _loadingContext = context;
      return const LoadingView();
    },
  );
}

void hideLoading() {
  if (_loadingContext != null) {
    Navigator.of(_loadingContext!).pop();
    _loadingContext = null;
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: LoadingAnimationWidget.newtonCradle(
          color: Colors.white,
          size: 120,
        ),
      ),
    );
  }
}
