import 'package:flutter/material.dart';
import 'package:psglotto/view/utils/constants.dart';
import 'package:series_2d/game_init_loader.dart';

import 'm2_indicator.dart';

class CustomTab extends StatefulWidget implements PreferredSizeWidget {
  final void Function(int) onDone;
  final List<Widget> tabs;
  final double? indicatorHeight;
  final Color? indicatorColor;
  final MD2IndicatorSize? indicatorSize;
  final Color? labelColor;
  final FontWeight? labelFontWeight;
  final Color? unselectedLabelColor;
  final bool? isScrollable;
  const CustomTab({
    Key? key,
    required this.tabs,
    required this.onDone,
    this.indicatorHeight = 3,
    this.indicatorColor = const Color(0xff1c7d4a),
    this.indicatorSize = MD2IndicatorSize.full,
    this.labelColor = const Color(0xff1c7d4a),
    this.labelFontWeight = FontWeight.w700,
    this.unselectedLabelColor = Colors.black,
    this.isScrollable = true,
  }) : super(key: key);

  @override
  State<CustomTab> createState() => _CustomTabState();

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _CustomTabState extends State<CustomTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.tabs.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        widget.onDone(tabController.index);
        tabController.animateTo(tabController.index);
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TabBar(
            controller: tabController,
            labelStyle: TextStyle(
              fontWeight: widget.labelFontWeight,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: widget.labelColor,
            unselectedLabelColor: widget.unselectedLabelColor,
            isScrollable: widget.isScrollable!,
            indicator: MD2Indicator(
              indicatorHeight: widget.indicatorHeight!,
              indicatorColor: kPrimarySeedColor!,
              indicatorSize: widget.indicatorSize!,
            ),
            tabs: widget.tabs,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Text(
              SharedPref.instance.getString("username") ?? "-",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
