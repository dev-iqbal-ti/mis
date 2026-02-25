import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RunningClock extends StatefulWidget {
  const RunningClock({super.key});

  @override
  State<RunningClock> createState() => _RunningClockState();
}

class _RunningClockState extends State<RunningClock> {
  late Timer _timer;
  String _time = "";

  @override
  void initState() {
    log("Init Clock Widget");
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final formatted = DateFormat("hh:mm:ss a").format(now);
    setState(() => _time = formatted);
  }

  @override
  void dispose() {
    log("disposed Clock Widget");
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _time,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}
