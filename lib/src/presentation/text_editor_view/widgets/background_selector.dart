import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

import '../../../domain/providers/notifiers/draggable_widget_notifier.dart';

class BackGroundSelector extends StatelessWidget {
  const BackGroundSelector({Key? key}) : super(key: key);

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
            controller: editorNotifier.backGroundSelectorController,
            itemCount: controlNotifier.gradientColors!.length,
            onPageChanged: (index) {
              controlNotifier.gradientIndex = index;
              HapticFeedback.heavyImpact();
            },
            physics: const BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            pageSnapping: false,
            itemBuilder: (context, index) {
              return AnimatedOnTapButton(
                onTap: () {
                  editorNotifier.backGroundSelectorController.jumpToPage(index);
                  controlNotifier.gradientIndex = index;
                },
                child: Container(
                  height: _size.width * 0.1,
                  width: _size.width * 0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: controlNotifier.mediaPath.isEmpty
                          ? LinearGradient(
                              colors: controlNotifier.gradientColors![index],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: index != controlNotifier.gradientIndex
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
