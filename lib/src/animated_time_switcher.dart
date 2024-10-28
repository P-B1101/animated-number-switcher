part of '../animated_number_switcher.dart';

class AnimatedTimeSwitcher extends StatelessWidget {
  /// The duration to display in format of dd[splitter]hh[splitter]mm[splitter]ss
  final Duration time;

  /// The splitter text that use to show in stringified duration
  final String splitter;

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
  const AnimatedTimeSwitcher(
    this.time, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.splitter = ':',
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final params = time._getParams;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: params.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => Center(
          child: Text(
            splitter,
            style: style,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
          ),
        ),
        itemBuilder: (context, index) => Center(
          child: AnimatedNumberSwitcher.number(
            params[index],
            style: style,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
            duration: duration,
          ),
        ),
      ),
    );
  }
}

extension _DExt on Duration {
  List<String> get _getParams {
    List<String> params = [];
    if (inDays > 0) params.add(inDays.toString().padLeft(2, '0'));
    if (inHours > 0) params.add((inHours % 24).toString().padLeft(2, '0'));
    params.add((inMinutes % 60).toString().padLeft(2, '0'));
    params.add((inSeconds % 60).toString().padLeft(2, '0'));
    return params;
  }
}
