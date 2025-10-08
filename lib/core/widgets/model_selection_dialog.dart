import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../theme/app_theme.dart';
import '../utils/env_config.dart';

class ModelSelectionDialog extends StatefulWidget {
  final String currentModel;
  final Function(String) onModelSelected;

  const ModelSelectionDialog({
    Key? key,
    required this.currentModel,
    required this.onModelSelected,
  }) : super(key: key);

  static Future<String?> show(
    BuildContext context, {
    required String currentModel,
  }) async {
    // iOS: If cloud not enabled or no API key, return Apple Intelligence id directly
    if (Platform.isIOS) {
      final cloudEnabled = await EnvConfig.isCloudAiEnabled();
      final hasKey = await EnvConfig.hasUserApiKey();
      if (!(cloudEnabled && hasKey)) {
        return 'local/apple-intelligence';
      }
    }
    return await showDialog<String>(
      context: context,
      builder:
          (context) => ModelSelectionDialog(
            currentModel: currentModel,
            onModelSelected: (model) {
              Navigator.of(context).pop(model);
            },
          ),
    );
  }

  @override
  State<ModelSelectionDialog> createState() => _ModelSelectionDialogState();
}

class _ModelSelectionDialogState extends State<ModelSelectionDialog> {
  late String _selectedModel;

  // List of available models
  // You can expand this list as needed
  late final List<Map<String, dynamic>> _availableModels = Platform.isIOS
      ? [
          {
            'id': 'local/apple-intelligence',
            'name': 'Apple Intelligence',
            'provider': 'Apple (On‑device)',
            'description': 'On-device Apple Foundation Models',
            'recommended': true,
            'isLocal': true,
          },
          // If cloud is enabled and API key exists, also show top cloud models
          if (EnvConfig.isCloudAiEnabledCached()) ...[
            {
              'id': 'anthropic/claude-sonnet-4',
              'name': 'Claude 4 Sonnet',
              'provider': 'Anthropic',
              'description': 'Latest Claude with enhanced reasoning and capabilities.',
              'recommended': true,
            },
            {
              'id': 'openai/gpt-5-chat',
              'name': 'GPT-5 Chat',
              'provider': 'OpenAI',
              'description': 'Long-context, strong reasoning and coding. Via OpenRouter.',
              'recommended': false,
            },
            {
              'id': 'google/gemini-2.5-pro',
              'name': 'Gemini 2.5 Pro',
              'provider': 'Google',
              'description': 'Fast, high-quality responses with strong multimodal support.',
              'recommended': true,
            },
            {
              'id': 'meta-llama/llama-4-maverick',
              'name': 'Llama 4 Maverick',
              'provider': 'Meta',
              'description': 'Sparse mixture-of-experts, extended context.',
              'recommended': false,
            },
          ]
        ]
      : [
    {
      'id': 'local/gemma-3-1b-it',
      'name': 'Local Gemma 3 1B',
      'provider': 'Local Device',
      'description': 'On-device, instruction-tuned Gemma 3n. Private and offline.',
      'recommended': true,
      'isLocal': true,
    },
    {
      'id': 'google/gemini-2.5-pro',
      'name': 'Gemini 2.5 Pro',
      'provider': 'Google',
      'description':
          'Fast, high-quality responses with strong multimodal support.',
      'recommended': true,
    },
    {
      'id': 'anthropic/claude-sonnet-4',
      'name': 'Claude 4 Sonnet',
      'provider': 'Anthropic',
      'description': 'Latest Claude with enhanced reasoning and capabilities.',
      'recommended': true,
    },
    {
      'id': 'openai/gpt-5-chat',
      'name': 'GPT-5 Chat',
      'provider': 'OpenAI',
      'description': 'Long-context, strong reasoning and coding. Via OpenRouter.',
      'recommended': false,
    },
    {
      'id': 'meta-llama/llama-4-maverick',
      'name': 'Llama 4 Maverick',
      'provider': 'Meta',
      'description': 'Sparse mixture-of-experts, extended context.',
      'recommended': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedModel = widget.currentModel;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.deepIndigo,
      title: Text(
        'Select AI Model',
        style: const TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose the AI model that will power this character:',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _availableModels.length,
                itemBuilder: (context, index) {
                  final model = _availableModels[index];
                  final isSelected = model['id'] == _selectedModel;

                  return Card(
                    color:
                        isSelected
                            ? AppTheme.warmGold.withValues(alpha: 0.2)
                            : AppTheme.backgroundEnd.withValues(alpha: 0.3),
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            isSelected ? AppTheme.warmGold : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedModel = model['id'];
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: model['id'],
                              groupValue: _selectedModel,
                              onChanged: (value) {
                                setState(() {
                                  _selectedModel = value!;
                                });
                              },
                              fillColor: WidgetStateProperty.all(AppTheme.warmGold),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Model icon based on type
                                      Icon(
                                        model['isLocal'] == true ? Icons.phone_android : Icons.cloud,
                                        size: 16,
                                        color: model['isLocal'] == true ? Colors.green : AppTheme.warmGold,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          model['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      if (model['recommended'] == true)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.warmGold
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
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
                                  const SizedBox(height: 8),
                                  Text(
                                    model['description'],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () => widget.onModelSelected(_selectedModel),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warmGold),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
