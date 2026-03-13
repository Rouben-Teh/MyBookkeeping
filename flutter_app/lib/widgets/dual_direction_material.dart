import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:my_bookkeeping/widgets/infinite_rotation.dart';

class DualDirectionMaterialList extends StatefulWidget {
  final Future<void> Function() onRefreshUp;
  final Future<void> Function() onRefreshDown;
  final Widget child;

  const DualDirectionMaterialList({
    super.key,
    required this.onRefreshUp,
    required this.onRefreshDown,
    required this.child,
  });

  @override
  _DualDirectionMaterialListState createState() =>
      _DualDirectionMaterialListState();
}

class _DualDirectionMaterialListState extends State<DualDirectionMaterialList> {
  IndicatorController? _controller;
  bool _keepPadding = false;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      displacement: 20,
      indicatorBuilder: (context, controller) {
        return InfiniteRotation(
          running: controller.state.isLoading,
          child: const Icon(Icons.forward, size: 30),
        );
      },
      onRefresh: () async {
        setState(() {
          _keepPadding = true;
        });

        await Future.delayed(const Duration(milliseconds: 500));

        if (_controller?.side == IndicatorSide.top) {
          await widget.onRefreshUp();
        } else {
          await widget.onRefreshDown();
        }

        // await Future.delayed(const Duration(milliseconds: 500));

        setState(() {
          _keepPadding = false;
        });
      },
      scrollableBuilder: (context, child, controller) {
        final t = controller.value.clamp(0.0, 1.0);

        final shouldLockPadding = _keepPadding || controller.state.isLoading;

        final offset = shouldLockPadding ? 80.0 : t * 80.0;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
            top: controller.side == IndicatorSide.top ? offset : 0,
            bottom: controller.side == IndicatorSide.bottom ? offset : 0,
          ),
          child: child,
        );
      },
      trigger: IndicatorTrigger.bothEdges,
      triggerMode: IndicatorTriggerMode.anywhere,
      leadingScrollIndicatorVisible: false,
      trailingScrollIndicatorVisible: false,
      child: widget.child,
    );
  }
}
