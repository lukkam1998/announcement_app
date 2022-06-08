import 'package:announcements_app/data_models_and_providers/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_models_and_providers/announcement.dart';
import '../../screens/announcement_details_screen.dart';

class AnnouncementTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loadedFilters = Provider.of<FilterProvider>(context).category;
    final loadedKeywords = Provider.of<FilterProvider>(context).keyword;

    List<Announcement> loadedAnnouncements;

    if (loadedFilters != Category.All) {
      loadedAnnouncements = Provider.of<Announcements>(context)
          .announcementsByCategory(loadedFilters);
    } else {
      loadedAnnouncements = Provider.of<Announcements>(context).announcements;
    }

    if (!loadedKeywords.isEmpty) {
      loadedAnnouncements =
          Provider.of<Announcements>(context).searchKeywordInAnnouncements(
        loadedAnnouncements,
        loadedKeywords,
      );
    }

    return ListView.builder(
      itemBuilder: (context, index) => AnnouncementItem(
        loadedAnnouncements[index],
      ),
      itemCount: loadedAnnouncements.length,
    );
  }
}

class AnnouncementItem extends StatelessWidget {
  Announcement announcement;

  AnnouncementItem(this.announcement);

  @override
  Widget build(BuildContext context) {
    final sizeOfDevice = MediaQuery.of(context).size;

    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AnnouncementDetailsScreen.routeName,
            arguments: announcement.id,
          );
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              height: sizeOfDevice.height * (1 / 5),
              width: double.infinity,
              child: Hero(
                tag: '${announcement.id}',
                child: Image.network(
                  announcement.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: sizeOfDevice.height * (1 / 16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(3),
                      bottomRight: Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: sizeOfDevice.width * (1 / 30),
                      ),
                      Text(
                        announcement.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeOfDevice.height * (1 / 40),
                        ),
                      ),
                      SizedBox(
                        width: sizeOfDevice.width * (1 / 30),
                      ),
                      Text(
                        '${announcement.price} \$',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: sizeOfDevice.height * (1 / 45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
