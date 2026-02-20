// lib/screens/dashboard/common_dashboard.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../core/widgets/glass_card.dart';
import '../../navigation/app_routes.dart';
import 'package:intl/intl.dart';

class CommonDashboard extends StatefulWidget {
  final UserProfile? user;
  const CommonDashboard({super.key, this.user});

  @override
  State<CommonDashboard> createState() => _CommonDashboardState();
}

class _CommonDashboardState extends State<CommonDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _features = [
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getRoleEmoji() {
    switch (widget.user?.role ?? '') {
      case 'Male': return '👨';
      case 'Female': return '👩';
      case 'Kids': return '👦';
      case 'Senior': return '👴';
      case 'Transgender': return '🏳️‍⚧️';
      default: return '👤';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final name = (user?.name.isNotEmpty == true) ? user!.name : 'User';
    final now = DateTime.now();
    final dateStr = DateFormat('EEE, MMM d').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A192F), Color(0xFF112240)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateStr,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_getGreeting()}, $name ${_getRoleEmoji()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            ScaleTransition(
                              scale: _pulseAnimation,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00D4FF), Color(0xFF0055FF)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00D4FF).withOpacity(0.4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Health stats row
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.07),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.12)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  _statChip('Age', '${user?.age ?? '--'}'),
                                  _divider(),
                                  _statChip('Height',
                                      '${user?.height.toStringAsFixed(0) ?? '--'} cm'),
                                  _divider(),
                                  _statChip('Weight',
                                      '${user?.weight.toStringAsFixed(0) ?? '--'} kg'),
                                  _divider(),
                                  _statChip(
                                      'Blood', user?.bloodGroup ?? 'O+'),
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

            // Features grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final feature = _features[index];
                    return _FeatureCard(
                      title: feature['title'],
                      icon: feature['icon'],
                      gradient: feature['gradient'],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          feature['route'],
                          arguments: user,
                        );
                      },
                      delay: index * 80,
                    );
                  },
                  childCount: _features.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

  Widget _statChip(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF00D4FF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 28,
      width: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final int delay;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _ctrl.forward();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _ctrl.reverse();
      },
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
                  color: widget.gradient[0].withOpacity(0.3),
                  width: 1.2,
                ),
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
                      child: Icon(widget.icon,
                          color: Colors.white, size: 28),
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
