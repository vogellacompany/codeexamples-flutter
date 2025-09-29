import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

import '../main.dart';
import '../models/models.dart';
import '../services/services.dart';

class TextsScreen extends StatefulWidget {
  @override
  _TextsScreenState createState() => _TextsScreenState();
}

class _TextsScreenState extends State<TextsScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final l10n = AppLocalizations.of(context)!;
    final availableTexts = appState.availableTexts;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.texts),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTextDialog(context, appState, l10n),
          ),
        ],
      ),
      body: availableTexts.isEmpty
          ? _buildEmptyState(context, l10n, appState)
          : _buildTextsList(context, availableTexts, appState, l10n),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n, AppState appState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.text_snippet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No texts available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first text for dictation practice',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddTextDialog(context, appState, l10n),
            icon: Icon(Icons.add),
            label: Text(l10n.addText),
          ),
        ],
      ),
    );
  }

  Widget _buildTextsList(BuildContext context, List<DictationText> texts, AppState appState, AppLocalizations l10n) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: texts.length,
      itemBuilder: (context, index) {
        final text = texts[index];
        return _buildTextCard(context, text, appState, l10n);
      },
    );
  }

  Widget _buildTextCard(BuildContext context, DictationText text, AppState appState, AppLocalizations l10n) {
    final isOwnText = text.userId == appState.currentUser?.id;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: text.language == 'de' ? Colors.red : Colors.blue,
          child: Text(
            text.language.toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          text.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${text.segments.length} segments'),
            Text('${text.content.length} characters'),
            if (isOwnText) 
              Text('Personal text', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            switch (action) {
              case 'start_training':
                _startTraining(context, text);
                break;
              case 'preview':
                _showPreviewDialog(context, text, l10n);
                break;
              case 'delete':
                if (isOwnText) {
                  _showDeleteTextDialog(context, text, appState, l10n);
                }
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'start_training',
              child: Row(
                children: [
                  Icon(Icons.play_arrow, color: Colors.green),
                  SizedBox(width: 8),
                  Text(l10n.startTraining),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'preview',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('Preview'),
                ],
              ),
            ),
            if (isOwnText)
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text(l10n.delete, style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    text.content.length > 200 
                        ? '${text.content.substring(0, 200)}...'
                        : text.content,
                    style: TextStyle(height: 1.4),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Segments:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...text.segments.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final segment = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.left(width: 3, color: Theme.of(context).primaryColor),
                        color: Colors.blue[50],
                      ),
                      child: Text(
                        '$index. $segment',
                        style: TextStyle(height: 1.3),
                      ),
                    ),
                  );
                }).take(3), // Show only first 3 segments
                if (text.segments.length > 3)
                  Text(
                    '... and ${text.segments.length - 3} more segments',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _startTraining(context, text),
                        icon: Icon(Icons.play_arrow),
                        label: Text(l10n.startTraining),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _previewAudio(context, text),
                      icon: Icon(Icons.volume_up),
                      label: Text('Listen'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startTraining(BuildContext context, DictationText text) {
    // Navigate to training screen with selected text
    DefaultTabController.of(context)?.animateTo(2); // Switch to training tab
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting training with "${text.title}"')),
    );
  }

  void _previewAudio(BuildContext context, DictationText text) async {
    final ttsService = TextToSpeechService();
    await ttsService.setLanguage(text.language);
    await ttsService.configureForDictation();
    
    // Play first segment as preview
    if (text.segments.isNotEmpty) {
      await ttsService.speak(text.segments.first);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playing preview of first segment')),
      );
    }
  }

  void _showAddTextDialog(BuildContext context, AppState appState, AppLocalizations l10n) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedLanguage = appState.currentUser?.preferredLanguage ?? 'en';
    bool isPersonalText = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.addText),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter text title',
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: InputDecoration(labelText: l10n.language),
                  items: [
                    DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                    DropdownMenuItem(value: 'de', child: Text(l10n.german)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedLanguage = value);
                    }
                  },
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('Personal text'),
                  subtitle: Text('Only you can see this text'),
                  value: isPersonalText,
                  onChanged: (value) {
                    setState(() => isPersonalText = value ?? false);
                  },
                  dense: true,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: 'Text Content',
                      hintText: l10n.enterText,
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  onPressed: () => _useVoiceInput(context, contentController, selectedLanguage),
                  icon: Icon(Icons.mic),
                  label: Text(l10n.voiceInput),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addText(
                    context,
                    titleController.text,
                    contentController.text,
                    selectedLanguage,
                    isPersonalText,
                    appState,
                  ),
                  child: Text(l10n.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _useVoiceInput(BuildContext context, TextEditingController contentController, String language) async {
    final speechService = SpeechRecognitionService();
    
    if (!await speechService.isAvailable()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    Navigator.of(context).pop(); // Close dialog
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _VoiceInputDialog(
        language: language,
        onResult: (result) {
          contentController.text = result;
          _showAddTextDialog(context, Provider.of<AppState>(context, listen: false), AppLocalizations.of(context)!);
        },
      ),
    );
  }

  void _addText(BuildContext context, String title, String content, String language, bool isPersonal, AppState appState) async {
    if (title.trim().isEmpty || content.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both title and content')),
      );
      return;
    }

    try {
      final text = DictationText.create(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        content: content.trim(),
        language: language,
        userId: isPersonal ? appState.currentUser?.id : null,
      );

      await appState.addText(text);
      
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text "${text.title}" added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add text: $e')),
      );
    }
  }

  void _showPreviewDialog(BuildContext context, DictationText text, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text.title),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: SingleChildScrollView(
            child: Text(
              text.content,
              style: TextStyle(height: 1.4),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _startTraining(context, text);
            },
            icon: Icon(Icons.play_arrow),
            label: Text(l10n.startTraining),
          ),
        ],
      ),
    );
  }

  void _showDeleteTextDialog(BuildContext context, DictationText text, AppState appState, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Text'),
        content: Text('Are you sure you want to delete "${text.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => _deleteText(context, text, appState),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteText(BuildContext context, DictationText text, AppState appState) async {
    try {
      await appState.deleteText(text.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text "${text.title}" deleted')),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete text: $e')),
      );
    }
  }
}

