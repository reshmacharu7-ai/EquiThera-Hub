// lib/screens/features/mental_health_bot_screen.dart
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class MentalHealthBotScreen extends StatefulWidget {
  final UserProfile? user;
  const MentalHealthBotScreen({super.key, this.user});

  @override
  State<MentalHealthBotScreen> createState() => _MentalHealthBotScreenState();
}

class _MentalHealthBotScreenState extends State<MentalHealthBotScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _breatheCtrl;
  late Animation<double> _fade;
  late Animation<double> _breatheAnim;

  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _typing = false;
  int _selectedTab = 0;
  int _selectedMood = -1;
  bool _breathing = false;
  String _breathePhase = 'Tap to Begin';
  Timer? _breatheTimer;
  final _journalCtrl = TextEditingController();
  bool _journalSaved = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'bot',
      'text': 'Hi! I\'m Serenity, your mental health companion 💙\n\nI\'m here to listen, support you, and help with anxiety, stress, or difficult emotions. How are you feeling today?',
    },
  ];

  final _moods = [
    {'emoji': '😄', 'label': 'Great'},
    {'emoji': '🙂', 'label': 'Good'},
    {'emoji': '😐', 'label': 'Okay'},
    {'emoji': '😔', 'label': 'Low'},
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😰', 'label': 'Anxious'},
  ];

  final _moodResponses = {
    0: 'That\'s wonderful! 😊 Cherish this feeling and maybe share your joy with someone you love. What\'s making you feel great today?',
    1: 'Glad you\'re doing well! 🌟 Is there anything on your mind that you\'d like to talk about or work through?',
    2: 'That\'s okay — not every day needs to be perfect. 🌱 Sometimes "okay" is enough. Would you like to share what\'s on your mind?',
    3: 'I hear you. Feeling low is hard, and I\'m here for you. 💙 Would you like to talk about what\'s weighing on you? Sometimes sharing helps.',
    4: 'I\'m sorry you\'re feeling sad. Your feelings are valid and important. 🫂 I\'m here to listen — would you like to talk about what\'s going on?',
    5: 'Anxiety can feel overwhelming, but you\'re not alone. 🌬️ Let\'s try a quick breathing exercise together — head to the "Breathe" tab. Deep breathing can calm your nervous system in minutes.',
  };

  final _qaPairs = {
    'anxious': 'Anxiety is your body\'s natural alarm system. Try the 5-4-3-2-1 technique: name 5 things you see, 4 you can touch, 3 you hear, 2 you smell, 1 you taste. This grounds you in the present moment. The Breathe tab also has a guided breathing exercise. 🌬️',
    'stress': 'Stress often comes from feeling overwhelmed. Break your tasks into small steps, take regular breaks, and practice self-compassion. Remember — you can only do one thing at a time. What\'s stressing you most right now?',
    'sad': 'Sadness is a valid emotion and a sign you care deeply. Allow yourself to feel it without judgment. Reach out to someone you trust, spend time in nature, or do something small that brings you comfort. I\'m here to listen. 💙',
    'lonely': 'Loneliness can be painful. Consider reconnecting with an old friend, joining a community group, or even starting small conversations. You deserve connection. Would you like to talk about what\'s been making you feel isolated?',
    'sleep': 'Poor sleep worsens mental health significantly. Try: consistent sleep times, no screens 1 hour before bed, keep the room cool, and try progressive muscle relaxation. Would you like a sleep meditation script?',
    'panic': 'If you\'re feeling a panic attack coming: breathe slowly (4 counts in, 4 hold, 4 out). Remember — panic attacks peak in 10 minutes and always pass. You are safe. Try the Breathe tab right now. 🌬️',
    'hopeless': 'I hear you, and I\'m glad you\'re sharing this. Feeling hopeless is a sign that you\'re carrying too much alone. Please consider speaking with a mental health professional. In India: iCall: 9152987821 | Vandrevala Foundation: 1860-2662-345 (24/7) 💙',
    'therapy': 'Seeking therapy is one of the bravest things you can do. In India, you can find affordable therapists on platforms like YourDOST, iCall, and Practo. Many offer online sessions. Would you like tips on finding the right therapist?',
  };

  final _quickMessages = [
    'I feel anxious',
    'I\'m stressed at work',
    'I feel sad today',
    'Help me breathe',
    'I can\'t sleep',
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _breatheCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _breatheAnim = CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _breatheCtrl.dispose();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _journalCtrl.dispose();
    _breatheTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': text.trim()});
      _typing = true;
    });
    _msgCtrl.clear();
    _scrollDown();

    await Future.delayed(Duration(milliseconds: 1500 + Random().nextInt(500)));
    if (!mounted) return;
    final response = _generateResponse(text.toLowerCase());
    setState(() {
      _typing = false;
      _messages.add({'sender': 'bot', 'text': response});
    });
    _scrollDown();
  }

  String _generateResponse(String query) {
    for (final e in _qaPairs.entries) {
      if (query.contains(e.key)) return e.value;
    }
    if (query.contains('hi') || query.contains('hello')) {
      return 'Hello! 💙 I\'m so glad you\'re here. This is a safe space. How are you feeling right now?';
    }
    if (query.contains('breathe') || query.contains('breathing')) {
      return 'Absolutely! Head to the "Breathe" tab for a guided 4-7-8 breathing exercise. It activates your parasympathetic nervous system and reduces anxiety within minutes. 🌬️';
    }
    return 'Thank you for sharing that with me. It takes courage to open up. 💙 I want you to know that your feelings are completely valid. Would you like to explore what\'s behind these feelings, or would you prefer a grounding exercise to help you feel more centered right now?';
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
                  colors: [Color(0xFF0D2A1F), Color(0xFF0A192F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF43E97B), Color(0xFF219653)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.psychology_rounded,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mental Health Support',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins')),
                              Text('Serenity Bot • Private & Safe',
                                  style: TextStyle(
                                      color: Color(0xFF43E97B),
                                      fontSize: 11,
                                      fontFamily: 'Poppins')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: ['Chat', 'Breathe', 'Journal', 'Mood']
                            .asMap()
                            .entries
                            .map((e) {
                          final selected = e.key == _selectedTab;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = e.key),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: selected
                                      ? const LinearGradient(
                                    colors: [Color(0xFF43E97B), Color(0xFF219653)],
                                  )
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(e.value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: selected
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins')),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _chatTab(),
                  _breatheTab(),
                  _journalTab(),
                  _moodTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatTab() {
    return Column(
      children: [
        // Quick messages
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _quickMessages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => _sendMessage(_quickMessages[i]),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF43E97B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF43E97B).withOpacity(0.3)),
                ),
                child: Text(_quickMessages[i],
                    style: const TextStyle(
                        color: Color(0xFF43E97B),
                        fontSize: 11,
                        fontFamily: 'Poppins')),
              ),
            ),
          ),
        ),
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
              return _chatBubble(msg['text'] as String, isUser);
            },
          ),
        ),
        Container(
          color: const Color(0xFF0D2A1F),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Poppins', fontSize: 13),
                  onSubmitted: _sendMessage,
                  decoration: InputDecoration(
                    hintText: 'Share what\'s on your mind...',
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontFamily: 'Poppins',
                        fontSize: 13),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.07),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xFF43E97B)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _sendMessage(_msgCtrl.text),
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF43E97B), Color(0xFF219653)],
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
    );
  }

  Widget _breatheTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('4-7-8 Breathing Exercise',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Text('Inhale 4 • Hold 7 • Exhale 8',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 50),
          AnimatedBuilder(
            animation: _breatheAnim,
            builder: (_, __) {
              final scale = 0.7 + _breatheAnim.value * 0.5;
              return GestureDetector(
                onTap: () => setState(() => _breathing = !_breathing),
                child: Container(
                  width: 200 * scale,
                  height: 200 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF43E97B).withOpacity(0.4 + _breatheAnim.value * 0.3),
                        const Color(0xFF219653).withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF43E97B).withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF43E97B).withOpacity(0.3 * _breatheAnim.value),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _breatheAnim.value < 0.5 ? 'Inhale...' : 'Exhale...',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          Text(
            'Tap the circle to start.\nThis technique activates your\nparasympathetic nervous system.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
                fontFamily: 'Poppins',
                height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _journalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📝 Daily Journal',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Text('Writing your thoughts can reduce stress and bring clarity.',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: TextField(
                controller: _journalCtrl,
                maxLines: 10,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    height: 1.6),
                decoration: InputDecoration(
                  hintText: 'Today I feel... \nWhat\'s on my mind... \nI\'m grateful for...',
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.25),
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      height: 1.6),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.07),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF43E97B)),
                  ),
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() => _journalSaved = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('📝 Journal saved!',
                      style: TextStyle(fontFamily: 'Poppins')),
                  backgroundColor: const Color(0xFF43E97B),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43E97B), Color(0xFF219653)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  _journalSaved ? '✅ Saved!' : 'Save Journal Entry',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moodTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('😊 How are you feeling?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: _moods.asMap().entries.map((e) {
              final selected = e.key == _selectedMood;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedMood = e.key);
                  Future.delayed(const Duration(milliseconds: 400), () {
                    if (mounted) setState(() => _selectedTab = 0);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      _sendMessage(
                        'I\'m feeling ${_moods[e.key]['label']} today ${_moods[e.key]['emoji']}',
                      );
                    });
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                      colors: [Color(0xFF43E97B), Color(0xFF219653)],
                    )
                        : null,
                    color: selected ? null : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(e.value['emoji'] as String,
                          style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 6),
                      Text(e.value['label'] as String,
                          style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          if (_selectedMood >= 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF43E97B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFF43E97B).withOpacity(0.3)),
                  ),
                  child: Text(
                    _moodResponses[_selectedMood] ?? '',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        height: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chatBubble(String text, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43E97B), Color(0xFF219653)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.psychology_rounded,
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
                  colors: [Color(0xFF43E97B), Color(0xFF219653)],
                )
                    : null,
                color: isUser ? null : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(text,
                  style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      height: 1.5)),
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
                colors: [Color(0xFF43E97B), Color(0xFF219653)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('Serenity is typing...',
                style: TextStyle(
                    color: Color(0xFF43E97B),
                    fontSize: 12,
                    fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }
}