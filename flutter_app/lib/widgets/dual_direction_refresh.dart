import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class DualDirectionRefreshList extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefreshUp;
  final Future<void> Function() onRefreshDown;

  const DualDirectionRefreshList({
    super.key,
    required this.child,
    required this.onRefreshUp,
    required this.onRefreshDown,
  });

  @override
  _DualDirectionRefreshListState createState() =>
      _DualDirectionRefreshListState();
}

class _DualDirectionRefreshListState extends State<DualDirectionRefreshList> {
  IndicatorController? _controller;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
        builder: (context, child, controller) {
          _controller = controller;

          // t 是 progress 值 0 → 1
          final t = controller.value.clamp(0.0, 1.0);

          double offset = 0;
          if (controller.isLoading) {
            // 刷新状态固定位置
            offset = 80;
          } else {
            offset = t * 80;
          }

          return Stack(
            children: [
              // List 主体
              Padding(
                padding: EdgeInsets.only(
                  top: controller.side == IndicatorSide.top ? offset : 0,
                  bottom: controller.side == IndicatorSide.bottom ? offset : 0,
                ),
                child: child,
              ),

              // 动画
              if (controller.value > 0 || controller.isLoading)
                Positioned(
                  top: controller.side == IndicatorSide.top ? 20 : null,
                  bottom: controller.side == IndicatorSide.bottom ? 20 : null,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        final positionOffset = controller.isLoading
                            ? 0.0
                            : (controller.side == IndicatorSide.top
                                ? offset - 30
                                : 30 - offset);
                        return Transform.translate(
                          offset: Offset(
                            0,
                            positionOffset,
                          ),
                          child: child,
                        );
                      },
                      child: controller.isLoading
                          ? const CircularProgressIndicator()
                          : controller.isDragging || controller.isArmed
                              ? Icon(
                                  controller.side == IndicatorSide.bottom
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  size: 28,
                                )
                              : null,
                    ),
                  ),
                ),
            ],
          );
        },
        onRefresh: () async {
          // 强制最少保留 0.5s
          await Future.delayed(const Duration(milliseconds: 500));

          if (_controller?.side == IndicatorSide.top) {
            await widget.onRefreshUp();
          } else {
            await widget.onRefreshDown();
          }
        },
        trigger: IndicatorTrigger.bothEdges,
        triggerMode: IndicatorTriggerMode.anywhere,
        child: this.widget.child);
  }
}
