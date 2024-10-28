import 'package:flutter/material.dart';

import 'animated_number_switcher.dart';

class AnimatedTimeSwitcher extends StatelessWidget {
  final Duration time;
  final String splitter;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  const AnimatedTimeSwitcher(
    this.time, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.splitter = ':',
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
          child: AnimatedNumberSwitcher.stringNumber(
            params[index],
            style: style,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
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
