// lib/screens/features/transgender/transition_timeline_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';

class TransitionTimelineScreen extends StatefulWidget {
  final UserProfile? user;
  const TransitionTimelineScreen({super.key, this.user});

  @override
  State<TransitionTimelineScreen> createState() =>
      _TransitionTimelineScreenState();
}

class _TransitionTimelineScreenState extends State<TransitionTimelineScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final List<Map<String, dynamic>> _milestones = [
    {
      'date': 'January 2022',
      'title': 'Self-Discovery & Acceptance',
      'desc': 'Began exploring gender identity. Came out privately to family and close friends.',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFFFF77AA),
      'category': 'Social',
      'completed': true,
    },
    {
      'date': 'March 2022',
      'title': 'First Therapist Session',
      'desc': 'Started working with a gender-affirming therapist. Received formal gender dysphoria diagnosis.',
      'icon': Icons.psychology_rounded,
      'color': const Color(0xFFAA77FF),
      'category': 'Medical',
      'completed': true,
    },
    {
      'date': 'June 2022',
      'title': 'Social Transition',
      'desc': 'Began presenting full-time as female. Changed name and pronouns socially.',
      'icon': Icons.people_rounded,
      'color': const Color(0xFF55CDFC),
      'category': 'Social',
      'completed': true,
    },
    {
      'date': 'September 2022',
      'title': 'HRT Started',
      'desc': 'First prescription for Estradiol Valerate + Spironolactone from endocrinologist.',
      'icon': Icons.vaccines_rounded,
      'color': const Color(0xFF43E97B),
      'category': 'Medical',
      'completed': true,
    },
    {
      'date': 'November 2023',
      'title': 'FFS Surgery',
      'desc': 'Facial Feminization Surgery at Apollo Specialty Hospital. Rhinoplasty + brow reduction.',
      'icon': Icons.healing_rounded,
      'color': const Color(0xFFFF6B6B),
      'category': 'Surgery',
      'completed': true,
    },
    {
      'date': 'January 2024',
      'title': 'Legal Name Change',
      'desc': 'Filed and approved legal name change. Updated Aadhaar, PAN, and passport documents.',
      'icon': Icons.badge_rounded,
      'color': const Color(0xFFF7971E),
      'category': 'Legal',
      'completed': true,
    },
    {
      'date': 'April 2024',
      'title': 'Breast Augmentation',
      'desc': 'Breast augmentation procedure completed at Fortis Hospital. Recovery smooth.',
      'icon': Icons.medical_services_rounded,
      'color': const Color(0xFFFF77AA),
      'category': 'Surgery',
      'completed': true,
    },
    {
      'date': 'August 2025',
      'title': 'Voice Feminization Surgery',
      'desc': 'Planned procedure at MIOT International. Pre-op assessment complete.',
      'icon': Icons.record_voice_over_rounded,
      'color': const Color(0xFF55CDFC),
      'category': 'Surgery',
      'completed': false,
    },
    {
      'date': '2026 (Planned)',
      'title': 'Gender Reassignment Surgery',
      'desc': 'Researching options. Consulting with specialists in Thailand and India.',
      'icon': Icons.local_hospital_rounded,
      'color': const Color(0xFFAA77FF),
      'category': 'Surgery',
      'completed': false,
    },
  ];

  String _filterCategory = 'All';
  final _categories = ['All', 'Social', 'Medical', 'Surgery', 'Legal'];

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

  List<Map<String, dynamic>> get _filteredMilestones => _filterCategory == 'All'
      ? _milestones
      : _milestones.where((m) => m['category'] == _filterCategory).toList();

  @override
  Widget build(BuildContext context) {
    final name = widget.user?.name ?? 'User';
    final completed = _milestones.where((m) => m['completed'] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✨ Add Milestone — Coming Soon',
                style: TextStyle(fontFamily: 'Poppins')),
            backgroundColor: const Color(0xFFFFAA44),
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        backgroundColor: const Color(0xFFDD2277),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Milestone',
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
              expandedHeight: 180,
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
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 44),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFAA44), Color(0xFFDD2277)],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.timeline_rounded,
                                    color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Transition Timeline',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Poppins')),
                                  Text(
                                    "$name's Journey 🏳️‍⚧️",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 12,
                                        fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: completed / _milestones.length,
                              minHeight: 10,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFFDD2277)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$completed of ${_milestones.length} milestones completed  •  ${((completed / _milestones.length) * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                                fontFamily: 'Poppins'),
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

            // Category filter
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    final selected = cat == _filterCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _filterCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? const LinearGradient(
                            colors: [Color(0xFFFFAA44), Color(0xFFDD2277)],
                          )
                              : null,
                          color: selected ? null : Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: Text(cat,
                            style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins')),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Timeline
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, i) {
                    final m = _filteredMilestones[i];
                    final color = m['color'] as Color;
                    final completed = m['completed'] as bool;
                    final isLast = i == _filteredMilestones.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline column
                          Column(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: completed
                                      ? LinearGradient(
                                    colors: [color, color.withOpacity(0.6)],
                                  )
                                      : null,
                                  color: completed
                                      ? null
                                      : Colors.white.withOpacity(0.07),
                                  border: completed
                                      ? null
                                      : Border.all(
                                    color: color.withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  m['icon'] as IconData,
                                  color: completed
                                      ? Colors.white
                                      : color.withOpacity(0.5),
                                  size: 20,
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          color.withOpacity(0.5),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          // Content
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: isLast ? 0 : 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: completed
                                          ? color.withOpacity(0.1)
                                          : Colors.white.withOpacity(0.04),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: completed
                                              ? color.withOpacity(0.3)
                                              : Colors.white.withOpacity(0.08)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(m['title'] as String,
                                                  style: TextStyle(
                                                      color: completed
                                                          ? Colors.white
                                                          : Colors.white
                                                          .withOpacity(0.6),
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontFamily: 'Poppins')),
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3),
                                              decoration: BoxDecoration(
                                                color: color.withOpacity(0.15),
                                                borderRadius:
                                                BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                m['category'] as String,
                                                style: TextStyle(
                                                    color: color,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          m['date'] as String,
                                          style: TextStyle(
                                              color: color.withOpacity(0.8),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins'),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(m['desc'] as String,
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                height: 1.5)),
                                        if (!completed) ...[
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF55CDFC)
                                                  .withOpacity(0.15),
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              '⏳ Upcoming',
                                              style: TextStyle(
                                                  color: Color(0xFF55CDFC),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: _filteredMilestones.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
