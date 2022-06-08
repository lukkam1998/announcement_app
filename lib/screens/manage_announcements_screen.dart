import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../data_models_and_providers/announcement.dart';

class ManageAnnouncementsScreen extends StatelessWidget {
  static const routeName = '/manage_announcements_screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Announcements>(context, listen: false)
        .fetchAnnouncements(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Manage announcements'),
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snap) => snap.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return _refreshProducts(context);
                },
                child: Consumer<Announcements>(
                  builder: (ctx, announcementsData, _) => Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView.builder(
                      itemBuilder: (ctx, index) => Column(
                        children: [
                          ListTile(
                            title: Text(
                              announcementsData.announcements[index].title,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                announcementsData.announcements[index].imageUrl,
                              ),
                            ),
                            trailing: Container(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Cancel'),
                                  IconButton(
                                    onPressed: () async {
                                      try {
                                        await Provider.of<Announcements>(context,
                                                listen: false)
                                            .deleteAnnouncement(announcementsData
                                                .announcements[index].id!);
                                      } catch (error) {
                                        print(error);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Deleting failed!',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Theme.of(context).errorColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                      itemCount: announcementsData.announcements.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
