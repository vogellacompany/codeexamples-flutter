import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

import '../main.dart';
import '../models/models.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.users),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCreateUserDialog(context, appState, l10n),
          ),
        ],
      ),
      body: appState.users.isEmpty
          ? _buildEmptyState(context, l10n)
          : _buildUsersList(context, appState, l10n),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No users yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first user to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateUserDialog(context, Provider.of<AppState>(context, listen: false), l10n),
            icon: Icon(Icons.add),
            label: Text(l10n.createUser),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, AppState appState, AppLocalizations l10n) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: appState.users.length,
      itemBuilder: (context, index) {
        final user = appState.users[index];
        return _buildUserCard(context, user, appState, l10n);
      },
    );
  }

  Widget _buildUserCard(BuildContext context, User user, AppState appState, AppLocalizations l10n) {
    final isCurrentUser = appState.currentUser?.id == user.id;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCurrentUser ? Theme.of(context).primaryColor : Colors.grey[400],
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Created: ${_formatDate(user.createdAt)}'),
            Text('Language: ${user.preferredLanguage == 'de' ? l10n.german : l10n.english}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCurrentUser)
              Chip(
                label: Text('Current'),
                backgroundColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(color: Colors.white, fontSize: 12),
              ),
            PopupMenuButton<String>(
              onSelected: (action) {
                switch (action) {
                  case 'select':
                    _selectUser(user, appState);
                    break;
                  case 'delete':
                    _showDeleteUserDialog(context, user, appState, l10n);
                    break;
                }
              },
              itemBuilder: (context) => [
                if (!isCurrentUser)
                  PopupMenuItem(
                    value: 'select',
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 8),
                        Text(l10n.selectUser),
                      ],
                    ),
                  ),
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
          ],
        ),
        onTap: isCurrentUser ? null : () => _selectUser(user, appState),
      ),
    );
  }

  void _selectUser(User user, AppState appState) async {
    try {
      await appState.setCurrentUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ${user.name} selected')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select user: $e')),
      );
    }
  }

  void _showCreateUserDialog(BuildContext context, AppState appState, AppLocalizations l10n) {
    final nameController = TextEditingController();
    String selectedLanguage = 'en';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.createUser),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.userName,
                  hintText: 'Enter user name',
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => _createUser(context, nameController.text, selectedLanguage, appState),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _createUser(BuildContext context, String name, String language, AppState appState) async {
    if (name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a user name')),
      );
      return;
    }

    try {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        createdAt: DateTime.now(),
        preferredLanguage: language,
      );

      await appState.addUser(user);
      
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ${user.name} created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create user: $e')),
      );
    }
  }

  void _showDeleteUserDialog(BuildContext context, User user, AppState appState, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => _deleteUser(context, user, appState),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteUser(BuildContext context, User user, AppState appState) async {
    try {
      await appState.deleteUser(user.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ${user.name} deleted')),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}