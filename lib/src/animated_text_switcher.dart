import 'package:flutter/material.dart';

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
    return Stack(
      children: [
        FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut).drive(Tween(begin: 1, end: 0)),
          child: Text(
            _oldText,
            style: widget.style,
            overflow: widget.overflow,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
          ),
        ),
        FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: Curves.ease),
          child: SlideTransition(
            position: CurvedAnimation(parent: _controller, curve: Curves.ease).drive(
              Tween(begin: const Offset(0, -1), end: const Offset(0, 0)),
            ),
            child: Text(
              _newText,
              style: widget.style,
              overflow: widget.overflow,
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
            ),
          ),
        ),
      ],
    );
  }
}
