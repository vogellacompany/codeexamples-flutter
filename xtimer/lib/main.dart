import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XTimer - Interval Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatefulWidget {
  const TimerHomePage({super.key});

  @override
  State<TimerHomePage> createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Timer configuration
  final TextEditingController _minutesController = TextEditingController(text: '5');
  final TextEditingController _eventsController = TextEditingController(text: '5');
  
  // Timer state
  bool _isTimerRunning = false;
  bool _isAlarmActive = false;
  Timer? _timer;
  int _currentEvent = 0;
  int _totalEvents = 0;
  int _waitTimeMinutes = 0;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _minutesController.dispose();
    _eventsController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    // Bring app to foreground when notification is tapped
    setState(() {
      _isAlarmActive = true;
    });
  }

  void _startTimer() {
    final minutes = int.tryParse(_minutesController.text) ?? 5;
    final events = int.tryParse(_eventsController.text) ?? 5;
    
    if (minutes <= 0 || events <= 0) {
      _showError('Please enter valid positive numbers');
      return;
    }

    setState(() {
      _isTimerRunning = true;
      _currentEvent = 0;
      _totalEvents = events;
      _waitTimeMinutes = minutes;
      _remainingSeconds = minutes * 60;
    });

    _runTimerCycle();
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isAlarmActive = false;
      _currentEvent = 0;
      _remainingSeconds = 0;
    });
  }

  void _runTimerCycle() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        _currentEvent++;
        _triggerAlarm();
        
        if (_currentEvent >= _totalEvents) {
          _stopTimer();
        } else {
          // Reset for next cycle
          setState(() {
            _remainingSeconds = _waitTimeMinutes * 60;
          });
        }
      }
    });
  }

  Future<void> _triggerAlarm() async {
    setState(() {
      _isAlarmActive = true;
    });

    // Show notification
    await _showNotification();
    
    // Play alarm sound (if available)
    // Note: You would need to add an alarm sound file to assets
    // _audioPlayer.play(AssetSource('alarm.mp3'));
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'timer_channel',
      'Timer Notifications',
      channelDescription: 'Notifications for timer events',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Timer Alert!',
      'Event $_currentEvent of $_totalEvents completed. Tap to dismiss.',
      notificationDetails,
    );
  }

  void _dismissAlarm() {
    setState(() {
      _isAlarmActive = false;
    });
    _audioPlayer.stop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('XTimer - Interval Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Configuration Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Timer Configuration',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minutesController,
                            enabled: !_isTimerRunning,
                            decoration: const InputDecoration(
                              labelText: 'Wait Time (minutes)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _eventsController,
                            enabled: !_isTimerRunning,
                            decoration: const InputDecoration(
                              labelText: 'Number of Events',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Timer Status Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Timer Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    if (_isTimerRunning) ...[
                      Text(
                        'Event ${_currentEvent + 1} of $_totalEvents',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 1 - (_remainingSeconds / (_waitTimeMinutes * 60)),
                      ),
                    ] else ...[
                      const Text(
                        'Timer not running',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isTimerRunning ? null : _startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Timer'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isTimerRunning ? _stopTimer : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Timer'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Alarm Dismissal
            if (_isAlarmActive) ...[
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.alarm,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ALARM ACTIVE!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Event $_currentEvent completed',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _dismissAlarm,
                        icon: const Icon(Icons.alarm_off),
                        label: const Text('Dismiss Alarm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
