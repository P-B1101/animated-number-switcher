import 'package:flutter/material.dart';

import 'switcher_widget.dart';

class AnimatedTextSwitcher extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  const AnimatedTextSwitcher(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  State<AnimatedTextSwitcher> createState() => _AnimatedTextSwitcherState();
}

class _AnimatedTextSwitcherState extends State<AnimatedTextSwitcher> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  late String _oldText = widget.text;
  late String _newText = widget.text;

  @override
  void didUpdateWidget(covariant AnimatedTextSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldText = oldWidget.text;
    _newText = widget.text;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwitcherWidget(
      controllers: [_controller],
      newChars: [_newText],
      oldChars: [_oldText],
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
