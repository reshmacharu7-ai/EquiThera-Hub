// lib/screens/features/ai_medical_helpline_screen.dart
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class AiMedicalHelplineScreen extends StatefulWidget {
  final UserProfile? user;
  const AiMedicalHelplineScreen({super.key, this.user});

  @override
  State<AiMedicalHelplineScreen> createState() => _AiMedicalHelplineScreenState();
}

class _AiMedicalHelplineScreenState extends State<AiMedicalHelplineScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _typing = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello! I\'m your AI Medical Assistant. I can help with general health questions, medication queries, symptoms, and medical advice. How can I help you today?',
      'time': '09:00 AM',
    },
  ];

  final _qaPairs = {
    'headache': 'Headaches can be caused by stress, dehydration, or tension. Try drinking water, resting in a dark room, and taking paracetamol if needed. If your headache is severe, sudden, or comes with visual changes, please consult a doctor immediately.',
    'fever': 'A fever above 38°C (100.4°F) is a sign your body is fighting infection. Stay hydrated, rest, and take paracetamol or ibuprofen to reduce it. Seek medical care if fever exceeds 39.5°C, lasts more than 3 days, or is accompanied by rash, difficulty breathing, or confusion.',
    'cold': 'For the common cold: rest, drink plenty of fluids, use saline nasal spray, and take antihistamines for congestion. Most colds resolve in 7–10 days. Antibiotics don\'t help with viral colds.',
    'diabetes': 'Diabetes management involves monitoring blood sugar, taking medications as prescribed, eating a low-glycemic diet, regular exercise, and regular checkups. HbA1c should be checked every 3 months. Target fasting glucose: 80–130 mg/dL.',
    'blood pressure': 'High blood pressure (above 140/90) requires lifestyle changes: reduce salt, exercise regularly, maintain healthy weight, limit alcohol, and quit smoking. Medications like Amlodipine or Losartan may be prescribed. Monitor BP daily and log readings.',
    'chest pain': '⚠️ IMPORTANT: Chest pain can indicate a serious condition. If you experience sudden chest pain with shortness of breath, sweating, or arm/jaw pain, call emergency services immediately. Do not ignore chest pain — seek medical attention right away.',
    'cough': 'A dry cough can be treated with honey-lemon water, steam inhalation, and cough suppressants. A productive cough may need expectorants. If cough persists more than 3 weeks, produces blood, or is accompanied by fever and shortness of breath, see a doctor.',
    'stomach': 'Stomach pain/upset can have many causes. For mild cases: rest, stay hydrated, avoid solid food initially, and try antacids. For severe abdominal pain, vomiting blood, or pain that worsens — seek emergency care.',
    'sleep': 'For better sleep: maintain a consistent schedule, avoid screens before bed, keep your room cool and dark, avoid caffeine after 2 PM, and try deep breathing exercises. If insomnia persists, consult a doctor — CBT-I is the gold standard treatment.',
    'anxiety': 'Anxiety management: deep breathing (4-7-8 technique), mindfulness meditation, regular exercise, and limiting caffeine. If anxiety is severe, interferes with daily life, or includes panic attacks, please speak with a mental health professional.',
    'covid': 'For COVID-19: rest, stay hydrated, take paracetamol for fever, isolate from others, and monitor oxygen levels. Seek emergency care if oxygen drops below 94%, breathing becomes difficult, or chest pain develops.',
  };

  final _quickQuestions = [
    'I have a headache',
    'How to manage diabetes?',
    'I have a fever of 38.5°C',
    'Tips for better sleep',
    'Blood pressure advice',
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
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final now = TimeOfDay.now();
    final timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.period.name.toUpperCase()}';

    setState(() {
      _messages.add({'sender': 'user', 'text': text.trim(), 'time': timeStr});
      _typing = true;
    });
    _msgCtrl.clear();
    _scrollDown();

    // Simulate typing delay
    final delay = 1200 + Random().nextInt(800);
    await Future.delayed(Duration(milliseconds: delay));
    if (!mounted) return;

    final response = _generateResponse(text.toLowerCase());
    setState(() {
      _typing = false;
      _messages.add({'sender': 'ai', 'text': response, 'time': timeStr});
    });
    _scrollDown();
  }

  String _generateResponse(String query) {
    for (final entry in _qaPairs.entries) {
      if (query.contains(entry.key)) return entry.value;
    }
    if (query.contains('hi') || query.contains('hello') || query.contains('hey')) {
      return 'Hello! I\'m here to help with your health questions. Feel free to ask about symptoms, medications, diet, or general wellness.';
    }
    if (query.contains('thank')) {
      return 'You\'re welcome! Remember, I provide general health information. Always consult a qualified doctor for medical diagnosis and treatment.';
    }
    return 'That\'s an important health concern. I recommend consulting with your doctor for a proper evaluation. In the meantime, rest, stay hydrated, and monitor your symptoms. If you notice any worsening or emergency symptoms, seek immediate medical care.\n\n📞 Emergency: 112  |  Ambulance: 108';
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A192F), Color(0xFF112240)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00D4FF), Color(0xFF005577)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.support_agent_rounded,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AI Medical Helpline',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins')),
                          Row(
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF43E97B),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text('Online — Typically replies instantly',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 11,
                                      fontFamily: 'Poppins')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick questions
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _quickQuestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => _sendMessage(_quickQuestions[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFF00D4FF).withOpacity(0.3)),
                    ),
                    child: Text(_quickQuestions[i],
                        style: const TextStyle(
                            color: Color(0xFF00D4FF),
                            fontSize: 11,
                            fontFamily: 'Poppins')),
                  ),
                ),
              ),
            ),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length + (_typing ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == _messages.length && _typing) {
                    return _typingBubble();
                  }
                  final msg = _messages[i];
                  final isUser = msg['sender'] == 'user';
                  return _messageBubble(
                    msg['text'] as String,
                    isUser,
                    msg['time'] as String,
                  );
                },
              ),
            ),

            // Input
            Container(
              color: const Color(0xFF112240),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: TextField(
                          controller: _msgCtrl,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 13),
                          onSubmitted: _sendMessage,
                          decoration: InputDecoration(
                            hintText: 'Ask a health question...',
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontFamily: 'Poppins',
                                fontSize: 13),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.07),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                  color: Color(0xFF00D4FF)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _sendMessage(_msgCtrl.text),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFF005577)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
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

  Widget _messageBubble(String text, bool isUser, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D4FF), Color(0xFF005577)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.support_agent_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                  colors: [Color(0xFF00D4FF), Color(0xFF0055FF)],
                )
                    : null,
                color: isUser ? null : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text,
                      style: TextStyle(
                          color: isUser ? Colors.white : Colors.white.withOpacity(0.85),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          height: 1.5)),
                  const SizedBox(height: 4),
                  Text(time,
                      style: TextStyle(
                          color: isUser
                              ? Colors.white.withOpacity(0.6)
                              : Colors.white.withOpacity(0.3),
                          fontSize: 10,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _typingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D4FF), Color(0xFF005577)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.support_agent_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _dot(i)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + index * 200),
      builder: (_, v, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF00D4FF).withOpacity(0.4 + v * 0.6),
        ),
      ),
    );
  }
}