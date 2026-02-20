// lib/screens/features/personalized_risk_alerts_screen.dart
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class PersonalizedRiskAlertsScreen extends StatefulWidget {
  final UserProfile? user;
  const PersonalizedRiskAlertsScreen({super.key, this.user});

  @override
  State<PersonalizedRiskAlertsScreen> createState() =>
      _PersonalizedRiskAlertsScreenState();
}

class _PersonalizedRiskAlertsScreenState
    extends State<PersonalizedRiskAlertsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  bool _analyzing = false;
  bool _analyzed = false;
  double _healthScore = 0;

  final _alerts = [
    {
      'title': 'Blood Sugar Elevated',
      'desc': 'Your HbA1c is 7.2% — above the optimal 7% target for diabetics. Recommend dietary adjustments and medication review.',
      'severity': 'high',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFFFF6B6B),
      'action': 'Book endocrinologist appointment',
    },
    {
      'title': 'Blood Pressure Borderline',
      'desc': 'BP of 128/82 mmHg is in the elevated range. Monitor daily and reduce sodium intake.',
      'severity': 'medium',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFFFFAA44),
      'action': 'Monitor BP twice daily',
    },
    {
      'title': 'Cholesterol in Range',
      'desc': 'Total cholesterol 195 mg/dL is within normal range. Maintain current diet and exercise.',
      'severity': 'low',
      'icon': Icons.trending_down_rounded,
      'color': const Color(0xFF43E97B),
      'action': 'Continue healthy habits',
    },
    {
      'title': 'Thyroid Normal',
      'desc': 'TSH at 2.8 μIU/mL is well within normal range (0.4–4.0). No intervention needed.',
      'severity': 'low',
      'icon': Icons.check_circle_rounded,
      'color': const Color(0xFF43E97B),
      'action': 'Annual thyroid recheck',
    },
    {
      'title': 'Physical Activity Low',
      'desc': 'Based on your profile, low physical activity increases cardiovascular and metabolic risk.',
      'severity': 'medium',
      'icon': Icons.directions_run_rounded,
      'color': const Color(0xFFFFAA44),
      'action': '30 min walk daily',
    },
    {
      'title': 'Vaccination Up to Date',
      'desc': 'COVID booster and flu vaccine administered in October 2025. Next due October 2026.',
      'severity': 'low',
      'icon': Icons.vaccines_rounded,
      'color': const Color(0xFF43E97B),
      'action': 'Schedule Oct 2026 vaccines',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    _runAnalysis();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _runAnalysis() async {
    setState(() => _analyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Animate health score
    const targetScore = 72.0;
    const steps = 30;
    for (int i = 0; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (!mounted) return;
      setState(() => _healthScore = targetScore * i / steps);
    }

    setState(() {
      _analyzing = false;
      _analyzed = true;
    });
  }

  Color _scoreColor(double score) {
    if (score >= 80) return const Color(0xFF43E97B);
    if (score >= 60) return const Color(0xFFFFAA44);
    return const Color(0xFFFF6B6B);
  }

  String _scoreLabel(double score) {
    if (score >= 80) return 'Good';
    if (score >= 60) return 'Moderate';
    return 'Needs Attention';
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user?.name ?? 'User';
    final color = _scoreColor(_healthScore);

    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF0A192F),
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Personalized Risk Alerts',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 17)),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A192F), Color(0xFF112240)],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (_analyzing) ...[
                      const SizedBox(height: 40),
                      const CircularProgressIndicator(
                          color: Color(0xFF7B2FFF)),
                      const SizedBox(height: 16),
                      const Text('Analyzing your health data...',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(
                        'Reviewing lab reports, vitals,\nand medical history for $name',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontFamily: 'Poppins',
                            fontSize: 12),
                      ),
                    ] else ...[
                      // Health score ring
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color.withOpacity(0.12),
                                  Colors.white.withOpacity(0.04),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: color.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: CircularProgressIndicator(
                                          value: _healthScore / 100,
                                          strokeWidth: 10,
                                          backgroundColor:
                                          Colors.white.withOpacity(0.1),
                                          valueColor:
                                          AlwaysStoppedAnimation(color),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _healthScore.toStringAsFixed(0),
                                            style: TextStyle(
                                                color: color,
                                                fontSize: 26,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Poppins'),
                                          ),
                                          Text('/100',
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.4),
                                                  fontSize: 10,
                                                  fontFamily: 'Poppins')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Health Score',
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 12,
                                            fontFamily: 'Poppins'),
                                      ),
                                      Text(
                                        _scoreLabel(_healthScore),
                                        style: TextStyle(
                                            color: color,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Poppins'),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Based on your recent lab reports and vitals',
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.4),
                                            fontSize: 11,
                                            fontFamily: 'Poppins',
                                            height: 1.4),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          _smallBadge('2 High', const Color(0xFFFF6B6B)),
                                          const SizedBox(width: 6),
                                          _smallBadge('2 Medium', const Color(0xFFFFAA44)),
                                          const SizedBox(width: 6),
                                          _smallBadge('2 Good', const Color(0xFF43E97B)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Alerts
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('🔔 Risk Alerts',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins')),
                      ),
                      const SizedBox(height: 12),

                      ..._alerts.map((alert) {
                        final aColor = alert['color'] as Color;
                        final severity = alert['severity'] as String;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: aColor.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: aColor.withOpacity(0.25)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: aColor.withOpacity(0.15),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                              alert['icon'] as IconData,
                                              color: aColor,
                                              size: 18),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(alert['title'] as String,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Poppins')),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: aColor.withOpacity(0.15),
                                            borderRadius:
                                            BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            severity == 'low'
                                                ? '✓ OK'
                                                : severity == 'medium'
                                                ? '⚠️ Medium'
                                                : '🔴 High',
                                            style: TextStyle(
                                                color: aColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(alert['desc'] as String,
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.65),
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            height: 1.5)),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: aColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.arrow_forward_rounded,
                                              color: aColor, size: 14),
                                          const SizedBox(width: 8),
                                          Text(alert['action'] as String,
                                              style: TextStyle(
                                                  color: aColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins')),
    );
  }
}