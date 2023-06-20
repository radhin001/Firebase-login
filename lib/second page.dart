import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaselogin/logout.dart';
import 'package:flutter/material.dart';
import 'package:time_chart/time_chart.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override

  // ignore: library_private_types_in_public_api
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late StreamController<List<DateTimeRange>> radstreamController;
  late Stream<List<DateTimeRange>> radstream;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference timeCollection =
      FirebaseFirestore.instance.collection('times');

  @override
  void initState() {
    super.initState();
    radstreamController = StreamController<List<DateTimeRange>>();
    radstream = radstreamController.stream;

    startTimer();
  }

  void startTimer() {
    const duration = Duration(seconds: 1);
    int secondsPassed = 0;

    Timer.periodic(duration, (Timer timer) {
      secondsPassed++;
      radstreamController.add(createDateTimeRanges(secondsPassed));
      

      timeCollection.doc('time').set({
        'time': formatTime(secondsPassed),
      });
    });
  }

  List<DateTimeRange> createDateTimeRanges(int seconds) {
    final now = DateTime.now();
    final start = now.subtract(Duration(seconds: seconds));
    final end = now;
    return [DateTimeRange(start: start, end: end)];
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = (hours % 24).toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return "Screen Time: $hoursStr:$minutesStr:$secondsStr";
  }

  @override
  void dispose() {
    radstreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: StreamBuilder<List<DateTimeRange>>(
              stream: radstream,
              builder: (context, snapshot) {
                final data = snapshot.data ?? [];
                return Container(
                  margin: EdgeInsets.only(bottom: 230),
                  height: 500,
                  child: TimeChart(data: data),
                );
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            signOutGoogle(context);
          },
          child: Text('Log out'),
        ),
      ],
    );
  }
}
