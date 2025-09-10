import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';

class CustomTimerWidget extends StatefulWidget {
  final bool show;
  final Duration duration;
  final VoidCallback onCancelTap;
  final VoidCallback onTimerComplete;

  const CustomTimerWidget({
    required this.show,
    required this.duration,
    required this.onCancelTap,
    required this.onTimerComplete,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomTimerWidget> createState() => _CustomTimerWidgetState();
}

class _CustomTimerWidgetState extends State<CustomTimerWidget> {
  late Timer _timer;
  int secondsLeft = 0;
  bool _blink = true;

  @override
  void initState() {
    super.initState();
    if (widget.show) {
      startTimer();
      blinkLoop();
    }
  }

  @override
  void didUpdateWidget(covariant CustomTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      startTimer();
      blinkLoop();
    }
  }

  void startTimer() {
    secondsLeft = widget.duration.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        cancel(triggerCallback: true);
      }
    });
  }

  void blinkLoop() {
    Timer.periodic(const Duration(milliseconds: 600), (t) {
      if (!widget.show || secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() => _blink = !_blink);
      }
    });
  }

  void cancel({bool triggerCallback = false}) {
    _timer.cancel();
    debugPrint("⏹️ Cancelled");
    if (triggerCallback) {
      widget.onTimerComplete();
    } else {
      widget.onCancelTap();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show || secondsLeft <= 0) return const SizedBox.shrink();

    double percent = secondsLeft / widget.duration.inSeconds;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: percent,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(ColorResource.primaryColor),
                  strokeWidth: 8,
                ),
              ),
              Text(
                '${secondsLeft}s',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            opacity: _blink ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: GestureDetector(
              onTap: () => cancel(triggerCallback: false),
              child: const Text(
                'Cancel Now',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
