// lib/screens/features/transgender/gender_affirmation_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';

class GenderAffirmationScreen extends StatefulWidget {
  final UserProfile? user;
  const GenderAffirmationScreen({super.key, this.user});

  @override
  State<GenderAffirmationScreen> createState() =>
      _GenderAffirmationScreenState();
}

class _GenderAffirmationScreenState extends State<GenderAffirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;
  bool _addingRecord = false;

  final List<Map<String, dynamic>> _surgeries = [
    {
      'name': 'Breast Augmentation',
      'date': 'April 12, 2024',
      'hospital': 'Chennai Fortis Hospital',
      'surgeon': 'Dr. Meena Krishnan',
      'status': 'Completed',
      'notes': 'Smooth recovery. Follow-up in 6 months.',
      'icon': Icons.healing_rounded,
      'color': const Color(0xFFFF77AA),
    },
    {
      'name': 'Facial Feminization Surgery (FFS)',
      'date': 'November 3, 2023',
      'hospital': 'Apollo Specialty Hospital',
      'surgeon': 'Dr. Rajan Subramanian',
      'status': 'Completed',
      'notes': 'Rhinoplasty + brow bone reduction. Excellent results.',
      'icon': Icons.face_rounded,
      'color': const Color(0xFFAA77FF),
    },
    {
      'name': 'Voice Feminization Surgery',
      'date': 'August 20, 2025',
      'hospital': 'MIOT International',
      'surgeon': 'Dr. Priya Selvam',
      'status': 'Planned',
      'notes': 'Pre-op assessment complete. Awaiting date confirmation.',
      'icon': Icons.record_voice_over_rounded,
      'color': const Color(0xFF55CDFC),
    },
  ];

  final _preOpSteps = [
    {'label': 'Psychiatric Clearance', 'done': true},
    {'label': 'Endocrinologist Clearance', 'done': true},
    {'label': 'Real Life Experience (12 months)', 'done': true},
    {'label': 'Pre-op Blood Work', 'done': true},
    {'label': 'Anesthesia Assessment', 'done': false},
    {'label': 'Insurance/Financial Clearance', 'done': false},
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('📝 Add Surgery Record — Coming Soon',
                  style: TextStyle(fontFamily: 'Poppins')),
              backgroundColor: const Color(0xFF43E97B),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        backgroundColor: const Color(0xFF43E97B),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Record',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600)),
      ),
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
                                colors: [Color(0xFF43E97B), Color(0xFF0077AA)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.healing_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text('Gender Affirmation Records',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins')),
                          ),
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

            // Summary card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _glassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryCol('2', 'Completed', const Color(0xFF43E97B)),
                      _vDiv(),
                      _summaryCol('1', 'Planned', const Color(0xFF55CDFC)),
                      _vDiv(),
                      _summaryCol('0', 'Pending', const Color(0xFFFFAA44)),
                    ],
                  ),
                ),
              ),
            ),

            // Pre-op checklist
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text('📋 Pre-Op Readiness Checklist',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins')),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _glassCard(
                  child: Column(
                    children: _preOpSteps.map((step) {
                      final done = step['done'] as bool;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: done
                                    ? const Color(0xFF43E97B)
                                    : Colors.white.withOpacity(0.07),
                                border: done
                                    ? null
                                    : Border.all(
                                    color: Colors.white.withOpacity(0.2)),
                              ),
                              child: done
                                  ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 14)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              step['label'] as String,
                              style: TextStyle(
                                  color: done
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  decoration: done
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor:
                                  Colors.white.withOpacity(0.4)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Surgery records
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text('🏥 Surgery Records',
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
                  final s = _surgeries[i];
                  final color = s['color'] as Color;
                  final completed = s['status'] == 'Completed';
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                    child: _glassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(s['icon'] as IconData,
                                    color: color, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s['name'] as String,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins')),
                                    Text(s['date'] as String,
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 12,
                                            fontFamily: 'Poppins')),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: completed
                                      ? const Color(0xFF43E97B).withOpacity(0.15)
                                      : const Color(0xFF55CDFC).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  s['status'] as String,
                                  style: TextStyle(
                                      color: completed
                                          ? const Color(0xFF43E97B)
                                          : const Color(0xFF55CDFC),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                _infoRow('Hospital', s['hospital'] as String),
                                const SizedBox(height: 6),
                                _infoRow('Surgeon', s['surgeon'] as String),
                                const SizedBox(height: 6),
                                _infoRow('Notes', s['notes'] as String),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _surgeries.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 11,
                  fontFamily: 'Poppins')),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Poppins')),
        ),
      ],
    );
  }

  Widget _summaryCol(String value, String label, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins')),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
                fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _vDiv() =>
      Container(height: 36, width: 1, color: Colors.white.withOpacity(0.1));

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
