import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LinkText extends StatefulWidget {
  const LinkText({
    super.key,
    required this.text,
    this.style,
    this.height,
    required this.onClick,
  });

  final String text;
  final double? height;
  final TextStyle? style;
  final void Function()? onClick;

  @override
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> with TickerProviderStateMixin {
  late AnimationController controller;

  bool get disabled => widget.onClick == null;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? Theme.of(context).textTheme.bodyMedium;
    return GestureDetector(
      onTap: widget.onClick,
      child: MouseRegion(
        onEnter: (event) {
          if (!disabled) controller.forward();
        },
        onExit: (event) {
          if (!disabled) controller.reverse();
        },
        cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              height: widget.height,
              width: lineWidth(widget.text, style!),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child!,
                  SizeTransition(
                    sizeFactor: controller
                        .drive(
                          CurveTween(curve: Curves.easeInCubic),
                        )
                        .drive(
                          Tween<double>(begin: 0, end: 1),
                        ),
                    axisAlignment: -1.0,
                    axis: Axis.horizontal,
                    child: Container(
                      width: lineWidth(widget.text, style),
                      height: 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: style.color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Text(
            widget.text,
            style: style,
          ),
        ),
      ),
    );
  }

  // TextWidgetのwidthを取得
  double lineWidth(String text, TextStyle style) {
    final renderParagraph = RenderParagraph(
      TextSpan(
        text: text,
        style: TextStyle(
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    return renderParagraph.getMaxIntrinsicWidth(style.fontSize!);
  }
}
