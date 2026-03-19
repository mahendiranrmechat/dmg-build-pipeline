import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psglotto/provider/lotto_clock_provider.dart';
import 'package:psglotto/provider/providers.dart';
import '../../utils/helper.dart';

enum CountDownTimerFormat {
  daysHoursMinutesSeconds,
  daysHoursMinutes,
  daysHours,
  daysOnly,
  hoursMinutesSeconds,
  hoursMinutes,
  hoursOnly,
  minutesSeconds,
  minutesOnly,
  secondsOnly,
}

class LottoCard extends ConsumerStatefulWidget {
  final Duration timeDiff;
  final String type;
  final String drawId;
  final String drawPlayGroupId;
  final double winPrice;
  final int time;
  const LottoCard({
    Key? key,
    required this.type,
    required this.drawId,
    required this.drawPlayGroupId,
    required this.winPrice,
    required this.time,
    required this.timeDiff,
  }) : super(key: key);

  @override
  ConsumerState<LottoCard> createState() => _LottoCardState();
}

class _LottoCardState extends ConsumerState<LottoCard> {
  Timer? timer;
  late String countdownDays;
  late String countdownHours;
  late String countdownMinutes;
  late String countdownSeconds;
  late Duration difference;

  CountDownTimerFormat format = CountDownTimerFormat.daysHoursMinutesSeconds;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  Future<void> onRefresh() async {
    // ref.refresh(lobbyProvider);
    // ignore: unused_result
    ref.refresh(lobbyProvider);
  }

  // void _startTimer() {
  //   final serverTime =
  //       ref.read(lottoClockProvider); // Get the initial time from the provider
  //   debugPrint("server time: $serverTime      now : ${DateTime.now()}");
  //   if (DateTime.fromMillisecondsSinceEpoch(widget.time)
  //       .isBefore(serverTime.add(widget.timeDiff))) {
  //     difference = Duration.zero;
  //   } else {
  //     difference = DateTime.fromMillisecondsSinceEpoch(widget.time)
  //         .difference(serverTime.add(widget.timeDiff));
  //   }
  //   debugPrint("difference : $difference");

  //   countdownDays = _durationToStringDays(difference);
  //   countdownHours = _durationToStringHours(difference);
  //   countdownMinutes = _durationToStringMinutes(difference);
  //   countdownSeconds = _durationToStringSeconds(difference);

  //   if (difference == Duration.zero) {
  //     debugPrint("Lobby refresh called in lotto card ");
  //     onRefresh();
  //     // if (widget.onEnd != null) {
  //     //   widget.onEnd!();
  //     // }
  //   } else {
  //     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //       final updatedServerTime = ref.read(lottoClockProvider);
  //       difference = DateTime.fromMillisecondsSinceEpoch(widget.time)
  //           .difference(updatedServerTime.add(widget.timeDiff));
  //       setState(() {
  //         countdownDays = _durationToStringDays(difference);
  //         countdownHours = _durationToStringHours(difference);
  //         countdownMinutes = _durationToStringMinutes(difference);
  //         countdownSeconds = _durationToStringSeconds(difference);
  //       });
  //       if (difference <= Duration.zero) {
  //         timer.cancel();
  //         //   if (widget.onEnd != null) {
  //         //     widget.onEnd!();
  //         //   }
  //       }
  //     });
  //   }
  // }

  void _startTimer() {
    final serverTime =
        ref.read(lottoClockProvider); // Get the initial time from the provider
    debugPrint("server time: $serverTime      now : ${DateTime.now()}");

    if (DateTime.fromMillisecondsSinceEpoch(widget.time)
        .isBefore(serverTime.add(widget.timeDiff))) {
      difference = Duration.zero;
    } else {
      difference = DateTime.fromMillisecondsSinceEpoch(widget.time)
          .difference(serverTime.add(widget.timeDiff));
    }
    debugPrint("difference : $difference");

    countdownDays = _durationToStringDays(difference);
    countdownHours = _durationToStringHours(difference);
    countdownMinutes = _durationToStringMinutes(difference);
    countdownSeconds = _durationToStringSeconds(difference);

    if (difference == Duration.zero) {
      debugPrint("Lobby refresh called in lotto card ");
      onRefresh();
      // if (widget.onEnd != null) {
      //   widget.onEnd!();
      // }
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final updatedServerTime = ref.read(lottoClockProvider);
        difference = DateTime.fromMillisecondsSinceEpoch(widget.time)
            .difference(updatedServerTime.add(widget.timeDiff));

        if (mounted) {
          setState(() {
            countdownDays = _durationToStringDays(difference);
            countdownHours = _durationToStringHours(difference);
            countdownMinutes = _durationToStringMinutes(difference);
            countdownSeconds = _durationToStringSeconds(difference);
          });
        }

        if (difference <= Duration.zero) {
          timer.cancel();
        }
      });

      // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //   final updatedServerTime = ref.read(lottoClockProvider);
      //   difference = DateTime.fromMillisecondsSinceEpoch(widget.time)
      //       .difference(updatedServerTime.add(widget.timeDiff));

      //   // Delay setState call after the current build phase is complete
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     setState(() {
      //       countdownDays = _durationToStringDays(difference);
      //       countdownHours = _durationToStringHours(difference);
      //       countdownMinutes = _durationToStringMinutes(difference);
      //       countdownSeconds = _durationToStringSeconds(difference);
      //     });
      //   });

      //   if (difference <= Duration.zero) {
      //     timer.cancel();
      //     //   if (widget.onEnd != null) {
      //     //     widget.onEnd!();
      //     //   }
      //   }
      // });
    }
  }

  /// Convert [Duration] in days to String for UI.
  String _durationToStringDays(Duration duration) {
    return _twoDigits(duration.inDays, "days").toString();
  }

  /// Convert [Duration] in hours to String for UI.
  String _durationToStringHours(Duration duration) {
    if (format == CountDownTimerFormat.hoursMinutesSeconds ||
        format == CountDownTimerFormat.hoursMinutes ||
        format == CountDownTimerFormat.hoursOnly) {
      return _twoDigits(duration.inHours, "hours");
    } else {
      return _twoDigits(duration.inHours.remainder(24), "hours").toString();
    }
  }

  /// Convert [Duration] in minutes to String for UI.
  String _durationToStringMinutes(Duration duration) {
    if (format == CountDownTimerFormat.minutesSeconds ||
        format == CountDownTimerFormat.minutesOnly) {
      return _twoDigits(duration.inMinutes, "minutes");
    } else {
      return _twoDigits(duration.inMinutes.remainder(60), "minutes");
    }
  }

  /// Convert [Duration] in seconds to String for UI.
  String _durationToStringSeconds(Duration duration) {
    if (format == CountDownTimerFormat.secondsOnly) {
      return _twoDigits(duration.inSeconds, "seconds");
    } else {
      return _twoDigits(duration.inSeconds.remainder(60), "seconds");
    }
  }

  /// When the selected [CountDownTimerFormat] is leaving out the last unit, this function puts the UI value of the unit before up by one.
  ///
  /// This is done to show the currently running time unit.
  String _twoDigits(int n, String unitType) {
    switch (unitType) {
      case "minutes":
        if (format == CountDownTimerFormat.daysHoursMinutes ||
            format == CountDownTimerFormat.hoursMinutes ||
            format == CountDownTimerFormat.minutesOnly) {
          if (difference > Duration.zero) {
            n++;
          }
        }
        if (n >= 10) return "$n";
        return "0$n";
      case "hours":
        if (format == CountDownTimerFormat.daysHours ||
            format == CountDownTimerFormat.hoursOnly) {
          if (difference > Duration.zero) {
            n++;
          }
        }
        if (n >= 10) return "$n";
        return "0$n";
      case "days":
        if (format == CountDownTimerFormat.daysOnly) {
          if (difference > Duration.zero) {
            n++;
          }
        }
        if (n >= 10) return "$n";
        return "0$n";
      default:
        if (n >= 10) return "$n";
        return "0$n";
    }
  }

  String checkPlural(String type, String count) {
    int parsedCount = int.tryParse(count) ?? 00;
    String result = "";

    /// find if the value of the parsedCount is greater than 01
    /// if true add s to the end of string

    if (parsedCount > 01) {
      result = "$count ${type}s";
    } else {
      result = "$count $type";
    }
    return result;
  }

  String getCountDown() {
    if (countdownDays != "00") {
      return "${checkPlural("day", countdownDays)} ${checkPlural("hr", countdownHours)}";
    } else if (countdownDays == "00" && countdownHours != "00") {
      return "${checkPlural("hr", countdownHours)} ${checkPlural("min", countdownMinutes)}";
    } else if (countdownMinutes == "00" && countdownSeconds != "00") {
      return checkPlural("sec", countdownSeconds);
    } else if (countdownMinutes != "00") {
      return "${checkPlural("min", countdownMinutes)} ${checkPlural("sec", countdownSeconds)}";
    } else {
      onRefresh();
      return "To be drawn";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/lottocard_bg.png"),
        ),
        // color: kPrimarySeedColor,
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.type.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          Row(
            children: [
              Text(
                widget.drawPlayGroupId,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                Helper.getIndianCurrencyInShorthand(amount: widget.winPrice),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                5,
              ),
            ),
            child: Text(
              getCountDown(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
