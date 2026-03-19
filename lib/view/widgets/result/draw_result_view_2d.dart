import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:psglotto/model/draw_result_2d.dart';
import 'package:psglotto/view/utils/constants.dart';
import 'package:psglotto/view/utils/custom_close_button.dart';
import 'package:psglotto/view/utils/helper.dart';
import 'package:series_2d/presentation/logic_screen/betting_logic.dart';
import 'package:series_2d/utils/custom_clip_design.dart';
import 'package:series_2d/utils/custom_widget.dart';

// ignore: must_be_immutable
class DrawResultView2D extends StatefulWidget {
  List<Result> drawResult = [];
  String drawId;
  final String drawTime;
  final String gameId;
  final String gameName;
  DrawResultView2D({
    required this.gameId,
    required this.gameName,
    required this.drawResult,
    required this.drawId,
    required this.drawTime,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DrawResultView2DState createState() => _DrawResultView2DState();
}

class _DrawResultView2DState extends State<DrawResultView2D> {
  ScrollController controller = ScrollController();
  ScrollController controllerNew = ScrollController();

  TextEditingController searchKey = TextEditingController();
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  double average = 0.0;
  final itemkey = GlobalKey();

  Future scrollItem() async {
    final context = itemkey.currentContext!;
    await Scrollable.ensureVisible(context);
  }

  @override
  void initState() {
    // for (var result in widget.drawResult) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    average = screenWidth + screenHeight;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Results"),
          centerTitle: true,
          actions: [CustomCloseButton()],
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.10,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        "Draw ID : ${widget.drawId.toString()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxFontSize: 16,
                        minFontSize: 10,
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        "Draw Time : ${widget.drawTime.contains("M") ? widget.drawTime : Helper.epocToMMddYYYYhhMMaa(int.parse(widget.drawTime))}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxFontSize: 16,
                        minFontSize: 10,
                        maxLines: 1,
                      ),
                    ]),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.80,
                color: Colors.transparent,
                child: widget.gameId == "2d-jackpot"
                    ? Container(
                        color: Colors.transparent,
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // Adjust width as needed
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable scrolling
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10, // Number of items per row
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                childAspectRatio: 2.0, // Adjust as needed
                              ),
                              itemCount: widget.drawResult[0].ticketNos.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: customText(
                                            value: widget.drawResult[0]
                                                .ticketNos[index].winNo,
                                            average: average,
                                            fontColor: Colors.black,
                                            fontSize: 100,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      widget.drawResult[0].ticketNos[index]
                                                  .jackpotType !=
                                              "N"
                                          ? Align(
                                              alignment: Alignment.topRight,
                                              child: CustomCircleContainer(
                                                widthRatio: 0.025,
                                                heightRatio: 0.025,
                                                backgroundColor: Colors.black,
                                                borderRadius: 60.0,
                                                imagePath: BettingLogic()
                                                    .getImagePath(widget
                                                        .drawResult[0]
                                                        .ticketNos[index]
                                                        .jackpotType),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              titileContainer(context, "Ticket", Colors.black),
                              titileContainer(
                                  context, "Win No (Double)", Colors.black),
                              if (widget.gameId == "2d")
                                titileContainer(context, "Single - Bahar",
                                    kPrimarySeedColor!),
                              if (widget.gameId == "2d")
                                titileContainer(
                                    context, "Single - Andar", Colors.red),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.70,
                            color: Colors.white,
                            child: Row(
                              children: [
                                Container(
                                  width: widget.gameId == "2d-series"
                                      ? MediaQuery.of(context).size.width * 0.50
                                      : MediaQuery.of(context).size.width *
                                          0.25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.70,
                                  color: Colors.transparent,
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          10, //widget.drawResult[position]['ticketNos'].length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            color: Colors.grey.withOpacity(0.1),
                                            child: Center(
                                                child: Text(widget.drawResult[0]
                                                    .ticketNos[index].typeName)
                                                //widget.drawResult[position]['ticketNos'][index][value]),
                                                ),
                                          ),
                                        );
                                      }),
                                ),
                                Container(
                                  width: widget.gameId == "2d-series"
                                      ? MediaQuery.of(context).size.width * 0.50
                                      : MediaQuery.of(context).size.width *
                                          0.25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.70,
                                  color: Colors.transparent,
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          10, //widget.drawResult[position]['ticketNos'].length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            color: Colors.grey.withOpacity(0.1),
                                            child: Center(
                                                child: Text(widget.drawResult[0]
                                                    .ticketNos[index].winNo)
                                                //widget.drawResult[position]['ticketNos'][index][value]),
                                                ),
                                          ),
                                        );
                                      }),
                                ),
                                widget.gameId == "2d"
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.70,
                                        color: Colors.transparent,
                                        child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                10, //widget.drawResult[position]['ticketNos'].length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.065,
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  child: Center(
                                                      child: Text(widget
                                                          .drawResult[2]
                                                          .ticketNos[index]
                                                          .winNo)
                                                      //widget.drawResult[position]['ticketNos'][index][value]),
                                                      ),
                                                ),
                                              );
                                            }),
                                      )
                                    : const SizedBox.shrink(),
                                widget.gameId == "2d"
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.70,
                                        color: Colors.transparent,
                                        child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                10, //widget.drawResult[position]['ticketNos'].length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.065,
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  child: Center(
                                                      child: Text(widget
                                                          .drawResult[1]
                                                          .ticketNos[index]
                                                          .winNo)
                                                      //widget.drawResult[position]['ticketNos'][index][value]),
                                                      ),
                                                ),
                                              );
                                            }),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            )
          ],
        ));
  }

  // Container bodyContainer(BuildContext context, int position, String value) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.25,
  //     height: MediaQuery.of(context).size.height * 0.70,
  //     color: Colors.transparent,
  //     child: ListView.builder(
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: 10, //widget.drawResult[position]['ticketNos'].length,
  //         itemBuilder: (context, index) {
  //           return Padding(
  //             padding: const EdgeInsets.all(2.0),
  //             child: Container(
  //               width: MediaQuery.of(context).size.width,
  //               height: MediaQuery.of(context).size.height * 0.065,
  //               color: Colors.grey.withOpacity(0.1),
  //               child: Center(
  //                   child: Text(
  //                       widget.drawResult[position].ticketNos[index].typeName)
  //                   //widget.drawResult[position]['ticketNos'][index][value]),
  //                   ),
  //             ),
  //           );
  //         }),
  //   );
  // }

  Container titileContainer(BuildContext context, String titile, Color color) {
    return Container(
      width: widget.gameId == "2d-series"
          ? MediaQuery.of(context).size.width * 0.50
          : MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.05,
      color: Colors.transparent,
      child: Center(
          child: Text(
        titile,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      )),
    );
  }
}
