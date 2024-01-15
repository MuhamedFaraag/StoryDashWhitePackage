// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil();
    FocusNode _textNode = FocusNode();
    return Consumer2<TextEditingNotifier, ControlNotifier>(
      builder: (context, editorNotifier, controlNotifier, child) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenUtil.screenWidth - 100,
            ),
            child: IntrinsicWidth(

                /// textField Box decoration
                child: Stack(
              alignment: Alignment.center,
              children: [
                _textField(
                  editorNotifier: editorNotifier,
                  textNode: _textNode,
                  controlNotifier: controlNotifier,
                  paintingStyle: PaintingStyle.stroke,
                )
              ],
            )),
          ),
        );
      },
    );
  }

  Widget _textField({
    required TextEditingNotifier editorNotifier,
    required FocusNode textNode,
    required ControlNotifier controlNotifier,
    required PaintingStyle paintingStyle,
  }) {
    return TextField(
      focusNode: textNode,
      autofocus: true,
      maxLength: 250,
      textInputAction: TextInputAction.newline,
      controller: editorNotifier.textController,
      textAlign: editorNotifier.textAlign,
      style: TextStyle(
              fontFamily:
                  controlNotifier.fontList![editorNotifier.fontFamilyIndex],
              package:
                  controlNotifier.isCustomFontList ? null : 'stories_editor',
              backgroundColor: Colors.redAccent)
          .copyWith(
        color: controlNotifier.colorList![editorNotifier.textColor],
        fontSize: editorNotifier.textSize,
        background: Paint()
          ..strokeWidth = 20.0
          ..color = editorNotifier.backGroundColor
          ..style = paintingStyle
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1),
      ),
      cursorColor: controlNotifier.colorList![editorNotifier.textColor],
      minLines: 1,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: null,
      onChanged: (value) {
        editorNotifier.text = value;
      },
    );
  }
}
