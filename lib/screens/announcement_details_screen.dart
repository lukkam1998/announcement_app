import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_models_and_providers/announcement.dart';
import '../widgets/announcement_details_screen_widgets/image_container.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  static const routeName = '/announcement_details_screen';

  @override
  State<AnnouncementDetailsScreen> createState() => _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  bool isTelephoneNumberDisplayed = false;

  @override
  Widget build(BuildContext context) {
    final sizeOfDevice = MediaQuery.of(context).size;
    final announcementId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedAnnouncement =
        Provider.of<Announcements>(context, listen: false)
            .announcementById(announcementId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement app'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageContainer(
              sizeOfDevice: sizeOfDevice,
              loadedAnnouncement: loadedAnnouncement,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${loadedAnnouncement.title}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Text(
                'Price: ${loadedAnnouncement.price} \$',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Text(
                '${loadedAnnouncement.description}',
                textAlign: TextAlign.start,
              ),
            ),
            const Text(
              'Contact',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Text(
                'Email: ' + loadedAnnouncement.userEmail,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text('Telephone number:'),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {
                      isTelephoneNumberDisplayed = !isTelephoneNumberDisplayed;
                      setState(() {});
                    },
                    child: Text(
                        isTelephoneNumberDisplayed ? '${loadedAnnouncement.userNumber}' :
                      '${loadedAnnouncement.crypticNumber()}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
