import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/sevices/save_as_image.dart';
import 'package:stories_editor/src/presentation/utils/modal_sheets.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';
import 'package:stories_editor/src/presentation/widgets/tool_button.dart';

import '../../domain/models/editable_items.dart';
import '../../domain/providers/notifiers/scroll_notifier.dart';
import '../../domain/providers/notifiers/text_editing_notifier.dart';
import '../utils/constants/app_enums.dart';

class TopTools extends StatefulWidget {
  final GlobalKey contentKey;
  final BuildContext context;
  final String language;
  final bool isDrag;
  const TopTools(
      {Key? key,
      required this.contentKey,
      required this.context,
      required this.language,
      required this.isDrag})
      : super(key: key);

  @override
  _TopToolsState createState() => _TopToolsState();
}

class _TopToolsState extends State<TopTools> {
  @override
  Widget build(BuildContext context) {
    return Consumer5<ControlNotifier, PaintingNotifier, DraggableWidgetNotifier,
        TextEditingNotifier, ScrollNotifier>(
      builder: (_, controlNotifier, paintingNotifier, itemNotifier,
          editorNotifier, scrollNotifier, __) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.w),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// close button
                ToolButton(
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    backGroundColor: Colors.black12,
                    onTap: () async {
                      var res = await exitDialog(
                          context: widget.context,
                          language: widget.language,
                          contentKey: widget.contentKey);
                      if (res) {
                        Navigator.pop(context);
                      }
                    }),
                //   if (controlNotifier.mediaPath.isEmpty)
                _selectColor(
                    controlProvider: controlNotifier,
                    onTap: () {
                      editorNotifier.setIsFamilyNotDrag = false;
                      editorNotifier.setFontColorNotDrag = false;
                      editorNotifier.setIsBackGroundNotDrag =
                          !editorNotifier.isBackGroundNotDrag;
                    }),
                ToolButton(
                    child: const ImageIcon(
                      AssetImage('assets/icons/download.png',
                          package: 'stories_editor'),
                      color: Colors.white,
                      size: 20,
                    ),
                    backGroundColor: Colors.black12,
                    onTap: () async {
                      editorNotifier.setIsFamilyNotDrag = false;
                      editorNotifier.setIsBackGroundNotDrag = false;
                      editorNotifier.setFontColorNotDrag = false;
                      if (paintingNotifier.lines.isNotEmpty ||
                          itemNotifier.draggableWidget.isNotEmpty) {
                        var response = await takePicture(
                            contentKey: widget.contentKey,
                            context: context,
                            saveToGallery: true);
                        if (response) {
                          Fluttertoast.showToast(msg: 'Successfully saved');
                        } else {
                          Fluttertoast.showToast(msg: 'Error');
                        }
                      }
                    }),
                widget.isDrag
                    ? ToolButton(
                        child: controlNotifier.mediaPath.isNotEmpty
                            ? const Icon(
                                Icons.delete,
                                color: Colors.white,
                              )
                            : const ImageIcon(
                                AssetImage('assets/icons/photo_filter.png',
                                    package: 'stories_editor'),
                                color: Colors.white,
                                size: 20,
                              ),
                        backGroundColor: Colors.black12,
                        onTap: () {
                          if (controlNotifier.mediaPath.isEmpty) {
                            scrollNotifier.pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                          } else {
                            editorNotifier.setIsFamilyNotDrag = false;
                            editorNotifier.setIsBackGroundNotDrag = false;
                            editorNotifier.setFontColorNotDrag = false;
                            controlNotifier.mediaPath = '';
                            itemNotifier.draggableWidget.removeAt(0);

                          }
                        })
                    :

                    /// text align
                    ToolButton(
                        onTap: () {
                          editorNotifier.setIsFamilyNotDrag = false;
                          editorNotifier.setIsBackGroundNotDrag = false;
                          editorNotifier.setFontColorNotDrag = false;
                          if (itemNotifier.draggableWidget.isNotEmpty) {
                            editorNotifier.onAlignmentChangeForNotDrag(
                                itemNotifier.draggableWidget.first);
                            _onTap(context, controlNotifier, editorNotifier);
                            setState(() {});
                          }
                        },
                        child: Transform.scale(
                            scale: 0.8,
                            child: itemNotifier.draggableWidget.isEmpty
                                ? const Icon(
                                    Icons.format_align_center,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    itemNotifier.draggableWidget.first
                                                .textAlign ==
                                            TextAlign.center
                                        ? Icons.format_align_center
                                        : itemNotifier.draggableWidget.first
                                                    .textAlign ==
                                                TextAlign.right
                                            ? Icons.format_align_right
                                            : Icons.format_align_left,
                                    color: Colors.white,
                                  )),
                      ),
                widget.isDrag
                    ? ToolButton(
                        child: const ImageIcon(
                          AssetImage('assets/icons/draw.png',
                              package: 'stories_editor'),
                          color: Colors.white,
                          size: 20,
                        ),
                        backGroundColor: Colors.black12,
                        onTap: () {
                          controlNotifier.isPainting = true;
                          //createLinePainting(context: context);
                        })
                    : ToolButton(
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: ImageIcon(
                            AssetImage('assets/icons/font_backGround.png',
                                package: 'stories_editor'),
                            color: Colors.white,
                          ),
                        ),
                        backGroundColor: Colors.black12,
                        onTap: () {
                          editorNotifier.setIsFamilyNotDrag =
                              !editorNotifier.isFontFamilyNotDrag;
                          editorNotifier.setIsBackGroundNotDrag = false;
                          editorNotifier.setFontColorNotDrag = false;
                        },
                      ),

