import 'package:flutter/material.dart';

import 'switcher_widget.dart';

enum _LengthChangeStatus {
  increase,
  decrease,
  none,
}

class AnimatedNumberSwitcher extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  const AnimatedNumberSwitcher(
    int number, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  }) : text = '$number';

  const AnimatedNumberSwitcher._({
    required this.text,
    required this.style,
    required this.textAlign,
    required this.overflow,
    required this.maxLines,
  });

  factory AnimatedNumberSwitcher.stringNumber(
    String number, {
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    final n = int.tryParse(number);
    assert(n != null, 'text `number` should be a number');

    return AnimatedNumberSwitcher._(
      text: number,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
      textAlign: textAlign,
    );
  }

  @override
  State<AnimatedNumberSwitcher> createState() => _AnimatedNumberSwitcherState();
}

class _AnimatedNumberSwitcherState extends State<AnimatedNumberSwitcher> with TickerProviderStateMixin {
  late final _controllers = <AnimationController>[];
  late int _changedLengh = 0;
  late List<String> _oldText = _getNumbers(widget.text);
  late List<String> _newText = _getNumbers(widget.text);
  var _status = _LengthChangeStatus.none;
  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant AnimatedNumberSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text) return;
    _oldText = _getNumbers(oldWidget.text);
    _newText = _getNumbers(widget.text);
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
    return SwitcherWidget(
      controllers: _controllers,
      newChars: _newText,
      oldChars: _oldText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }

  List<String> _getNumbers(String number) => number.split('');

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
