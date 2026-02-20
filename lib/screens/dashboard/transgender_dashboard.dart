// lib/screens/dashboard/transgender_dashboard.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../navigation/app_routes.dart';

class TransgenderDashboard extends StatefulWidget {
  final UserProfile? user;
  const TransgenderDashboard({super.key, this.user});

  @override
  State<TransgenderDashboard> createState() => _TransgenderDashboardState();
}

class _TransgenderDashboardState extends State<TransgenderDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // 8 common + 4 transgender-specific features
  final List<Map<String, dynamic>> _commonFeatures = [
    {
      'title': 'Scan Prescription',
      'icon': Icons.document_scanner_rounded,
      'gradient': [Color(0xFF00D4FF), Color(0xFF0099BB)],
      'route': AppRoutes.scanPrescription,
    },
    {
      'title': 'Explain My Medication',
      'icon': Icons.medication_rounded,
      'gradient': [Color(0xFF7B2FFF), Color(0xFF5500DD)],
      'route': AppRoutes.explainMedication,
    },
    {
      'title': 'Drug Interaction Check',
      'icon': Icons.compare_arrows_rounded,
      'gradient': [Color(0xFFFF6B6B), Color(0xFFCC3333)],
      'route': AppRoutes.drugInteraction,
    },
    {
      'title': 'AI Medical Helpline',
      'icon': Icons.support_agent_rounded,
      'gradient': [Color(0xFF00D4FF), Color(0xFF005577)],
      'route': AppRoutes.aiMedicalHelpline,
    },
    {
      'title': 'Mental Health Support',
      'icon': Icons.psychology_rounded,
      'gradient': [Color(0xFF43E97B), Color(0xFF219653)],
      'route': AppRoutes.mentalHealthBot,
    },
    {
      'title': 'Emergency SOS',
      'icon': Icons.emergency_rounded,
      'gradient': [Color(0xFFFF4444), Color(0xFF990000)],
      'route': AppRoutes.emergencySos,
    },
    {
      'title': 'My Health Records',
      'icon': Icons.folder_special_rounded,
      'gradient': [Color(0xFFF7971E), Color(0xFFBB6600)],
      'route': AppRoutes.healthRecords,
    },
    {
      'title': 'Personalized Risk Alerts',
      'icon': Icons.monitor_heart_rounded,
      'gradient': [Color(0xFF7B2FFF), Color(0xFFFF6B6B)],
      'route': AppRoutes.riskAlerts,
    },
  ];

  final List<Map<String, dynamic>> _transFeatures = [
    {
      'title': 'Hormone Therapy Tracker',
      'icon': Icons.biotech_rounded,
      'gradient': [Color(0xFFFF77AA), Color(0xFF9900CC)],
      'route': AppRoutes.hormoneTherapyTracker,
    },
    {
      'title': 'Hormone Lab Monitoring',
      'icon': Icons.science_rounded,
      'gradient': [Color(0xFF55BBFF), Color(0xFF0044AA)],
      'route': AppRoutes.hormoneLabMonitoring,
    },
    {
      'title': 'Gender Affirmation Surgery Records',
      'icon': Icons.healing_rounded,
      'gradient': [Color(0xFF43E97B), Color(0xFF0077AA)],
      'route': AppRoutes.genderAffirmation,
    },
    {
      'title': 'Transition Timeline',
      'icon': Icons.timeline_rounded,
      'gradient': [Color(0xFFFFAA44), Color(0xFFDD2277)],
      'route': AppRoutes.transitionTimeline,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final name = (user?.name.isNotEmpty == true) ? user!.name : 'User';

    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // ── PROFILE HEADER ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A0A3F), Color(0xFF0A192F)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Trans pride banner strip
                      Container(
                        height: 6,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF55CDFC),
                              Color(0xFFF7A8B8),
                              Colors.white,
                              Color(0xFFF7A8B8),
                              Color(0xFF55CDFC),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Column(
                          children: [
                            // Avatar + name row
                            Row(
                              children: [
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF55CDFC),
                                          Color(0xFFDD2277),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF55CDFC)
                                              .withOpacity(0.4),
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        name[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF55CDFC),
                                              Color(0xFFDD2277),
                                            ],
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          '🏳️‍⚧️  Transgender',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Age ${user?.age ?? '--'}  •  Blood ${user?.bloodGroup ?? 'O+'}',
                                        style: TextStyle(
                                          color:
                                          Colors.white.withOpacity(0.6),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // HRT + hormone level chips
                            Row(
                              children: [
                                _infoChip(
                                    Icons.vaccines_rounded,
                                    'HRT',
                                    user?.hrtStatus ?? 'Active',
                                    const Color(0xFFFF77AA)),
                                const SizedBox(width: 10),
                                _infoChip(
                                    Icons.science_outlined,
                                    'Estradiol',
                                    user?.latestHormoneLevel ?? '182 pg/mL',
                                    const Color(0xFF55CDFC)),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Stats row
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color:
                                        Colors.white.withOpacity(0.12)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      _statCol('Height',
                                          '${user?.height.toStringAsFixed(0) ?? '--'} cm'),
                                      _vDiv(),
                                      _statCol('Weight',
                                          '${user?.weight.toStringAsFixed(0) ?? '--'} kg'),
                                      _vDiv(),
                                      _statCol('Records',
                                          '${user?.healthRecords.length ?? 0}'),
                                      _vDiv(),
                                      _statCol(
                                          'Visits',
                                          '${user?.hospitalVisits.length ?? 0}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── TRANS-SPECIFIC FEATURES SECTION ─────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: _sectionHeader('✨ Your Transition Care', const Color(0xFFFF77AA)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, i) {
                    final f = _transFeatures[i];
                    return _FeatureTile(
                      title: f['title'],
                      icon: f['icon'],
                      gradient: f['gradient'],
                      onTap: () => Navigator.pushNamed(
                          context, f['route'],
                          arguments: user),
                    );
                  },
                  childCount: _transFeatures.length,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
              ),
            ),

            // ── COMMON FEATURES SECTION ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _sectionHeader('🏥 Health Features', const Color(0xFF00D4FF)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, i) {
                    final f = _commonFeatures[i];
                    return _FeatureTile(
                      title: f['title'],
                      icon: f['icon'],
                      gradient: f['gradient'],
                      onTap: () => Navigator.pushNamed(
                          context, f['route'],
                          arguments: user),
                    );
                  },
                  childCount: _commonFeatures.length,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _infoChip(
      IconData icon, String label, String value, Color color) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                            fontFamily: 'Poppins')),
                    Text(value,
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCol(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Color(0xFF00D4FF),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
                fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _vDiv() => Container(
      height: 28, width: 1, color: Colors.white.withOpacity(0.1));
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Feature Tile
// ─────────────────────────────────────────────────────────────────────────────
class _FeatureTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_FeatureTile> createState() => _FeatureTileState();
}

class _FeatureTileState extends State<_FeatureTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.gradient[0].withOpacity(0.2),
                    widget.gradient[1].withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: widget.gradient[0].withOpacity(0.3), width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradient[0].withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
