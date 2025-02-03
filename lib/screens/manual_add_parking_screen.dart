import 'package:dropspot/base/data/parking_info.dart';
import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:dropspot/base/string_util.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ManualAddParkingScreen extends StatefulWidget {
  const ManualAddParkingScreen({super.key});

  @override
  State<ManualAddParkingScreen> createState() => _ManualAddParkingScreenState();
}

class _ManualAddParkingScreenState extends State<ManualAddParkingScreen> {
  // 초기 항목 리스트 (Shared Preferences에 저장된 값이 없으면 이 값을 사용)
  List<int> manualParkingItems = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4];
  // 글로벌 삭제 모드 플래그
  bool _globalDeleteMode = false;
  final String _prefsKey = 'manualParkingItems';

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  // SharedPreferences에서 저장된 리스트를 불러옵니다.
  Future<void> _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString(_prefsKey);
    if (itemsJson != null) {
      List<dynamic> jsonList = json.decode(itemsJson);
      List<int> loadedList = jsonList.map((e) => e as int).toList();
      // 불러온 리스트를 오름차순 정렬 및 중복 제거 후 상태 업데이트
      setState(() {
        manualParkingItems = loadedList.toSet().toList()..sort();
      });
    }
  }

  // manualParkingItems 리스트를 오름차순 정렬하고 중복을 제거한 후 SharedPreferences에 저장합니다.
  Future<void> _saveState() async {
    setState(() {
      manualParkingItems = manualParkingItems.toSet().toList()..sort();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonList = json.encode(manualParkingItems);
    await prefs.setString(_prefsKey, jsonList);
  }

  // 한 항목에서 길게 누르면 모든 항목이 삭제 모드로 전환됩니다.
  void _enterDeleteMode() {
    if (!_globalDeleteMode) {
      setState(() {
        _globalDeleteMode = true;
      });
    }
  }

  // 삭제 모드 해제: 일반 탭 시 혹은 삭제 후 해제할 수 있도록 합니다.
  void _exitDeleteMode() {
    if (_globalDeleteMode) {
      setState(() {
        _globalDeleteMode = false;
      });
    }
  }

  // 삭제 확인 팝업을 띄워 실제로 삭제할지 결정하고,
  // "예"를 선택하면 해당 아이템을 삭제한 후 삭제 모드를 해제하고 상태를 저장합니다.
  Future<void> _showDeleteConfirmationDialog(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("삭제할까요?"),
        content: Text(manualParkingItems[index].convertToReadableText()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("아니오"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "삭제",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        manualParkingItems.removeAt(index);
      });
      _saveState();
    }
  }

  // 추가 버튼을 눌렀을 때 AlertDialog를 띄워 피커 휠로 항목을 추가하도록 합니다.
  void _onAddButtonPressed() {
    // 피커에 표시할 옵션들
    final List<String> levelOptions = ["지상", "지하"];
    // 두번째 피커: 1부터 10까지의 정수 옵션
    final List<int> numberOptions = List.generate(10, (index) => index + 1);
    // 기본 선택값
    int selectedNumber = numberOptions.first;
    int selectedLevelIndex = 0; // 0: 지상, 1: 지하

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("주차 층 추가"),
              content: SizedBox(
                height: 200,
                child: Row(
                  children: [
                    // 첫 번째 피커: 지상, 지하 선택
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedLevelIndex),
                        itemExtent: 32,
                        onSelectedItemChanged: (int index) {
                          setStateDialog(() {
                            selectedLevelIndex = index;
                          });
                        },
                        children: levelOptions
                            .map((option) => Center(child: Text(option)))
                            .toList(),
                      ),
                    ),
                    // 두 번째 피커: 1 ~ 10 정수 선택 (숫자 뒤에 '층' 추가)
                    Expanded(
                      child: CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: 0),
                        itemExtent: 32,
                        onSelectedItemChanged: (int index) {
                          setStateDialog(() {
                            selectedNumber = numberOptions[index];
                          });
                        },
                        children: numberOptions
                            .map((number) => Center(child: Text('$number층')))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 취소
                  },
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    // 첫번째 피커에 따른 최종 값 계산:
                    // 지상인 경우 selectedNumber를, 지하인 경우 -selectedNumber를 저장합니다.
                    int finalValue = (selectedLevelIndex == 0)
                        ? selectedNumber
                        : -selectedNumber;
                    setState(() {
                      manualParkingItems.add(finalValue);
                    });
                    _saveState();
                    _exitDeleteMode();
                    Navigator.pop(context);
                  },
                  child: const Text("추가"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double defaultManualParkingItemPadding = 16;

    return Scaffold(
      appBar: DropSpotAppBar(
        title: "주차 위치 추가",
        actions: [
          // _globalDeleteMode가 활성화되었을 때만 추가 버튼을 표시합니다.
          if (_globalDeleteMode)
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: _onAddButtonPressed,
              icon: const Icon(Icons.add),
            ),
          if (_globalDeleteMode)
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () => _exitDeleteMode(),
              icon: const Icon(Icons.close),
            ),
          if (!_globalDeleteMode)
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () => _enterDeleteMode(),
              icon: const Icon(Icons.tune),
            ),
        ],
      ),
      // GridView를 감싸서 빈 곳을 탭하면 삭제 모드 종료 처리
      body: GestureDetector(
        onTap: _exitDeleteMode,
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultManualParkingItemPadding),
          child: ReorderableGridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: defaultManualParkingItemPadding,
              mainAxisSpacing: defaultManualParkingItemPadding,
            ),
            itemCount: manualParkingItems.length,
            itemBuilder: (context, index) {
              final item = manualParkingItems[index];
              // ReorderableDragStartListener로 감싸서 드래그를 시작할 수 있도록 합니다.
              return ReorderableDragStartListener(
                key: ValueKey(item), // 각 항목에 고유한 key
                index: index,
                child: ParkingItemTile(
                  item: item,
                  isDeleteMode: _globalDeleteMode,
                  onLongPress: _enterDeleteMode,
                  onTap: () {
                    if (_globalDeleteMode) {
                      _exitDeleteMode();
                    } else {
                      context.read<ParkingInfoProvider>().setParkingManualInfo(
                            ParkingInfo(
                              parkedLevel: item,
                              parkedDateTime: DateTime.now(),
                            ),
                          );
                      Navigator.of(context).pop();
                    }
                  },
                  onDelete: () {
                    _showDeleteConfirmationDialog(index);
                  },
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final int movedItem = manualParkingItems.removeAt(oldIndex);
                manualParkingItems.insert(newIndex, movedItem);
              });
              _saveState();
            },
          ),
        ),
      ),
    );
  }
}

/// 각 항목을 나타내는 타일 위젯
class ParkingItemTile extends StatefulWidget {
  final int item;
  final bool isDeleteMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;

  const ParkingItemTile({
    super.key,
    required this.item,
    required this.isDeleteMode,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
  });

  @override
  State<ParkingItemTile> createState() => _ParkingItemTileState();
}

class _ParkingItemTileState extends State<ParkingItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _wiggleAnimation =
        Tween<double>(begin: -0.035, end: 0.035).animate(_controller);
    if (widget.isDeleteMode) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ParkingItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDeleteMode && !oldWidget.isDeleteMode) {
      _controller.repeat(reverse: true);
    } else if (!widget.isDeleteMode && oldWidget.isDeleteMode) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.isDeleteMode ? _wiggleAnimation.value : 0,
          child: child,
        );
      },
      child: Material(
        color: secondaryColor,
        borderRadius: defaultBoxBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            InkWell(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              child: Center(
                child: Text(
                  widget.item.convertToReadableText(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            if (widget.isDeleteMode)
              Positioned(
                top: 4,
                left: 4,
                child: GestureDetector(
                  onTap: widget.onDelete,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.remove,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
