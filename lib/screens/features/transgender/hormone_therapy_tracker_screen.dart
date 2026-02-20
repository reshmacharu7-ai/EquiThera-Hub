// lib/screens/features/transgender/hormone_therapy_tracker_screen.dart
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';

class HormoneTherapyTrackerScreen extends StatefulWidget {
  final UserProfile? user;
  const HormoneTherapyTrackerScreen({super.key, this.user});

  @override
  State<HormoneTherapyTrackerScreen> createState() =>
      _HormoneTherapyTrackerScreenState();
}

class _HormoneTherapyTrackerScreenState
    extends State<HormoneTherapyTrackerScreen> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  bool _logAdded = false;
  int _selectedMedIndex = 0;

  final List<Map<String, dynamic>> _medications = [
    {
      'name': 'Estradiol Valerate',
      'dose': '2 mg',
      'frequency': 'Twice daily',
      'color': const Color(0xFFFF77AA),
      'icon': Icons.water_drop_rounded,
      'nextDose': '08:00 PM',
      'streak': 14,
    },
    {
      'name': 'Spironolactone',
      'dose': '100 mg',
      'frequency': 'Once daily',
      'color': const Color(0xFF55CDFC),
      'icon': Icons.medication_liquid_rounded,
      'nextDose': '09:00 AM',
      'streak': 21,
    },
    {
      'name': 'Progesterone',
      'dose': '200 mg',
      'frequency': 'At bedtime',
      'color': const Color(0xFFAA77FF),
      'icon': Icons.circle_rounded,
      'nextDose': '10:00 PM',
      'streak': 7,
    },
  ];

  final List<Map<String, dynamic>> _logs = [
    {
      'date': 'Today, 08:00 AM',
      'medication': 'Estradiol Valerate 2mg',
      'status': 'taken',
      'note': 'No side effects',
    },
    {
      'date': 'Today, 09:00 AM',
      'medication': 'Spironolactone 100mg',
      'status': 'taken',
      'note': '',
    },
    {
      'date': 'Yesterday, 10:00 PM',
      'medication': 'Progesterone 200mg',
      'status': 'taken',
      'note': 'Slight drowsiness',
    },
    {
      'date': 'Yesterday, 08:00 PM',
      'medication': 'Estradiol Valerate 2mg',
      'status': 'missed',
      'note': '',
    },
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

  void _logDose() {
    setState(() => _logAdded = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Dose logged successfully!',
            style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: const Color(0xFF43E97B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user?.name ?? 'User';
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              backgroundColor: const Color(0xFF1A0A3F),
              expandedHeight: 130,
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
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF77AA), Color(0xFF9900CC)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.biotech_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Hormone Therapy Tracker',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins')),
                              Text(
                                'Hey $name! Tracking your HRT journey 🏳️‍⚧️',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
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

            // Current medications
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: _sectionLabel('💊 Current Medications', const Color(0xFFFF77AA)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _medications.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final med = _medications[i];
                    final selected = i == _selectedMedIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMedIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 160,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: selected
                                ? [
                              (med['color'] as Color).withOpacity(0.35),
                              (med['color'] as Color).withOpacity(0.15),
                            ]
                                : [
                              Colors.white.withOpacity(0.07),
                              Colors.white.withOpacity(0.03),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? med['color'] as Color
                                : Colors.white.withOpacity(0.1),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(med['icon'] as IconData,
                                color: med['color'] as Color, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              med['name'] as String,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${med['dose']}  •  ${med['frequency']}',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 10,
                                  fontFamily: 'Poppins'),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Icon(Icons.local_fire_department_rounded,
                                    color: med['color'] as Color, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${med['streak']} day streak',
                                  style: TextStyle(
                                      color: med['color'] as Color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Next dose + log button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _glassCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF77AA).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.alarm_rounded,
                            color: Color(0xFFFF77AA), size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _medications[_selectedMedIndex]['name'] as String,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            ),
                            Text(
                              'Next dose: ${_medications[_selectedMedIndex]['nextDose']}',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _logAdded ? null : _logDose,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _logAdded
                                  ? [
                                const Color(0xFF43E97B),
                                const Color(0xFF219653),
                              ]
                                  : [
                                const Color(0xFFFF77AA),
                                const Color(0xFF9900CC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _logAdded ? '✓ Logged' : 'Log Dose',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Weekly adherence
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: _sectionLabel('📊 Weekly Adherence', const Color(0xFF55CDFC)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _glassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                            .asMap()
                            .entries
                            .map((e) {
                          final taken = e.key != 3 && e.key != 6;
                          return Column(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: taken
                                      ? const LinearGradient(
                                    colors: [
                                      Color(0xFF43E97B),
                                      Color(0xFF219653),
                                    ],
                                  )
                                      : null,
                                  color: taken
                                      ? null
                                      : Colors.white.withOpacity(0.07),
                                  border: taken
                                      ? null
                                      : Border.all(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Icon(
                                  taken ? Icons.check_rounded : Icons.close_rounded,
                                  color: taken
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(e.value,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 10,
                                      fontFamily: 'Poppins')),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 5 / 7,
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF43E97B)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('71% adherence this week — keep going! 💪',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              ),
            ),

            // Dose log
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: _sectionLabel('📋 Recent Log', Colors.white),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) {
                  final log = _logs[i];
                  final taken = log['status'] == 'taken';
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: _glassCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: taken
                                  ? const Color(0xFF43E97B).withOpacity(0.2)
                                  : const Color(0xFFFF4444).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              taken ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              color: taken
                                  ? const Color(0xFF43E97B)
                                  : const Color(0xFFFF4444),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log['medication'] as String,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins')),
                                Text(log['date'] as String,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 11,
                                        fontFamily: 'Poppins')),
                                if ((log['note'] as String).isNotEmpty)
                                  Text('Note: ${log['note']}',
                                      style: const TextStyle(
                                          color: Color(0xFF55CDFC),
                                          fontSize: 11,
                                          fontFamily: 'Poppins')),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: taken
                                  ? const Color(0xFF43E97B).withOpacity(0.15)
                                  : const Color(0xFFFF4444).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              taken ? 'Taken' : 'Missed',
                              style: TextStyle(
                                  color: taken
                                      ? const Color(0xFF43E97B)
                                      : const Color(0xFFFF4444),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _logs.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Text(text,
        style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins'));
  }

  Widget _glassCard({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(18),
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