                widget.isDrag
                    ? ToolButton(
                        child: const ImageIcon(
                          AssetImage('assets/icons/text.png',
                              package: 'stories_editor'),
                          color: Colors.white,
                          size: 20,
                        ),
                        backGroundColor: Colors.black12,
                        onTap: () => controlNotifier.isTextEditing =
                            !controlNotifier.isTextEditing,
                      )
                    : ToolButton(
                        child: Transform.scale(
                            scale: !editorNotifier.fontColorNotDrag ? 0.8 : 1.3,
                            child: !editorNotifier.fontColorNotDrag
                                ? const ImageIcon(
                                    AssetImage('assets/icons/text.png',
                                        package: 'stories_editor'),
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : Image.asset(
                                    'assets/icons/circular_gradient.png',
                                    package: 'stories_editor',
                                  )),
                        backGroundColor: Colors.black12,
                        onTap: () {
                          editorNotifier.setIsFamilyNotDrag = false;
                          editorNotifier.setIsBackGroundNotDrag = false;
                          editorNotifier.setFontColorNotDrag =
                              !editorNotifier.fontColorNotDrag;
                        },
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  /// gradient color selector
  Widget _selectColor({onTap, controlProvider}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
      child: AnimatedOnTapButton(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: controlProvider
                      .gradientColors![controlProvider.gradientIndex]),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(context, ControlNotifier controlNotifier,
      TextEditingNotifier editorNotifier) {
    final _editableItemNotifier =
        Provider.of<DraggableWidgetNotifier>(context, listen: false);

    /// create text list
    if (editorNotifier.text.trim().isNotEmpty) {
      splitList = editorNotifier.text.split(' ');
      for (int i = 0; i < splitList.length; i++) {
        if (i == 0) {
          editorNotifier.textList.add(splitList[0]);
          sequenceList = splitList[0];
        } else {
          lastSequenceList = sequenceList;
          editorNotifier.textList.add(sequenceList + ' ' + splitList[i]);
          sequenceList = lastSequenceList + ' ' + splitList[i];
        }
      }

      /// create Text Item
      _editableItemNotifier.draggableWidget.add(EditableItem()
        ..type = ItemType.text
        ..text = editorNotifier.text.trim()
        ..backGroundColor = editorNotifier.backGroundColor
        ..textColor = controlNotifier.colorList![editorNotifier.textColor]
        ..fontFamily = editorNotifier.fontFamilyIndex
        ..fontSize = editorNotifier.textSize
        ..fontAnimationIndex = editorNotifier.fontAnimationIndex
        ..textAlign = editorNotifier.textAlign
        ..textList = editorNotifier.textList
        ..animationType =
            editorNotifier.animationList[editorNotifier.fontAnimationIndex]
        ..position = const Offset(0.0, 0.0));
      editorNotifier.setDefaults();
      //  controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    } else {
      editorNotifier.setDefaults();
      // controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    }
  }

  List<String> splitList = [];
  String sequenceList = '';
  String lastSequenceList = '';
}
