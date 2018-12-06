import 'package:flutter/material.dart';
import 'manage_parent_info.dart';

class BuildBottomNavigationBar extends StatefulWidget {

  final int currentIndex;

  BuildBottomNavigationBar(this.currentIndex);

  @override
  _BuildBottomNavigationBarState createState() => _BuildBottomNavigationBarState();
}

class _BuildBottomNavigationBarState extends State<BuildBottomNavigationBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      onTap: _goToPage,
      currentIndex: widget.currentIndex,
      fixedColor: Colors.green,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: new Icon(Icons.notifications_active),
          title: new Text('Notifications'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.person),
          title: new Text('Profile'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.child_care),
          title: Text('Children'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_vert),
          title: Text('More'),
        )
      ],
    );
  }

  void _goToPage(int value) {
    setState(() {
      if(widget.currentIndex == 0) {
        Navigator.pushNamed(context, "/notificationPage");
      }else if(widget.currentIndex == 1) {
        Navigator.pushNamed(context, "/profilePage");
      }if(widget.currentIndex == 0) {
        Navigator.pushNamed(context, "/childPage");
      }if(widget.currentIndex == 0) {
        Navigator.pushNamed(context, "/settingsPage");
      }
    });
  }
}
