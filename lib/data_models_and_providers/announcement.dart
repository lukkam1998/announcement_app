import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Category {
  All,
  Electronics,
  Animals,
  Fruits,
}

class Announcement {
  String? id;
  Category? category;
  String title;
  String description;
  String imageUrl;
  String userNumber;
  String userEmail;
  double price;

  Announcement({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.userEmail,
    required this.userNumber,
    required this.price,
  });

  String crypticNumber() {
    return userNumber.replaceRange(1, userNumber.length - 1, '*******');
  }
}

class Announcements with ChangeNotifier {
  final String? authToken;
  final String? userId;

  Announcements(this.authToken, this.userId, this._announcementsList);

  List<Announcement> _announcementsList = [
    // Announcement(
    //   id: '1',
    //   category: Category.Fruits,
    //   title: 'Apple',
    //   description: 'Sample apple description',
    //   imageUrl:
    //       'https://image.ceneostatic.pl/data/products/85220053/i-jablko-zielone.jpg',
    //   userEmail: 'sample1@email.com',
    //   userNumber: '543234543',
    //   price: 20.00,
    // ),
    // Announcement(
    //   id: '2',
    //   category: Category.Fruits,
    //   title: 'Pear',
    //   description: 'Sample pear description',
    //   imageUrl: 'https://healthjade.net/wp-content/uploads/2017/10/pear.jpg',
    //   userEmail: 'sample2@email.com',
    //   userNumber: '959513542',
    //   price: 25.00,
    // ),
    // Announcement(
    //   id: '3',
    //   category: Category.Fruits,
    //   title: 'Watermelon',
    //   description: 'Sample watermelon description',
    //   imageUrl:
    //       'https://stalowezdrowie.pl/wp-content/uploads/2019/01/arbuz-768x492.jpg',
    //   userEmail: 'sample3@email.com',
    //   userNumber: '799451331',
    //   price: 29.00,
    // ),
    // Announcement(
    //   id: '4',
    //   category: Category.Animals,
    //   title: 'Little dog',
    //   description:
    //       'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia,Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia,Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.',
    //   imageUrl:
    //       'https://www.elliotcolburn.co.uk/sites/www.elliotcolburn.co.uk/files/styles/gallery_large/public/2020-09/Puppy.jpg?itok=uK15H7zi',
    //   userEmail: 'sample5@email.com',
    //   userNumber: '799451331',
    //   price: 120.00,
    // ),
    // Announcement(
    //   id: '5',
    //   category: Category.Electronics,
    //   title: 'GTX 2060',
    //   description:
    //       'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia,Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia,Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.',
    //   imageUrl:
    //       'https://cdn.x-kom.pl/i/setup/images/prod/big/product-new-big,,2019/1/pr_2019_1_14_8_40_32_538_05.jpg',
    //   userEmail: 'sample5@email.com',
    //   userNumber: '799451331',
    //   price: 420.00,
    // ),
  ];

  List<Announcement> get announcements {
    return [..._announcementsList];
  }

  Announcement announcementById(String id) {
    return _announcementsList.firstWhere((element) => element.id == id);
  }

  List<Announcement> announcementsByCategory(Category category) {
    return [
      ..._announcementsList.where((element) => element.category == category)
    ];
  }

  List<Announcement> searchKeywordInAnnouncements(
    List<Announcement> announcList,
    String keyword,
  ) {
    return [
      ...announcList.where(
        (element) => (_searchKeywordInText(element.title, keyword) ||
            _searchKeywordInText(element.description, keyword)),
      )
    ];
  }

  // Simple searching
  bool _searchKeywordInText(String element, String keyword) {
    if (element.toLowerCase().contains(keyword.toLowerCase()) ||
        element.toUpperCase().contains(keyword.toUpperCase())) {
      return true;
    }
    return false;
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    final url = Uri.parse(
        'https://announcementapp-7356b-default-rtdb.europe-west1.firebasedatabase.app/announcements.json?auth=$authToken');
    try {
      await http
          .post(
        url,
        body: json.encode({
          'creatorId': userId,
          'title': announcement.title,
          'description': announcement.description,
          'email': announcement.userEmail,
          'price': announcement.price,
          'number': announcement.userNumber,
          'category': announcement.category.toString(),
          'imageUrl': announcement.imageUrl,
        }),
      )
          .then((response) {
        announcement.id = json.decode(response.body)['name'];
        _announcementsList.add(announcement);
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAnnouncements([bool filterByUser = false]) async {
    var filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://announcementapp-7356b-default-rtdb.europe-west1.firebasedatabase.app/announcements.json?auth=$authToken$filterString');
    try {
      final response = await http.get(url);
      final extractedAnnouncements =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Announcement> loadedAnnouncements = [];

      extractedAnnouncements.forEach(
        (announcementId, announcementData) {
          Category category =
              _getCategoryFromString(announcementData['category']);

          loadedAnnouncements.add(
            Announcement(
                id: announcementId,
                category: category,
                title: announcementData['title'],
                description: announcementData['description'],
                imageUrl: announcementData['imageUrl'],
                userEmail: announcementData['email'],
                userNumber: announcementData['number'],
                price: announcementData['price']),
          );
        },
      );
      _announcementsList = loadedAnnouncements;
      notifyListeners();
    } catch (exception) {
      throw exception;
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    final url = Uri.parse(
        'https://announcementapp-7356b-default-rtdb.europe-west1.firebasedatabase.app/announcements/$id.json?auth=$authToken');
    final existingAnnouncementIndex =
        _announcementsList.indexWhere((element) => element.id == id);
    Announcement? existingAnnouncement =
        _announcementsList[existingAnnouncementIndex];
    _announcementsList.removeAt(existingAnnouncementIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _announcementsList.insert(
        existingAnnouncementIndex,
        existingAnnouncement,
      );
      throw HttpException('Could not delete announcements');
    } else {
      existingAnnouncement = null;
    }
  }

  Category _getCategoryFromString(String cat) {
    switch (cat) {
      case 'Category.Electronics':
        return Category.Electronics;
      case 'Category.Animals':
        return Category.Animals;
      case 'Category.Fruits':
        return Category.Fruits;
      default:
        return Category.All;
    }
  }
}
