// lib/screens/features/health_records_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class HealthRecordsScreen extends StatefulWidget {
  final UserProfile? user;
  const HealthRecordsScreen({super.key, this.user});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _records = [
    {
      'title': 'Blood Test Report',
      'type': 'Lab Report',
      'date': 'Feb 15, 2026',
      'hospital': 'Apollo Diagnostics',
      'category': 'Lab',
      'icon': Icons.biotech_rounded,
      'color': const Color(0xFF00D4FF),
      'details': {'HbA1c': '7.2%', 'Glucose (F)': '118 mg/dL', 'Total Cholesterol': '195 mg/dL', 'Hemoglobin': '13.2 g/dL'},
    },
    {
      'title': 'Cardiology Consultation',
      'type': 'Consultation',
      'date': 'Jan 28, 2026',
      'hospital': 'Fortis Malar Hospital',
      'category': 'Consultation',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFFFF6B6B),
      'details': {'BP': '128/82 mmHg', 'Heart Rate': '72 bpm', 'ECG': 'Normal Sinus Rhythm', 'Diagnosis': 'Mild Hypertension'},
    },
    {
      'title': 'Chest X-Ray',
      'type': 'Radiology',
      'date': 'Jan 10, 2026',
      'hospital': 'MIOT International',
      'category': 'Radiology',
      'icon': Icons.image_rounded,
      'color': const Color(0xFF7B2FFF),
      'details': {'Findings': 'No active lesions', 'Lungs': 'Clear', 'Heart size': 'Normal', 'Impression': 'Normal CXR'},
    },
    {
      'title': 'Diabetes Follow-up',
      'type': 'Consultation',
      'date': 'Dec 20, 2025',
      'hospital': 'Apollo Hospital',
      'category': 'Consultation',
      'icon': Icons.monitor_heart_rounded,
      'color': const Color(0xFFF7971E),
      'details': {'Medication': 'Metformin 500mg BD', 'Weight': '72 kg', 'Next visit': 'March 2026', 'HbA1c target': '< 7%'},
    },
    {
      'title': 'Thyroid Function Test',
      'type': 'Lab Report',
      'date': 'Nov 5, 2025',
      'hospital': 'SRL Diagnostics',
      'category': 'Lab',
      'icon': Icons.science_rounded,
      'color': const Color(0xFF43E97B),
      'details': {'TSH': '2.8 μIU/mL', 'T3': '1.1 ng/mL', 'T4': '8.2 μg/dL', 'Status': 'Normal'},
    },
    {
      'title': 'Vaccination Record',
      'type': 'Immunization',
      'date': 'Oct 1, 2025',
      'hospital': 'Government Hospital',
      'category': 'Immunization',
      'icon': Icons.vaccines_rounded,
      'color': const Color(0xFFFF77AA),
      'details': {'Flu Vaccine': 'Administered', 'COVID Booster': 'Administered', 'Next Due': 'Oct 2026', 'Batch': 'FV2025-0941'},
    },
  ];

  final _categories = ['All', 'Lab', 'Consultation', 'Radiology', 'Immunization'];
  final Set<int> _expanded = {};

  List<Map<String, dynamic>> get _filtered => _selectedCategory == 'All'
      ? _records
      : _records.where((r) => r['category'] == _selectedCategory).toList();

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
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('📁 Upload Record — Coming Soon',
                style: TextStyle(fontFamily: 'Poppins')),
            backgroundColor: const Color(0xFFF7971E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        backgroundColor: const Color(0xFFF7971E),
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
              backgroundColor: const Color(0xFF0A192F),
              pinned: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0A192F), Color(0xFF112240)],
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
                                colors: [Color(0xFFF7971E), Color(0xFFBB6600)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.folder_special_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('My Health Records',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins')),
                              Text('${widget.user?.name ?? 'User'} • ${_records.length} records',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontFamily: 'Poppins')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Category filter
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    final selected = cat == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? const LinearGradient(
                            colors: [Color(0xFFF7971E), Color(0xFFBB6600)],
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

            // Records
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, i) {
                    final record = _filtered[i];
                    final color = record['color'] as Color;
                    final isExpanded = _expanded.contains(i);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          if (isExpanded) {
                            _expanded.remove(i);
                          } else {
                            _expanded.add(i);
                          }
                        }),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: isExpanded
                                        ? color.withOpacity(0.4)
                                        : Colors.white.withOpacity(0.1)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 48, height: 48,
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(record['icon'] as IconData,
                                            color: color, size: 24),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(record['title'] as String,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Poppins')),
                                            Text(
                                                '${record['date']}  •  ${record['hospital']}',
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.45),
                                                    fontSize: 11,
                                                    fontFamily: 'Poppins')),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.15),
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            child: Text(record['type'] as String,
                                                style: TextStyle(
                                                    color: color,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Poppins')),
                                          ),
                                          const SizedBox(height: 4),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up_rounded
                                                : Icons.keyboard_arrow_down_rounded,
                                            color: Colors.white.withOpacity(0.4),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (isExpanded) ...[
                                    const SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.04),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: (record['details']
                                        as Map<String, String>)
                                            .entries
                                            .map((e) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 6),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 130,
                                                child: Text(e.key,
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.4),
                                                        fontSize: 11,
                                                        fontFamily:
                                                        'Poppins')),
                                              ),
                                              Expanded(
                                                child: Text(e.value,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontFamily:
                                                        'Poppins')),
                                              ),
                                            ],
                                          ),
                                        ))
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _actionBtn(
                                            Icons.download_rounded, 'Download', color),
                                        const SizedBox(width: 10),
                                        _actionBtn(
                                            Icons.share_rounded, 'Share', color),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _filtered.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label — Coming Soon',
                style: const TextStyle(fontFamily: 'Poppins')),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
            ],
          ),
        ),
      ),
    );
  }
}