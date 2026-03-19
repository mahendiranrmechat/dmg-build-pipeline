import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psglotto/view/utils/constants.dart';
import 'package:psglotto/view/widgets/home/my_lotteries_3d/drawn_view_3d.dart';
import 'package:psglotto/view/widgets/home/my_lotteries_3d/to_be_drawn_view_3d.dart';
import 'package:psglotto/view/widgets/home/my_lotteries_3d/won_view_3d.dart';


class ResultTypeTabView3D extends ConsumerStatefulWidget {
  final int categoryId;
  const ResultTypeTabView3D({Key? key, required this.categoryId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ResultTypeTabView3DState createState() => _ResultTypeTabView3DState();
}

class _ResultTypeTabView3DState extends ConsumerState<ResultTypeTabView3D>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.black87,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                indicatorHeight: 35.0,
                indicatorColor: kPrimarySeedColor!,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,

                // Other flags
                indicatorRadius: 1,
                // insets: EdgeInsets.all(1),
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              ),
              controller: _controller,
              tabs: const [
                Tab(
                  text: 'To be drawn',
                ),
                Tab(
                  text: 'Drawn',
                ),
                Tab(
                  text: 'Won',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                children: <Widget>[
                  ToBeDrawnView3D(
                    categoryId: widget.categoryId,
                  ),
                  DrawnView3D(
                    categoryId: widget.categoryId,
                  ),
                  WonView3D(
                    categoryId: widget.categoryId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
