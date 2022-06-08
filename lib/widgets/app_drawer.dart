import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_models_and_providers/auth_provider.dart';
import '../screens/add_announcement_screen.dart';
import '../screens/manage_announcements_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeOfDevice = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        width: sizeOfDevice.width * (1 / 4),
        child: Column(
          children: [
            AppBar(
              title: Text('Hello!'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: Icon(Icons.announcement),
              title: Text('Announcements'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Your announcements'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ManageAnnouncementsScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add announcement'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AddAnnouncementScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
