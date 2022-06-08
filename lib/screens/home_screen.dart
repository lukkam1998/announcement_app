import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_models_and_providers/announcement.dart';
import '../widgets/home_screen_widgets/announcement_tiles.dart';
import '../widgets/app_drawer.dart';
import '../widgets/home_screen_widgets/filter_container.dart';
import '../widgets/home_screen_widgets/search_container.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  bool _isDataLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isDataLoading = true;
      });
      Provider.of<Announcements>(context).fetchAnnouncements().then((_) {
        setState(() {
          _isDataLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOfDevice = MediaQuery.of(context).size;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Announcement app'),
      ),
      body: _isDataLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                FiltersContainer(),
                SearchContainer(),
                Expanded(
                  child: AnnouncementTiles(),
                ),
              ],
            ),
    );
  }
}
