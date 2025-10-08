// Removed unused import
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ukrainian_font_utils.dart';
import 'famous_character_chat_screen.dart';
import 'famous_character_prompts.dart';
import '../../core/utils/env_config.dart';
import '../widgets/background_painters.dart';

class LocalPulseRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  LocalPulseRingPainter({required this.progress, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.3 * (1 - progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * (1 + progress);
    final double radius = size.width / 2 * (0.8 + progress * 0.2);
    final Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, paint);
  }
  @override
  bool shouldRepaint(LocalPulseRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class FamousCharacterProfileScreen extends StatefulWidget {
  final String name;
  final String years;
  final String profession;
  final String? imageUrl;

  const FamousCharacterProfileScreen({
    Key? key,
    required this.name,
    required this.years,
    required this.profession,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<FamousCharacterProfileScreen> createState() =>
      _FamousCharacterProfileScreenState();
}

class _FamousCharacterProfileScreenState
    extends State<FamousCharacterProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late String _selectedModel;

  @override
  void initState() {
    super.initState();

    // Initialize the selected model
    _selectedModel = FamousCharacterPrompts.getSelectedModel(widget.name);

    // Set up animation for the pulsing effect
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final shortBio =
        FamousCharacterPrompts.getShortBio(context, widget.name) ??
        localizations.noBiographyAvailable;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundStart,
        title: Text(localizations.profileOf.replaceAll('{name}', widget.name)),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character Performance Stage
              Container(
                height: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.warmGold.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.cosmicBlack.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Stage backdrop with dramatic gradient
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppTheme.deepNavy, AppTheme.cosmicBlack],
                            ),
                          ),
                        ),
                      ),

                      // Digital circuit pattern background (suggesting AI)
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.15,
                          child: CustomPaint(
                            painter: DigitalBackgroundPainter(
                              lineColor: AppTheme.warmGold,
                            ),
                          ),
                        ),
                      ),

                      // Spotlight cone effect
                      Positioned(
                        top: -40,
                        child: Container(
                          width: 260,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.topCenter,
                              radius: 0.8,
                              colors: [
                                AppTheme.warmGold.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Dramatic mask presentation
                      Center(
                        child: Container(
                          width: 200,
                          height: 230,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.warmGold.withValues(alpha: 0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child:
                              widget.imageUrl != null
                                  ? Center(
                                    child: Container(
                                      width: 190,
                                      height: 220,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.warmGold
                                                .withValues(alpha: 0.1),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        widget.imageUrl!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                  : Center(
                                    child: Icon(
                                      Icons.face,
                                      color: AppTheme.warmGold.withValues(alpha: 0.5),
                                      size: 80,
                                    ),
                                  ),
                        ),
                      ),

                      // Additional spotlight highlight for the mask
                      Center(
                        child: Container(
                          width: 210,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(100),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.5,
                              colors: [
                                AppTheme.warmGold.withValues(alpha: 0.05),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Pulsing energy ring (signifying AI consciousness)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return RepaintBoundary(
                            child: CustomPaint(
                              size: const Size(280, 280),
                              painter: LocalPulseRingPainter(
                                progress: _pulseAnimation.value,
                                color: AppTheme.warmGold,
                              ),
                            ),
                          );
                        },
                      ),

                      // "Character" label
                      Positioned(
                        bottom: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.deepNavy.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.warmGold.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.profession,
                            style: UkrainianFontUtils.cinzelWithUkrainianSupport(
                              text: widget.profession,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.warmGold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Start Chat button near the top
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToChat(context),
                  icon: const Icon(Icons.chat_bubble_outline, size: 20),
                  label: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      'Chat with ${widget.name.split(' ').first}',
                      style: UkrainianFontUtils.latoWithUkrainianSupport(
                        text: 'Chat with ${widget.name.split(' ').first}',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.midnightPurple,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warmGold,
                    foregroundColor: AppTheme.midnightPurple,
                    elevation: 6,
                    shadowColor: AppTheme.warmGold.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.warmGold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      context: context,
                      label: 'Name',
                      value: widget.name,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context: context,
                      label: 'Years',
                      value: widget.years,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context: context,
                      label: 'Profession',
                      value: widget.profession,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Biography
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.warmGold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.biography,
                      style: UkrainianFontUtils.cinzelWithUkrainianSupport(
                        text: localizations.biography,
                        color: AppTheme.warmGold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      shortBio,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // AI Model section (shown on both platforms; _buildModelDropdown handles iOS gating)
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.warmGold.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.aiModel,
                        style: UkrainianFontUtils.cinzelWithUkrainianSupport(
                          text: localizations.aiModel,
                          color: AppTheme.warmGold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildModelDropdown(),
                    ],
                  ),
                ),

              // Removed: bottom Start Conversation (moved near the top)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    final localizations = AppLocalizations.of(context);
    
    // Get localized label
    String localizedLabel;
    switch (label) {
      case 'Name':
        localizedLabel = localizations.name;
        break;
      case 'Years':
        localizedLabel = localizations.years;
        break;
      case 'Profession':
        localizedLabel = localizations.profession;
        break;
      default:
        localizedLabel = label;
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            localizedLabel,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FamousCharacterChatScreen(
              characterName: widget.name,
              imageUrl: widget.imageUrl,
            ),
      ),
    ).then((_) {
      // After closing chat, also close profile to return to gallery
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  Widget _buildModelDropdown() {
    // On iOS: show Apple-only unless Cloud AI is enabled. If enabled, show Apple + two API models
    if (Platform.isIOS) {
      if (!EnvConfig.isCloudAiEnabledCached()) {
        return _buildModelOption(
          context: context,
          id: 'local/apple-intelligence',
          name: 'Apple Intelligence',
          description: 'On-device Apple Foundation Models',
          isRecommended: true,
          isLocal: true,
          isSelected: true,
        );
      }

      final models = [
        {
          'id': 'local/apple-intelligence',
          'name': 'Apple Intelligence',
          'description': 'On-device Apple Foundation Models',
          'recommended': true,
          'isLocal': true,
        },
        {
          'id': 'anthropic/claude-sonnet-4',
          'name': 'Claude 4 Sonnet',
          'description': 'Latest Claude with enhanced reasoning and capabilities.',
          'recommended': false,
          'isLocal': false,
        },
        {
          'id': 'openai/gpt-5-chat',
          'name': 'GPT-5 Chat',
          'description': 'Long-context, strong reasoning and coding. Via OpenRouter.',
          'recommended': false,
          'isLocal': false,
        },
        {
          'id': 'google/gemini-2.5-pro',
          'name': 'Gemini 2.5 Pro',
          'description': AppLocalizations.of(context).speedMultimodalSupport,
          'recommended': false,
          'isLocal': false,
        },
        {
          'id': 'deepseek/deepseek-chat-v3.1:free',
          'name': 'DeepSeek Chat v3.1 (Free)',
          'description': 'Free model with solid conversational abilities',
          'recommended': false,
          'isLocal': false,
        },
      ];

      return Column(
        children: [
          ...models.map(
            (model) => _buildModelOption(
              context: context,
              id: model['id'] as String,
              name: model['name'] as String,
              description: model['description'] as String,
              isRecommended: model['recommended'] == true,
              isLocal: model['isLocal'] == true,
              isSelected: _selectedModel == model['id'],
            ),
          ),
        ],
      );
    }
    // Get available models for this character (Android)
    final models = FamousCharacterPrompts.getModelsForCharacter(widget.name);

    return Column(
      children: [
        ...models
            .map(
              (model) => _buildModelOption(
                context: context,
                id: model['id'] as String,
                name: model['name'] as String,
                description: (model['id'] == 'local/gemma-3-1b-it')
                    ? AppLocalizations.of(context).downloadGemmaModel
                    : (model['description'] as String),
                isRecommended: model['recommended'] == true,
                isLocal: model['isLocal'] == true,
                    isSelected: _selectedModel == model['id'],
              ),
            ),
      ],
    );
  }

  Widget _buildModelOption({
    required BuildContext context,
    required String id,
    required String name,
    required String description,
    required bool isRecommended,
    bool isLocal = false,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color:
            isSelected ? AppTheme.deepIndigo.withValues(alpha: 0.7) : Colors.black12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isSelected
                  ? AppTheme.warmGold.withValues(alpha: 0.7)
                  : AppTheme.warmGold.withValues(alpha: 0.2),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedModel = id;
            });
            FamousCharacterPrompts.setSelectedModel(widget.name, id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Model updated'),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  isLocal ? Icons.phone_android : Icons.cloud,
                  color: isLocal ? Colors.green : AppTheme.warmGold,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isRecommended)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.warmGold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'RECOMMENDED',
                                style: TextStyle(
                                  color: AppTheme.warmGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
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
    );
  }
}
