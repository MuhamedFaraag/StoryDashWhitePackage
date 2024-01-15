import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

import '../../../domain/providers/notifiers/draggable_widget_notifier.dart';

class FontSelector extends StatelessWidget {
  const FontSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Consumer3<TextEditingNotifier, ControlNotifier,
        DraggableWidgetNotifier>(
      builder: (context, editorNotifier, controlNotifier, itemNotifier, child) {
        return Container(
          height: _size.width * 0.1,
          width: _size.width,
          alignment: Alignment.center,
          child: PageView.builder(
            controller: editorNotifier.fontFamilyController,
            itemCount: controlNotifier.fontList!.length,
            onPageChanged: (index) {
              if (itemNotifier.draggableWidget.isNotEmpty) {
                itemNotifier.draggableWidget.first.fontFamily = index;
                editorNotifier.fontFamilyIndex = index;
              }
              HapticFeedback.heavyImpact();
            },
            physics: const BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            pageSnapping: false,
            itemBuilder: (context, index) {
              return AnimatedOnTapButton(
                onTap: () {
                  editorNotifier.fontFamilyController.jumpToPage(index);
                  if (itemNotifier.draggableWidget.isNotEmpty) {
                    itemNotifier.draggableWidget.first.fontFamily = index;
                    editorNotifier.fontFamilyIndex = index;
                  }
                },
                child: Container(
                  height: _size.width * 0.1,
                  width: _size.width * 0.1,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: index == editorNotifier.fontFamilyIndex
                          ? Colors.white
                          : Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                  child: Center(
                    child: Text(
                      'Aa',
                      style: TextStyle(
                              fontFamily: controlNotifier.fontList![index],
                              package: controlNotifier.isCustomFontList
                                  ? null
                                  : 'stories_editor')
                          .copyWith(
                              color: index == editorNotifier.fontFamilyIndex
                                  ? Colors.red
                                  : Colors.white,
                              fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}