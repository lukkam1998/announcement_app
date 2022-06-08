import 'package:announcements_app/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/add_announcement_screen.dart';
import './data_models_and_providers/announcement.dart';
import './data_models_and_providers/filter_provider.dart';
import './data_models_and_providers/auth_provider.dart';
import './screens/announcement_details_screen.dart';
import './screens/sign_in_screen.dart';
import './screens/manage_announcements_screen.dart';

void main() {
  runApp(AnnouncementsApp());
}

class AnnouncementsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FilterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Announcements>(
          update: (context, auth, previousAnnouncements) => Announcements(
              auth.token,
              auth.userId,
              previousAnnouncements == null
                  ? []
                  : previousAnnouncements.announcements),
          create: (context) => Announcements(null, null, []),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Announcements App',
          home: authData.isAuth! ? HomeScreen() : SignInScreen(),
          theme: ThemeData(
            fontFamily: 'Raleway',
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color.fromRGBO(21, 28, 85, 1.0),
              secondary: Color.fromRGBO(168, 173, 13, 1.0),
            ),
            textTheme: TextTheme(),
          ),
          routes: {
            AnnouncementDetailsScreen.routeName: (context) =>
                AnnouncementDetailsScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
            AddAnnouncementScreen.routeName: (context) =>
                AddAnnouncementScreen(),
            ManageAnnouncementsScreen.routeName: (context) =>
                ManageAnnouncementsScreen(),
          },
        ),
      ),
    );
  }
}