class _VoiceInputDialog extends StatefulWidget {
  final String language;
  final Function(String) onResult;

  _VoiceInputDialog({required this.language, required this.onResult});

  @override
  _VoiceInputDialogState createState() => _VoiceInputDialogState();
}

class _VoiceInputDialogState extends State<_VoiceInputDialog> with TickerProviderStateMixin {
  final speechService = SpeechRecognitionService();
  String recognizedText = '';
  bool isListening = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _startListening();
  }

  @override
  void dispose() {
    _animationController.dispose();
    speechService.stopListening();
    super.dispose();
  }

  void _startListening() async {
    setState(() => isListening = true);
    
    await speechService.startListening(
      onResult: (result) {
        setState(() {
          recognizedText = result;
          isListening = false;
        });
        _animationController.stop();
      },
      language: widget.language,
      timeout: Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Voice Input'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isListening) ...[
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.3 + (_animationController.value * 0.4)),
                  ),
                  child: Icon(Icons.mic, size: 40, color: Colors.red),
                );
              },
            ),
            SizedBox(height: 16),
            Text('Listening...', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Speak your text clearly', style: TextStyle(color: Colors.grey[600])),
          ] else if (recognizedText.isNotEmpty) ...[
            Icon(Icons.check_circle, size: 60, color: Colors.green),
            SizedBox(height: 16),
            Text('Text recognized!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                recognizedText,
                style: TextStyle(height: 1.4),
              ),
            ),
          ] else ...[
            Icon(Icons.error, size: 60, color: Colors.orange),
            SizedBox(height: 16),
            Text('No speech detected', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Please try again', style: TextStyle(color: Colors.grey[600])),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        if (!isListening && recognizedText.isEmpty)
          ElevatedButton.icon(
            onPressed: _startListening,
            icon: Icon(Icons.mic),
            label: Text('Try Again'),
          ),
        if (recognizedText.isNotEmpty) ...[
          TextButton(
            onPressed: () {
              setState(() {
                recognizedText = '';
                isListening = false;
              });
              _startListening();
            },
            child: Text('Record Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onResult(recognizedText);
            },
            child: Text('Use Text'),
          ),
        ],
      ],
    );
  }
}