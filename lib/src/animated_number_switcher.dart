part of '../animated_number_switcher.dart';

enum _LengthChangeStatus {
  increase,
  decrease,
  none,
}

class AnimatedNumberSwitcher extends StatefulWidget {
  /// The text to display.
  final String text;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// How visual overflow should be handled.
  ///
  /// If this is null [TextStyle.overflow] will be used, otherwise the value
  /// from the nearest [DefaultTextStyle] ancestor will be used.
  final TextOverflow? overflow;

  /// Duration of all transitions
  final Duration? duration;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;
  const AnimatedNumberSwitcher(
    int number, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.duration,
  }) : text = '$number';

  const AnimatedNumberSwitcher._({
    required this.text,
    required this.style,
    required this.textAlign,
    required this.overflow,
    required this.maxLines,
    required this.duration,
  });

  factory AnimatedNumberSwitcher.number(
    String number, {
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Duration? duration,
  }) {
    final n = int.tryParse(number);
    assert(n != null, 'text `number` should be a number');

    return AnimatedNumberSwitcher._(
      text: number,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
      textAlign: textAlign,
      duration: duration,
    );
  }

  factory AnimatedNumberSwitcher.text(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Duration? duration,
  }) =>
      AnimatedNumberSwitcher._(
        text: text,
        maxLines: maxLines,
        overflow: overflow,
        style: style,
        textAlign: textAlign,
        duration: duration,
      );

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
      _controllers.add(AnimationController(vsync: this, duration: widget.duration ?? _duration));
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
          _controllers.add(AnimationController(vsync: this, duration: widget.duration ?? _duration));
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

  static const _duration = Duration(milliseconds: 300);
}
