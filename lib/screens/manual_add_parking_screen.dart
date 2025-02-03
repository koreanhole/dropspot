import 'package:dropspot/base/data/parking_info.dart';
import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:dropspot/base/string_util.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ManualAddParkingScreen extends StatefulWidget {
  const ManualAddParkingScreen({super.key});

  @override
  State<ManualAddParkingScreen> createState() => _ManualAddParkingScreenState();
}

class _ManualAddParkingScreenState extends State<ManualAddParkingScreen> {
  // 초기 항목 리스트
  List<int> manualParkingItems = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4];
  // 글로벌 삭제 모드 플래그
  bool _globalDeleteMode = false;

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
  // "예"를 선택하면 해당 아이템을 삭제한 후 삭제 모드를 해제합니다.
  Future<void> _showDeleteConfirmationDialog(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("주차 위치를 삭제합니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("아니오"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("예"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        manualParkingItems.removeAt(index);
      });
      _exitDeleteMode();
    }
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
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              if (_globalDeleteMode) {
                _exitDeleteMode();
              } else {
                _enterDeleteMode();
              }
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultManualParkingItemPadding,
        ),
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
            return ParkingItemTile(
              key: ValueKey(item), // 재정렬을 위해 반드시 필요!
              item: item,
              // 부모에서 관리하는 삭제 모드 상태를 전달합니다.
              isDeleteMode: _globalDeleteMode,
              onLongPress: _enterDeleteMode,
              onTap: () {
                // 삭제 모드 상태라면 삭제 모드를 해제합니다.
                if (_globalDeleteMode) {
                  _exitDeleteMode();
                } else {
                  // 일반 탭 시 주차 정보 설정 후 화면 종료
                  context.read<ParkingInfoProvider>().setParkingManualInfo(
                        ParkingInfo(
                          parkedLevel: item,
                          parkedDateTime: DateTime.now(),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
              // 삭제 아이콘 터치 시 확인 팝업을 띄워 삭제 여부 결정
              onDelete: () {
                _showDeleteConfirmationDialog(index);
              },
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final int movedItem = manualParkingItems.removeAt(oldIndex);
              manualParkingItems.insert(newIndex, movedItem);
            });
          },
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
    // 애니메이션 컨트롤러를 200ms 주기로 설정합니다.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // -2도 ~ 2도 (약 -0.035 ~ 0.035 라디안) 범위의 회전 애니메이션을 생성합니다.
    _wiggleAnimation =
        Tween<double>(begin: -0.035, end: 0.035).animate(_controller);
    if (widget.isDeleteMode) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ParkingItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 삭제 모드가 활성화되면 애니메이션 시작, 해제되면 정지 및 리셋
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
            // 전체 타일 영역
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
            // 삭제 모드일 때 좌측 상단에 삭제 아이콘(-) 표시
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
