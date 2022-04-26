import 'package:flutter/material.dart';
import 'package:flutter_example/examples/cool_toolbar/toolbar_item.dart';

import '../global/cool_toolbar_constants.dart';
import 'data/items.dart';

///open source example for github [https://github.com/Roaa94/flutter_cool_toolbar]
class CoolToolbar extends StatefulWidget {
  const CoolToolbar({Key? key}) : super(key: key);

  @override
  State<CoolToolbar> createState() => _CoolToolbarState();
}

class _CoolToolbarState extends State<CoolToolbar> {
  ///hooked with the items list
  late ScrollController _scrollController;

  double get itemHeight =>
      CoolToolbarConstants.toolbarWidth -
      (CoolToolbarConstants.toolbarHorizontalPadding * 2);

  bool isLongDowning = false;

  ///list of item scales
  ///item at index [x] has scale of [itemScrollScaleValues[x]]
  List<double> itemScrollScaleValue = [];

  ///list of item positions

  List<double> itemYPositions = [];

  List<bool> longPressedItemFlags = [];

  void _scrollListener() {
    if (_scrollController.hasClients) {
      _updateItemScrollData(scrollPosition: _scrollController.position.pixels);
    }
  }

  _updateItemScrollData({double scrollPosition = 0}) {
    List<double> _itemScrollScaleValues = [];
    List<double> _itemYPositions = [];
    for (int i = 0; i <= toolbarItems.length - 1; i++) {
      double itemTopPosition =
          i * (itemHeight + CoolToolbarConstants.itemsGutter);
      // Storing y position values of the items with the scrollPosition value subtracted
      // gives the location of the item relative to the toolbar container
      // For example, at first, item 1 is at the top with a position of 0,
      // but when scrolled a distance of 20, item 2's position is now it's previous position
      // (let's say 20) minus the scrolled distance, making it at the correct position when
      // a long press event is received at this location
      _itemYPositions.add(itemTopPosition);

      // Difference between the position of the top edge of the item
      // and the position of the bottom edge of the toolbar container plus scroll position
      // A negative value means that the item is out of view below the toolbar container
      double distanceToMaxScrollExtent =
          CoolToolbarConstants.toolbarHeight + scrollPosition - itemTopPosition;

      // Position of the bottom edge of the item
      double itemBottomPosition =
          (i + 1) * (itemHeight + CoolToolbarConstants.itemsGutter);
      // An item is out of view if it's out of view below the toolbar
      // OR if it's out of view above the toolbar (where the scroll position is further than
      // the position of the bottom edge of the item
      bool itemIsOutOfView =
          distanceToMaxScrollExtent < 0 || scrollPosition > itemBottomPosition;

      // If the item is out of view, scale it down, if it's visible, reset it to default scale
      _itemScrollScaleValues.add(itemIsOutOfView ? 0.4 : 1);
    }

    setState(() {
      itemScrollScaleValue = _itemScrollScaleValues;
      itemYPositions = _itemYPositions;
    });
  }

  void _updateLongPressedItemFlags({double longPressYLocation = 0}) {
    List<bool> _longPressedItemFlags = [];
    for (int i = 0; i <= toolbarItems.length - 1; i++) {
      bool isLongPressed = itemYPositions[i] >= 0 &&
          longPressYLocation > itemYPositions[i] &&
          longPressYLocation <
              (itemYPositions.length > i + 1
                  ? itemYPositions[i + 1]
                  : CoolToolbarConstants.toolbarHeight);
      _longPressedItemFlags.add(isLongPressed);
    }
    setState(() {
      longPressedItemFlags = _longPressedItemFlags;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateItemScrollData();
    _updateLongPressedItemFlags();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const  Text("cool_toolbar"),),
      body: Container(
        width: CoolToolbarConstants.toolbarWidth * (isLongDowning ? 3 : 1),
        height: CoolToolbarConstants.toolbarHeight,
        margin: const EdgeInsets.only(left: 20, top: 90),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: CoolToolbarConstants.toolbarWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onLongPressStart: (LongPressStartDetails details) {
                isLongDowning = true;
                _updateLongPressedItemFlags(
                  longPressYLocation: details.localPosition.dy,
                );
              },
              onLongPressMoveUpdate: (details) {
                _updateLongPressedItemFlags(
                  longPressYLocation: details.localPosition.dy,
                );
              },
              onLongPressEnd: (LongPressEndDetails details) {
                _updateLongPressedItemFlags(longPressYLocation: 0);
                Future.delayed(CoolToolbarConstants.longPressAnimationDuration,(){
                  isLongDowning = false;
                  setState(() {
                    
                  });
                });
              },
              onLongPressCancel: () {
                _updateLongPressedItemFlags(longPressYLocation: 0);
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: toolbarItems.length,
                itemBuilder: (c, i) => ToolbarItem(
                  toolbarItems[i],
                  height: itemHeight,
                  scrollScale: itemScrollScaleValue[i],
                  isLongPassed: longPressedItemFlags[i],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
