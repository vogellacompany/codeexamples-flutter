import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import '../models/models.dart';
import '../services/services.dart';

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final l10n = AppLocalizations.of(context)!;
    final availableTexts = appState.availableTexts;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.training),
      ),
      body: availableTexts.isEmpty
          ? _buildEmptyState(context, l10n)
          : _buildTextSelection(context, availableTexts, appState, l10n),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No texts for training',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some texts to start practicing',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              DefaultTabController.of(context)?.animateTo(1); // Switch to texts tab
            },
            icon: Icon(Icons.add),
            label: Text(l10n.addText),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSelection(BuildContext context, List<DictationText> texts, AppState appState, AppLocalizations l10n) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Select a text to practice',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 16),
        ...texts.map((text) => _buildTrainingTextCard(context, text, appState, l10n)),
      ],
    );
  }

  Widget _buildTrainingTextCard(BuildContext context, DictationText text, AppState appState, AppLocalizations l10n) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
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
            Text('Difficulty: ${_getDifficultyLevel(text)}'),
          ],
        ),
        trailing: ElevatedButton.icon(
          onPressed: () => _startTrainingSession(context, text, appState, l10n),
          icon: Icon(Icons.play_arrow),
          label: Text('Start'),
        ),
        isThreeLine: true,
      ),
    );
  }

  String _getDifficultyLevel(DictationText text) {
    final averageSegmentLength = text.segments.fold(0, (sum, segment) => sum + segment.length) / text.segments.length;
    
    if (averageSegmentLength < 30) return 'Easy';
    if (averageSegmentLength < 60) return 'Medium';
    return 'Hard';
  }

  void _startTrainingSession(BuildContext context, DictationText text, AppState appState, AppLocalizations l10n) {
    final session = TrainingSession.create(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: appState.currentUser!.id,
      textId: text.id,
      totalSegments: text.segments.length,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainingSessionScreen(
          text: text,
          session: session,
        ),
      ),
    );
  }
}

class TrainingSessionScreen extends StatefulWidget {
  final DictationText text;
  final TrainingSession session;

  TrainingSessionScreen({required this.text, required this.session});

  @override
  _TrainingSessionScreenState createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
  late TrainingSession currentSession;
  final TextToSpeechService ttsService = TextToSpeechService();
  final SpeechRecognitionService speechService = SpeechRecognitionService();
  
  bool isPlaying = false;
  bool isListeningForCommand = false;
  bool showErrorInput = false;
  int errorCount = 0;

  @override
  void initState() {
    super.initState();
    currentSession = widget.session;
    _setupServices();
  }

  void _setupServices() async {
    await ttsService.setLanguage(widget.text.language);
    await ttsService.configureForDictation();
    
    ttsService.setCompletionHandler(() {
      setState(() => isPlaying = false);
      _startListeningForCommands();
    });
  }

  @override
  void dispose() {
    ttsService.stop();
    speechService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentSegment = currentSession.currentSegmentIndex < widget.text.segments.length
        ? widget.text.segments[currentSession.currentSegmentIndex]
        : '';
    final progress = currentSession.currentSegmentIndex / widget.text.segments.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.text.title),
        actions: [
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () => _showExitDialog(context, l10n),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            SizedBox(height: 8),
            Text(
              'Segment ${currentSession.currentSegmentIndex + 1} of ${widget.text.segments.length}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 32),
            
            // Current segment display
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentSession.currentSegmentIndex >= widget.text.segments.length) ...[
                      // Training complete
                      Icon(Icons.celebration, size: 80, color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        l10n.trainingComplete,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Total errors: ${currentSession.totalErrors}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ] else ...[
                      // Show current segment
                      Text(
                        'Listen and write:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          currentSegment,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Control buttons
            if (currentSession.currentSegmentIndex < widget.text.segments.length) ...[
              if (!showErrorInput) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isPlaying ? null : () => _playCurrentSegment(),
                        icon: Icon(isPlaying ? Icons.volume_up : Icons.play_arrow),
                        label: Text(isPlaying ? 'Playing...' : 'Play'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isPlaying ? null : () => _playCurrentSegment(),
                        icon: Icon(Icons.replay),
                        label: Text(l10n.repeat),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: isPlaying ? null : () => _showErrorCountInput(),
                  icon: Icon(Icons.arrow_forward),
                  label: Text(l10n.next),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.green,
                  ),
                ),
              ] else ...[
                // Error count input
                _buildErrorCountInput(context, l10n),
              ],
              
              SizedBox(height: 16),
              
              // Voice command status
              if (isListeningForCommand)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Say "Next" or "Repeat"', style: TextStyle(color: Colors.red[700])),
                    ],
                  ),
                ),
            ] else ...[
              // Training complete actions
              ElevatedButton.icon(
                onPressed: () => _finishTraining(context),
                icon: Icon(Icons.check),
                label: Text('Finish Training'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCountInput(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.howManyErrors,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i <= 5; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    errorCount = i;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: errorCount == i ? Theme.of(context).primaryColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: errorCount == i ? Theme.of(context).primaryColor : Colors.grey[400]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$i',
                      style: TextStyle(
                        color: errorCount == i ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showErrorInput = false;
                    errorCount = 0;
                  });
                },
                child: Text('Cancel'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _submitErrorCount(),
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _playCurrentSegment() async {
    if (currentSession.currentSegmentIndex >= widget.text.segments.length) return;
    
    setState(() => isPlaying = true);
    
    final segment = widget.text.segments[currentSession.currentSegmentIndex];
    await ttsService.speak(segment);
  }

  void _showErrorCountInput() {
    setState(() => showErrorInput = true);
  }

  void _submitErrorCount() {
    final result = SegmentResult(
      segmentIndex: currentSession.currentSegmentIndex,
      errorCount: errorCount,
      completedAt: DateTime.now(),
    );

    setState(() {
      currentSession = currentSession.addSegmentResult(result);
      showErrorInput = false;
      errorCount = 0;
    });

    if (currentSession.currentSegmentIndex >= widget.text.segments.length) {
      // Training complete
      setState(() {
        currentSession = currentSession.complete();
      });
    }
  }

  void _startListeningForCommands() async {
    if (!await speechService.isAvailable()) return;
    
    setState(() => isListeningForCommand = true);
    
    await speechService.listenForCommand(
      onCommand: (command) {
        setState(() => isListeningForCommand = false);
        
        switch (command) {
          case VoiceCommand.next:
            _showErrorCountInput();
            break;
          case VoiceCommand.repeat:
            _playCurrentSegment();
            break;
          case VoiceCommand.stop:
            _showExitDialog(context, AppLocalizations.of(context)!);
            break;
          default:
            // Unknown command, start listening again
            Future.delayed(Duration(seconds: 1), () => _startListeningForCommands());
            break;
        }
      },
      language: widget.text.language,
    );
  }

  void _showExitDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Training'),
        content: Text('Are you sure you want to exit? Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Exit training
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Exit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _finishTraining(BuildContext context) async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.saveSession(currentSession);
      
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Training completed! Total errors: ${currentSession.totalErrors}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save training session: $e')),
      );
    }
  }
}