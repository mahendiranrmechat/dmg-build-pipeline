import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psglotto/view/utils/constants.dart';
import 'package:psglotto/view/utils/helper.dart';
import 'package:psglotto/view/widgets/custom_tabbar.dart';
import 'package:psglotto/view/widgets/home/my_lotteries_2d/result_type_tab_view_2d.dart';
import 'package:psglotto/view/widgets/home/my_lotteries_3d/result_type_tab_view_3d.dart';
import 'package:psglotto/view/widgets/my_lotteries/result_type_tab_view.dart';
import 'package:psglotto/view/widgets/snackbar.dart';

import '../model/category.dart';
import '../provider/providers.dart';
import '../utils/exception_handler.dart';

class MyLotteriesView extends ConsumerStatefulWidget {
  const MyLotteriesView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyLotteriesViewState createState() => _MyLotteriesViewState();
}

class _MyLotteriesViewState extends ConsumerState<MyLotteriesView>
    with TickerProviderStateMixin {
  late TabController controller;
  int tabCount = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 0); // Initialize with 0 length
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<CategoryList>> categoryAsyncData =
        ref.watch(categoryProvider);

    return categoryAsyncData.when(
      data: (data) {
        // Update tab count and initialize TabController only when data is available
        tabCount = data.length;
        
        // Initialize TabController if not already initialized
        if (controller.length != tabCount) {
          controller = TabController(vsync: this, length: tabCount);
        }

        return Scaffold(
          appBar: CustomTab(
            tabs: getCategory(data),
            onDone: (index) {
              controller.animateTo(index);
            },
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: getCategoryTab(data),
          ),
        );
      },
      error: (error, s) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ExceptionHandler.showSnack(
              errorCode: error.toString(), context: context);
        });
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No Internet connection"),
              const SizedBox(height: kDefaultPadding),
              ElevatedButton(
                onPressed: () async {
                  bool networkStatus = await Helper.checkNetworkConnection();
                  if (networkStatus) {
                    // ignore: unused_result
                    ref.refresh(categoryProvider);
                  } else {
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    showSnackBar(context, "Check your internet connection");
                  }
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

List<Widget> getCategoryTab(List<CategoryList> categories) {
  List<Widget> categoryWidget = <Widget>[];
  for (CategoryList category in categories) {
    if (category.categoryId == 1) {
      categoryWidget.add(const ResultTypeTabView(categoryId: 1));
    } else if (category.categoryId == 2) {
      categoryWidget.add(const ResultTypeTabView2D(categoryId: 2));
    } else if (category.categoryId == 3) {
      categoryWidget.add(const ResultTypeTabView3D(categoryId: 3));
    }
  }
  return categoryWidget;
}

List<Widget> getCategory(List<CategoryList> categories) {
  List<Widget> categoryWidget = <Widget>[];
  for (CategoryList category in categories) {
    if (category.categoryId == 1) {
      categoryWidget.add(const Tab(text: 'Lotto'));
    } else if (category.categoryId == 2) {
      categoryWidget.add(const Tab(text: '2D'));
    } else if (category.categoryId == 3) {
      categoryWidget.add(const Tab(text: '3D'));
    }
  }
  return categoryWidget;
}
