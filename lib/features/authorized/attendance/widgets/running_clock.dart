import 'dart:async';
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
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final formatted = DateFormat("h:mm a").format(now);
    setState(() => _time = formatted);
  }

  @override
  void dispose() {
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
