import 'package:flutter/material.dart';

import '../global/cool_toolbar_constants.dart';

class ToolbarItemData {
  final String title;
  final Color color;
  final IconData icon;

  ToolbarItemData({
    required this.title,
    required this.color,
    required this.icon,
  });
}

class ToolbarItem extends StatelessWidget {
  const ToolbarItem(this.data,
      {Key? key,
      required this.height,
      required this.scrollScale,
      this.isLongPassed = false,
      this.gutter = 10.0})
      : super(key: key);
  final ToolbarItemData data;
  final double height;
  final double scrollScale;
  final bool isLongPassed;
  final double gutter;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: height + gutter,
        child: Stack(
          children: [
            AnimatedScale(
              scale: scrollScale,
              duration: CoolToolbarConstants.scrollScaleAnimationDuration,
              curve: CoolToolbarConstants.scrollScaleAnimationCurve,
              child: AnimatedContainer(
                duration: CoolToolbarConstants.longPressAnimationDuration,
                curve: CoolToolbarConstants.longPressAnimationCurve,
                height: height + (isLongPassed ? 10 : 0),
                width: isLongPassed
                    ? CoolToolbarConstants.toolbarWidth * 2
                    : height,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10, color: Colors.black.withOpacity(0.1))
                    ]),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    bottom: gutter,
                    left: isLongPassed ? CoolToolbarConstants.itemsOffset : 0),
              ),
            ),
            Positioned.fill(
              child: AnimatedPadding(
                padding: EdgeInsets.only(
                    bottom: gutter,
                    left: 12 +
                        (isLongPassed ? CoolToolbarConstants.itemsOffset : 0)),
                duration: CoolToolbarConstants.longPressAnimationDuration,
                curve: CoolToolbarConstants.longPressAnimationCurve,
                child: Row(
                  children: [
                    AnimatedScale(
                      duration:
                          CoolToolbarConstants.scrollScaleAnimationDuration,
                      curve: CoolToolbarConstants.longPressAnimationCurve,
                      scale: scrollScale,
                      child: Icon(
                        data.icon,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: AnimatedOpacity(
                      opacity: isLongPassed ? 1 : 0,
                      duration: CoolToolbarConstants.longPressAnimationDuration,
                      curve: CoolToolbarConstants.longPressAnimationCurve,
                      child: Text(
                        data.title,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        maxLines: 1,
                      ),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
