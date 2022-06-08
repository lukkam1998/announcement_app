import 'package:flutter/material.dart';

import '../../data_models_and_providers/announcement.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    required this.sizeOfDevice,
    required this.loadedAnnouncement,
  }) : super(key: key);

  final Size sizeOfDevice;
  final Announcement loadedAnnouncement;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: sizeOfDevice.height * (7 / 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      child: Hero(
        tag: '${loadedAnnouncement.id}',
        child: Image.network(
          loadedAnnouncement.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
