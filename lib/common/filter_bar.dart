import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class FilterBar extends StatefulWidget implements PreferredSizeWidget {
  FilterBar({Key? key, required this.items, required this.controller, this.onTap, this.padding = const EdgeInsets.symmetric(horizontal: 24.0)})
      : assert(items.length == controller.length),
        super(key: key);

  final List<Widget> items;
  final TabController controller;
  final EdgeInsetsGeometry padding;
  final Function(int)? onTap;
  final Size preferredSize = Size.fromHeight(42.0);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 48.0,
        padding: widget.padding,
        child: AnimatedBuilder(
            animation: widget.controller.animation!,
            builder: (ctx, child) {
              // avoid fading over selected tab
              return ShaderMask(
                  shaderCallback: (Rect bounds) {
                    final Color bg = AppColors.of(context).background;
                    final double index = widget.controller.animation!.value;
                    return LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                      index < 0.2 ? Colors.transparent : bg,
                      Colors.transparent,
                      Colors.transparent,
                      index > widget.controller.length - 1.2 ? Colors.transparent : bg
                    ], stops: const [
                      0,
                      0.1,
                      0.9,
                      1
                    ]).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: child);
            },
            child: Theme(
              // Disable InkResponse, because it's shape doesn't fit
              // a selected tabs shape & it just looks bad
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: TabBar(
                controller: widget.controller,
                isScrollable: true,
                physics: const BouncingScrollPhysics(),
                // Label
                labelStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: AppColors.of(context).text.withOpacity(0.65),
                // Indicator
                indicatorPadding: const EdgeInsets.symmetric(vertical: 8),
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                overlayColor: MaterialStateProperty.all(Color(0)),
                // Tabs
                padding: EdgeInsets.zero,
                tabs: widget.items,
                onTap: widget.onTap,
              ),
            )));
  }
}
