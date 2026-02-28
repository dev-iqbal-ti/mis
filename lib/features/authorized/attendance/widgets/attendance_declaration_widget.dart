import 'package:dronees/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AttendanceDeclarationWidget extends StatefulWidget {
  final VoidCallback onAgree;

  const AttendanceDeclarationWidget({super.key, required this.onAgree});

  @override
  State<AttendanceDeclarationWidget> createState() =>
      _AttendanceDeclarationWidgetState();
}

class _AttendanceDeclarationWidgetState
    extends State<AttendanceDeclarationWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnim;
  late List<Animation<Offset>> _slideAnims;
  late Animation<double> _buttonScale;

  final List<Map<String, dynamic>> _points = [
    {
      'icon': Icons.location_on_rounded,
      'label': 'On-Site Arrival',
      'text': 'I have reached the project site and am physically present.',
      'gradient': [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    },
    {
      'icon': Icons.verified_user_rounded,
      'label': 'Authorization',
      'text': 'I am authorized to mark on-site attendance for today.',
      'gradient': [Color(0xFF0EA5E9), Color(0xFF2563EB)],
    },
    {
      'icon': Icons.camera_alt_rounded,
      'label': 'Photo Upload',
      'text':
          'For field survey jobs, I will upload a photo to the gallery as required.',
      'gradient': [Color(0xFF10B981), Color(0xFF059669)],
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1.0,
    );

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _slideAnims = List.generate(
      _points.length,
      (i) =>
          Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _slideController,
              curve: Interval(
                i * 0.15,
                0.6 + i * 0.15,
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    _buttonScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _onButtonTap() async {
    await _buttonController.reverse();
    await _buttonController.forward();
    widget.onAgree();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top handle + gradient header
            _buildHeader(),

            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Declaration cards
                  ...List.generate(_points.length, (i) {
                    return SlideTransition(
                      position: _slideAnims[i],
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: _buildPointCard(_points[i], i),
                      ),
                    );
                  }),

                  const SizedBox(height: 28),

                  // Agree button
                  _buildAgreButton(),

                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Your location may be recorded upon agreement',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey[400],
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.primary, Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.fact_check_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attendance Declaration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Confirm the following to proceed',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointCard(Map<String, dynamic> point, int index) {
    final List<Color> gradients = List<Color>.from(point['gradient'] as List);

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradients[0].withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient icon box
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradients,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gradients[0].withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              point['icon'] as IconData,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: gradients[0],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  point['text'] as String,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Checkmark badge
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradients),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreButton() {
    return ScaleTransition(
      scale: _buttonScale,
      child: GestureDetector(
        onTap: _onButtonTap,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [TColors.primary, Color(0xFF2563EB), Color(0xFF3B82F6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle shine overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 28,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'I Agree & Continue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
