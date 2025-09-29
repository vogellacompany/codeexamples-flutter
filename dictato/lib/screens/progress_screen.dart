import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

import '../main.dart';
import '../models/models.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final l10n = AppLocalizations.of(context)!;
    final completedSessions = appState.completedSessions;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.progress),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, completedSessions, appState, l10n),
          _buildHistoryTab(context, completedSessions, appState, l10n),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, List<TrainingSession> sessions, AppState appState, AppLocalizations l10n) {
    if (sessions.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    final stats = _calculateStats(sessions, appState);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall stats
          Text(
            'Overall Statistics',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Sessions',
                  '${sessions.length}',
                  Icons.school,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Average Accuracy',
                  '${stats.averageAccuracy}%',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Errors',
                  '${stats.totalErrors}',
                  Icons.error_outline,
                  Colors.orange,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Time Spent',
                  _formatDuration(stats.totalDuration),
                  Icons.timer,
                  Colors.purple,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Performance by language
          Text(
            'Performance by Language',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          
          ...stats.languageStats.entries.map((entry) {
            final language = entry.key;
            final languageStats = entry.value;
            final languageName = language == 'de' ? l10n.german : l10n.english;
            
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: language == 'de' ? Colors.red : Colors.blue,
                          radius: 20,
                          child: Text(
                            language.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          languageName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sessions', style: TextStyle(color: Colors.grey[600])),
                              Text('${languageStats.sessions}', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Accuracy', style: TextStyle(color: Colors.grey[600])),
                              Text('${languageStats.accuracy}%', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Errors', style: TextStyle(color: Colors.grey[600])),
                              Text('${languageStats.errors}', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          
          SizedBox(height: 24),
          
          // Recent improvement trend
          Text(
            'Recent Progress',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Improvement Trend', style: Theme.of(context).textTheme.titleMedium),
                      Icon(
                        stats.isImproving ? Icons.trending_up : Icons.trending_down,
                        color: stats.isImproving ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    stats.isImproving 
                        ? 'Your accuracy is improving! Keep up the good work!'
                        : 'Consider practicing more to improve your accuracy.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context, List<TrainingSession> sessions, AppState appState, AppLocalizations l10n) {
    if (sessions.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    // Sort sessions by completion date (newest first)
    final sortedSessions = List<TrainingSession>.from(sessions);
    sortedSessions.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: sortedSessions.length,
      itemBuilder: (context, index) {
        final session = sortedSessions[index];
        return _buildSessionCard(context, session, appState, l10n);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No training sessions yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Complete some training sessions to see your progress',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              DefaultTabController.of(context)?.animateTo(2); // Switch to training tab
            },
            icon: Icon(Icons.play_arrow),
            label: Text(l10n.startTraining),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, TrainingSession session, AppState appState, AppLocalizations l10n) {
    final text = appState.texts.firstWhere(
      (t) => t.id == session.textId,
      orElse: () => DictationText.create(
        id: 'unknown',
        title: 'Unknown Text',
        content: '',
        language: 'en',
      ),
    );

    final accuracy = session.totalSegments > 0 
        ? ((session.totalSegments - session.totalErrors) / session.totalSegments * 100).round()
        : 0;

    final accuracyColor = accuracy >= 90 ? Colors.green : accuracy >= 70 ? Colors.orange : Colors.red;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: text.language == 'de' ? Colors.red : Colors.blue,
          child: Text(
            text.language.toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        title: Text(
          text.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatDate(session.completedAt!)),
            Row(
              children: [
                Text('Accuracy: '),
                Text(
                  '$accuracy%',
                  style: TextStyle(color: accuracyColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 16),
                Text('Errors: ${session.totalErrors}'),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: accuracyColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accuracyColor.withOpacity(0.3)),
          ),
          child: Text(
            '$accuracy%',
            style: TextStyle(color: accuracyColor, fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem('Total Segments', '${session.totalSegments}'),
                    ),
                    Expanded(
                      child: _buildDetailItem('Duration', _formatDuration(session.duration)),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                Text(
                  'Segment Results',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                
                ...session.segmentResults.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final result = entry.value;
                  final segmentAccuracyColor = result.errorCount == 0 ? Colors.green : 
                      result.errorCount <= 2 ? Colors.orange : Colors.red;
                  
                  return Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text('Segment $index:', style: TextStyle(fontSize: 12)),
                        ),
                        Icon(
                          result.errorCount == 0 ? Icons.check_circle : Icons.error,
                          size: 16,
                          color: segmentAccuracyColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${result.errorCount} errors',
                          style: TextStyle(color: segmentAccuracyColor, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).take(5), // Show only first 5 segment results
                
                if (session.segmentResults.length > 5)
                  Text(
                    '... and ${session.segmentResults.length - 5} more segments',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  OverallStats _calculateStats(List<TrainingSession> sessions, AppState appState) {
    if (sessions.isEmpty) {
      return OverallStats(
        totalSessions: 0,
        totalErrors: 0,
        averageAccuracy: 0,
        totalDuration: Duration.zero,
        languageStats: {},
        isImproving: false,
      );
    }

    final totalSessions = sessions.length;
    final totalErrors = sessions.fold(0, (sum, session) => sum + session.totalErrors);
    final totalSegments = sessions.fold(0, (sum, session) => sum + session.totalSegments);
    final averageAccuracy = totalSegments > 0 
        ? ((totalSegments - totalErrors) / totalSegments * 100).round()
        : 0;
    
    final totalDuration = sessions.fold(Duration.zero, (sum, session) {
      return sum + (session.duration ?? Duration.zero);
    });

    // Calculate language stats
    final Map<String, LanguageStats> languageStats = {};
    for (final session in sessions) {
      final text = appState.texts.firstWhere(
        (t) => t.id == session.textId,
        orElse: () => DictationText.create(
          id: 'unknown',
          title: 'Unknown Text',
          content: '',
          language: 'en',
        ),
      );
      
      final language = text.language;
      if (!languageStats.containsKey(language)) {
        languageStats[language] = LanguageStats(
          sessions: 0,
          errors: 0,
          segments: 0,
          accuracy: 0,
        );
      }
      
      languageStats[language]!.sessions++;
      languageStats[language]!.errors += session.totalErrors;
      languageStats[language]!.segments += session.totalSegments;
    }

    // Calculate accuracy for each language
    for (final entry in languageStats.entries) {
      final stats = entry.value;
      stats.accuracy = stats.segments > 0 
          ? ((stats.segments - stats.errors) / stats.segments * 100).round()
          : 0;
    }

    // Check if user is improving (compare last 3 sessions with previous 3)
    bool isImproving = false;
    if (sessions.length >= 6) {
      final sortedSessions = List<TrainingSession>.from(sessions);
      sortedSessions.sort((a, b) => a.completedAt!.compareTo(b.completedAt!));
      
      final recentSessions = sortedSessions.sublist(sortedSessions.length - 3);
      final previousSessions = sortedSessions.sublist(sortedSessions.length - 6, sortedSessions.length - 3);
      
      final recentAccuracy = _calculateSessionsAccuracy(recentSessions);
      final previousAccuracy = _calculateSessionsAccuracy(previousSessions);
      
      isImproving = recentAccuracy > previousAccuracy;
    }

    return OverallStats(
      totalSessions: totalSessions,
      totalErrors: totalErrors,
      averageAccuracy: averageAccuracy,
      totalDuration: totalDuration,
      languageStats: languageStats,
      isImproving: isImproving,
    );
  }

  double _calculateSessionsAccuracy(List<TrainingSession> sessions) {
    if (sessions.isEmpty) return 0.0;
    
    final totalErrors = sessions.fold(0, (sum, session) => sum + session.totalErrors);
    final totalSegments = sessions.fold(0, (sum, session) => sum + session.totalSegments);
    
    return totalSegments > 0 ? (totalSegments - totalErrors) / totalSegments * 100 : 0.0;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration? duration) {
    if (duration == null || duration == Duration.zero) return '0m';
    
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

class OverallStats {
  final int totalSessions;
  final int totalErrors;
  final int averageAccuracy;
  final Duration totalDuration;
  final Map<String, LanguageStats> languageStats;
  final bool isImproving;

  OverallStats({
    required this.totalSessions,
    required this.totalErrors,
    required this.averageAccuracy,
    required this.totalDuration,
    required this.languageStats,
    required this.isImproving,
  });
}

class LanguageStats {
  int sessions;
  int errors;
  int segments;
  int accuracy;

  LanguageStats({
    required this.sessions,
    required this.errors,
    required this.segments,
    required this.accuracy,
  });
}