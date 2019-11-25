import 'package:flutter/material.dart';

class MyBottonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.call),
              onPressed: _called,
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: _called,
            ),
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: _called,
            ),
            IconButton(
              icon: Icon(Icons.access_alarm),
              onPressed: _called,
            ),
          ],
        ),
      ),
    );
  }

  void _called() {
    print("Debug");
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: SafeArea(
        child: Column(
          children: [
            Row(
              children: [Placeholder()],
            ),
            Row(
              children: <Widget>[Placeholder()],
            )
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
        ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text('Hello'),
              )
            ];
          },
        )
      ],
    );
  }

  void _called() {
    print("Debug");
  }

  @override
  Size get preferredSize => Size.fromHeight(40);
}
