import 'package:flutter/material.dart';

enum _LengthChangeStatus {
  increase,
  decrease,
  none,
}

class AnimatedNumberSwitcher extends StatefulWidget {
  final int number;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  const AnimatedNumberSwitcher(
    this.number, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  State<AnimatedNumberSwitcher> createState() => _AnimatedNumberSwitcherState();
}

class _AnimatedNumberSwitcherState extends State<AnimatedNumberSwitcher> with TickerProviderStateMixin {
  late final _controllers = <AnimationController>[];
  late int _changedLengh = 0;
  late List<String> _oldText = _getNumbers(widget.number);
  late List<String> _newText = _getNumbers(widget.number);
  var _status = _LengthChangeStatus.none;
  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant AnimatedNumberSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.number == widget.number) return;
    _oldText = _getNumbers(oldWidget.number);
    _newText = _getNumbers(widget.number);
    if (_oldText.length < _newText.length) {
      _status = _LengthChangeStatus.increase;
      _changedLengh = _newText.length - _oldText.length;
    } else if (_oldText.length > _newText.length) {
      _status = _LengthChangeStatus.decrease;
      _changedLengh = _oldText.length - _newText.length;
    } else {
      _status = _LengthChangeStatus.none;
    }
    _handleAnimations();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _oldText.length,
            (index) {
              final controller = _controllers.elementAtOrNull(index);
              if (controller == null) return const SizedBox();
              return FadeTransition(
                opacity: CurvedAnimation(parent: controller, curve: Curves.easeOut).drive(Tween(begin: 1, end: 0)),
                child: Text(
                  _oldText[index],
                  style: widget.style,
                  overflow: widget.overflow,
                  textAlign: widget.textAlign,
                  maxLines: widget.maxLines,
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _newText.length,
            (index) {
              final controller = _controllers.elementAtOrNull(index);
              if (controller == null) return const SizedBox();
              return FadeTransition(
                opacity: CurvedAnimation(parent: controller, curve: Curves.ease).drive(Tween(begin: .25, end: 1)),
                child: SlideTransition(
                  position: CurvedAnimation(parent: controller, curve: Curves.ease).drive(
                    Tween(begin: const Offset(0, -1), end: const Offset(0, 0)),
                  ),
                  child: Text(
                    _newText[index],
                    style: widget.style,
                    overflow: widget.overflow,
                    textAlign: widget.textAlign,
                    maxLines: widget.maxLines,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<String> _getNumbers(int number) => number.toString().split('');

  void _initControllers() {
    for (int i = 0; i < _newText.length; i++) {
      _controllers.add(AnimationController(vsync: this, duration: const Duration(milliseconds: 300)));
    }
  }

  void _disposeControllers() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
      _controllers.removeAt(i);
    }
  }

  void _handleAnimations() {
    switch (_status) {
      case _LengthChangeStatus.increase:
        for (int i = 0; i < _changedLengh; i++) {
          _controllers.add(AnimationController(vsync: this, duration: const Duration(milliseconds: 300)));
        }
        break;
      case _LengthChangeStatus.decrease:
        for (int i = 0; i < _changedLengh; i++) {
          final controller = _controllers.removeLast();
          controller.dispose();
        }
        break;
      case _LengthChangeStatus.none:
        break;
    }
    for (int i = 0; i < _controllers.length; i++) {
      if (_oldText.elementAtOrNull(i) != _newText.elementAtOrNull(i)) _controllers.elementAtOrNull(i)?.forward(from: 0);
    }
  }
}
