import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import '../models/models.dart';
import 'users_screen.dart';
import 'texts_screen.dart';
import 'training_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final l10n = AppLocalizations.of(context)!;

    // If no user is selected, show user selection
    if (appState.currentUser == null) {
      return UsersScreen();
    }

    final screens = [
      _buildHomeTab(context, appState, l10n),
      TextsScreen(),
      TrainingScreen(),
      ProgressScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: l10n.texts,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: l10n.training,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: l10n.progress,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context, AppState appState, AppLocalizations l10n) {
    final user = appState.currentUser!;
    final availableTexts = appState.availableTexts;
    final completedSessions = appState.completedSessions;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'change_user') {
                _changeUser(context, appState);
              } else if (value == 'settings') {
                _showSettings(context, appState, l10n);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'change_user',
                child: Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 8),
                    Text('Change User'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text(l10n.settings),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${user.name}!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            'Ready for your next dictation session?',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Quick stats
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Available Texts',
                    '${availableTexts.length}',
                    Icons.text_snippet,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Completed Sessions',
                    '${completedSessions.length}',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Errors',
                    '${_calculateTotalErrors(completedSessions)}',
                    Icons.error_outline,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Average Accuracy',
                    '${_calculateAverageAccuracy(completedSessions)}%',
                    Icons.trending_up,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Recent sessions
            if (completedSessions.isNotEmpty) ...[
              Text(
                'Recent Sessions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              ...completedSessions.take(3).map((session) => _buildSessionCard(context, session, appState)),
            ],
            
            SizedBox(height: 24),
            
            // Quick actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            
            if (availableTexts.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => setState(() => _selectedIndex = 2),
                icon: Icon(Icons.play_arrow),
                label: Text(l10n.startTraining),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            
            SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: () => setState(() => _selectedIndex = 1),
              icon: Icon(Icons.add),
              label: Text(l10n.addText),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
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

  Widget _buildSessionCard(BuildContext context, TrainingSession session, AppState appState) {
    final text = appState.texts.firstWhere(
      (t) => t.id == session.textId,
      orElse: () => DictationText.create(
        id: 'unknown',
        title: 'Unknown Text',
        content: '',
        language: 'en',
      ),
    );

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        title: Text(text.title),
        subtitle: Text(
          '${session.totalErrors} errors • ${_formatDate(session.completedAt!)}',
        ),
        trailing: Text(
          '${(100 - (session.totalErrors / session.totalSegments * 100)).round()}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  int _calculateTotalErrors(List<TrainingSession> sessions) {
    return sessions.fold(0, (sum, session) => sum + session.totalErrors);
  }

  int _calculateAverageAccuracy(List<TrainingSession> sessions) {
    if (sessions.isEmpty) return 0;
    
    final totalAccuracy = sessions.fold(0.0, (sum, session) {
      if (session.totalSegments == 0) return sum;
      return sum + (100 - (session.totalErrors / session.totalSegments * 100));
    });
    
    return (totalAccuracy / sessions.length).round();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _changeUser(BuildContext context, AppState appState) async {
    await appState.setCurrentUser(null);
  }

  void _showSettings(BuildContext context, AppState appState, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settings),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.language),
              trailing: DropdownButton<String>(
                value: appState.appLanguage,
                onChanged: (language) {
                  if (language != null) {
                    appState.setAppLanguage(language);
                    Navigator.of(context).pop();
                  }
                },
                items: [
                  DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                  DropdownMenuItem(value: 'de', child: Text(l10n.german)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}