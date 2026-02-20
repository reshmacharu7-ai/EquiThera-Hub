// lib/screens/features/transgender/hormone_lab_monitoring_screen.dart
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';

class HormoneLabMonitoringScreen extends StatefulWidget {
  final UserProfile? user;
  const HormoneLabMonitoringScreen({super.key, this.user});

  @override
  State<HormoneLabMonitoringScreen> createState() =>
      _HormoneLabMonitoringScreenState();
}

class _HormoneLabMonitoringScreenState
    extends State<HormoneLabMonitoringScreen> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _chartCtrl;
  late Animation<double> _fade;
  late Animation<double> _chartAnim;
  bool _analyzing = false;
  bool _analyzed = false;

  final List<Map<String, dynamic>> _labResults = [
    {
      'name': 'Estradiol (E2)',
      'value': '182',
      'unit': 'pg/mL',
      'range': '50–250 pg/mL',
      'status': 'normal',
      'color': const Color(0xFFFF77AA),
      'trend': [80, 110, 145, 160, 175, 182],
      'date': 'Feb 15, 2026',
    },
    {
      'name': 'Testosterone',
      'value': '28',
      'unit': 'ng/dL',
      'range': '< 50 ng/dL',
      'status': 'normal',
      'color': const Color(0xFF55CDFC),
      'trend': [120, 90, 65, 45, 35, 28],
      'date': 'Feb 15, 2026',
    },
    {
      'name': 'LH (Luteinizing Hormone)',
      'value': '2.1',
      'unit': 'mIU/mL',
      'range': '1.0–7.0 mIU/mL',
      'status': 'normal',
      'color': const Color(0xFFAA77FF),
      'trend': [8, 6, 4, 3, 2.5, 2.1],
      'date': 'Feb 15, 2026',
    },
    {
      'name': 'Progesterone',
      'value': '15.2',
      'unit': 'ng/mL',
      'range': '5–20 ng/mL',
      'status': 'normal',
      'color': const Color(0xFF43E97B),
      'trend': [2, 5, 8, 11, 13, 15.2],
      'date': 'Feb 15, 2026',
    },
    {
      'name': 'Prolactin',
      'value': '32',
      'unit': 'ng/mL',
      'range': '2–18 ng/mL',
      'status': 'high',
      'color': const Color(0xFFFF6B6B),
      'trend': [18, 20, 24, 28, 30, 32],
      'date': 'Feb 15, 2026',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _chartCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _chartAnim =
        CurvedAnimation(parent: _chartCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _chartCtrl.forward();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _chartCtrl.dispose();
    super.dispose();
  }

  void _runAnalysis() async {
    setState(() => _analyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() {
      _analyzing = false;
      _analyzed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF1A0A3F),
              expandedHeight: 110,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A0A3F), Color(0xFF0A192F)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF55BBFF), Color(0xFF0044AA)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.science_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          const Text('Hormone Lab Monitoring',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Last tested info
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: _glassCard(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: Color(0xFF55CDFC), size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Last Lab Test',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins')),
                          Text('February 15, 2026  •  Apollo Diagnostics',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF43E97B).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('4/5 Normal',
                            style: TextStyle(
                                color: Color(0xFF43E97B),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins')),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // AI analyze button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: _analyzing || _analyzed ? null : _runAnalysis,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF55BBFF), Color(0xFF0044AA)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: _analyzing
                          ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Text('Analyzing your hormones...',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600)),
                        ],
                      )
                          : Text(
                        _analyzed
                            ? '✅ AI Analysis Complete'
                            : '🤖 Run AI Analysis',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (_analyzed) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.psychology_rounded,
                                color: Color(0xFF55BBFF), size: 20),
                            SizedBox(width: 8),
                            Text('AI Interpretation',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _aiLine('✅', 'Estradiol levels are within therapeutic range for feminizing HRT.'),
                        _aiLine('✅', 'Testosterone is effectively suppressed below 50 ng/dL.'),
                        _aiLine('⚠️', 'Prolactin is elevated at 32 ng/mL. Monitor closely — discuss with your endocrinologist.'),
                        _aiLine('💡', 'Next labs recommended in 3 months. Consider MRI if prolactin continues rising.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Lab results list
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text('📊 Lab Results',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins')),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) {
                  final lab = _labResults[i];
                  final isHigh = lab['status'] == 'high';
                  final color = lab['color'] as Color;
                  final trend = lab['trend'] as List;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _glassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lab['name'] as String,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins')),
                                    Text(
                                        'Normal: ${lab['range']}  •  ${lab['date']}',
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.4),
                                            fontSize: 10,
                                            fontFamily: 'Poppins')),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${lab['value']} ${lab['unit']}',
                                    style: TextStyle(
                                        color: color,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isHigh
                                          ? const Color(0xFFFF6B6B).withOpacity(0.15)
                                          : const Color(0xFF43E97B).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isHigh ? '⚠️ High' : '✓ Normal',
                                      style: TextStyle(
                                          color: isHigh
                                              ? const Color(0xFFFF6B6B)
                                              : const Color(0xFF43E97B),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Poppins'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Mini sparkline
                          AnimatedBuilder(
                            animation: _chartAnim,
                            builder: (context, _) {
                              return SizedBox(
                                height: 40,
                                child: CustomPaint(
                                  painter: _SparklinePainter(
                                    values: trend
                                        .map((e) => (e as num).toDouble())
                                        .toList(),
                                    color: color,
                                    progress: _chartAnim.value,
                                  ),
                                  size: Size.infinite,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _labResults.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _aiLine(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final double progress;

  _SparklinePainter(
      {required this.values, required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1.0 : max - min;

    final pts = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y = size.height - ((values[i] - min) / range * size.height * 0.8 + size.height * 0.1);
      pts.add(Offset(x, y));
    }

    final drawCount = (pts.length * progress).ceil().clamp(1, pts.length);
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < drawCount; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(path, paint);

    // Fill
    final fillPath = Path.from(path);
    if (drawCount > 0) {
      fillPath.lineTo(pts[drawCount - 1].dx, size.height);
      fillPath.lineTo(pts[0].dx, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.progress != progress || old.values != values;
}
