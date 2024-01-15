import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_colors.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';
import '../../domain/providers/notifiers/draggable_widget_notifier.dart';

class TextColorSelector extends StatelessWidget {
  const TextColorSelector({Key? key}) : super(key: key);

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
            controller: editorNotifier.textColorSelectorController,
            itemCount: controlNotifier.colorList!.length,
            onPageChanged: (index) {
              if (itemNotifier.draggableWidget.isNotEmpty) {
                itemNotifier.draggableWidget.first.textColor =
                    controlNotifier.colorList![index];
                editorNotifier.fontFamilyIndex = editorNotifier.fontFamilyIndex;
              }
              HapticFeedback.heavyImpact();
            },
            physics: const BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            pageSnapping: false,
            itemBuilder: (context, index) {
              return AnimatedOnTapButton(
                onTap: () {
                  editorNotifier.textColorSelectorController.jumpToPage(index);
                  if (itemNotifier.draggableWidget.isNotEmpty) {
                    itemNotifier.draggableWidget.first.textColor =
                        controlNotifier.colorList![index];
                    editorNotifier.fontFamilyIndex =
                        editorNotifier.fontFamilyIndex;
                  }
                },
                child: Container(
                  height: _size.width * 0.1,
                  width: _size.width * 0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.defaultColors[index],
                      shape: BoxShape.circle,
                      border: itemNotifier.draggableWidget.isEmpty
                          ? Border.all(
                              color: Colors.white,
                            )
                          : Border.all(
                              color: controlNotifier.colorList![index] !=
                                      itemNotifier
                                          .draggableWidget.first.textColor
                                  ? Colors.white
                                  : Colors.black,
                            )),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
