import 'dart:math' as math;
import 'package:dronees/features/authorized/attendance/screens/attendance_screen.dart';
import 'package:dronees/features/authorized/home/controllers/home_controller.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────
//  Shimmer painter for the animated shine effect
// ─────────────────────────────────────────────
class _ShimmerPainter extends CustomPainter {
  final double progress;
  _ShimmerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final x = -size.width + (size.width * 2.5 * progress);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(rect);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withOpacity(0),
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0),
        ],
        stops: const [0.3, 0.5, 0.7],
      ).createShader(Rect.fromLTWH(x, 0, size.width, size.height));
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────
//  Particle dot painter (floating dots background)
// ─────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double t;
  final bool isCheckedIn;
  _ParticlePainter(this.t, this.isCheckedIn);

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 14; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final phase = rng.nextDouble() * math.pi * 2;
      final radius = 2.0 + rng.nextDouble() * 3;
      final dx = math.sin(t * 1.2 + phase) * 6;
      final dy = math.cos(t * 0.9 + phase) * 6;
      paint.color = Colors.white.withOpacity(0.12 + rng.nextDouble() * 0.12);
      canvas.drawCircle(Offset(baseX + dx, baseY + dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != old.t;
}

// ─────────────────────────────────────────────
//  Main Enhanced Attendance Card
// ─────────────────────────────────────────────
class EnhancedAttendanceCard extends StatefulWidget {
  final HomeController controller;
  const EnhancedAttendanceCard({super.key, required this.controller});

  @override
  State<EnhancedAttendanceCard> createState() => _EnhancedAttendanceCardState();
}

class _EnhancedAttendanceCardState extends State<EnhancedAttendanceCard>
    with TickerProviderStateMixin {
  // Entrance animation
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  // Continuous shimmer sweep
  late final AnimationController _shimmerCtrl;

  // Continuous particle float
  late final AnimationController _particleCtrl;

  // Pulse ring on the leading icon
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  // Tap press scale
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutQuart),
        );

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(min: 0, max: 1);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: false);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut);

    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _shimmerCtrl.dispose();
    _particleCtrl.dispose();
    _pulseCtrl.dispose();
    _pressCtrl.dispose();
    super.dispose();
  }

  // Gradient colors per state
  // List<Color> get _gradientColors => widget.controller.isCheckedIn.value
  //     ? const [Color(0xFF0BA360), Color(0xFF3CBA92), Color(0xFF00D2FF)]
  //     : const [Color(0xFF4F00BC), Color(0xFF29ABE2), Color(0xFF6A11CB)];

  // Color get _glowColor => widget.controller.isCheckedIn.value
  //     ? const Color(0xFF0BA360)
  //     : const Color(0xFF4F00BC);

  List<Color> get _gradientColors => widget.controller.isCheckedIn.value
      ? const [
          Color(0xFF059669),
          Color(0xFF10B981),
          Color(0xFF34D399),
        ] // Emerald Green
      : const [
          Color(0xFF1E1B4B), // Deepest Navy
          Color(0xFF3730A3), // Rich Indigo
          Color(0xFF4338CA), // Vibrant Indigo
        ];

  Color get _glowColor => widget.controller.isCheckedIn.value
      ? const Color(0xFF10B981)
      : const Color(0xFF334155);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isCheckedIn = widget.controller.isCheckedIn.value;

      return FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: GestureDetector(
              onTapDown: (_) => _pressCtrl.forward(),
              onTapUp: (_) {
                _pressCtrl.reverse();
                Get.to(() => const AttendanceScreen());
              },
              onTapCancel: () => _pressCtrl.reverse(),
              child: ScaleTransition(
                scale: _scaleAnim,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOutCubic,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _gradientColors,
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Stack(
                        children: [
                          // ── Floating particles
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _particleCtrl,
                              builder: (_, __) => CustomPaint(
                                painter: _ParticlePainter(
                                  _particleCtrl.value * math.pi * 2,
                                  isCheckedIn,
                                ),
                              ),
                            ),
                          ),

                          // ── Decorative arc top-right
                          Positioned(
                            top: -40,
                            right: -40,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 700),
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.07),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                          ),

                          // ── Shimmer sweep
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _shimmerCtrl,
                              builder: (_, __) => CustomPaint(
                                painter: _ShimmerPainter(_shimmerCtrl.value),
                              ),
                            ),
                          ),

                          // ── Content
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultPadding,
                              vertical: TSizes.defaultPadding,
                            ),
                            child: Row(
                              children: [
                                // Leading icon + pulse ring
                                _buildPulsingIcon(isCheckedIn),
                                const SizedBox(width: 18),

                                // Text block
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Status badge
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        child: Container(
                                          key: ValueKey(isCheckedIn),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.18,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            isCheckedIn
                                                ? '● ACTIVE SESSION'
                                                : '○ NOT CHECKED IN',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Title
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        transitionBuilder: (child, anim) =>
                                            FadeTransition(
                                              opacity: anim,
                                              child: SlideTransition(
                                                position:
                                                    Tween<Offset>(
                                                      begin: const Offset(
                                                        0,
                                                        0.25,
                                                      ),
                                                      end: Offset.zero,
                                                    ).animate(
                                                      CurvedAnimation(
                                                        parent: anim,
                                                        curve: Curves.easeOut,
                                                      ),
                                                    ),
                                                child: child,
                                              ),
                                            ),
                                        child: Text(
                                          isCheckedIn
                                              ? 'Check Out'
                                              : 'Mark Attendance',
                                          key: ValueKey(isCheckedIn),
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Subtitle
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 350,
                                        ),
                                        child: Text(
                                          isCheckedIn
                                              ? '🕘 Logged in at 09:30 AM'
                                              : 'Tap to punch in for the day',
                                          key: ValueKey('sub_$isCheckedIn'),
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.78,
                                            ),
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Trailing arrow / check
                                _buildTrailingIcon(isCheckedIn),
                              ],
                            ),
                          ),

                          // ── Frosted glass bottom strip
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.0),
                                    Colors.white.withOpacity(0.35),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPulsingIcon(bool isCheckedIn) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse ring 1
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Transform.scale(
              scale: 1.0 + _pulseAnim.value * 0.55,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(
                    0.18 * (1 - _pulseAnim.value),
                  ),
                ),
              ),
            ),
          ),
          // Pulse ring 2 (offset phase)
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) {
              final v2 = (_pulseCtrl.value + 0.5) % 1.0;
              return Transform.scale(
                scale: 1.0 + v2 * 0.55,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12 * (1 - v2)),
                  ),
                ),
              );
            },
          ),
          // Icon container
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutBack,
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.22),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: RotationTransition(
                  turns: Tween(begin: -0.1, end: 0.0).animate(anim),
                  child: child,
                ),
              ),
              child: Icon(
                isCheckedIn
                    ? Icons.fingerprint_rounded
                    : Icons.touch_app_rounded,
                key: ValueKey(isCheckedIn),
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailingIcon(bool isCheckedIn) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: Container(
        key: ValueKey(isCheckedIn),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.15),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
        ),
        child: Icon(
          isCheckedIn ? Icons.check_rounded : Icons.arrow_forward_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
