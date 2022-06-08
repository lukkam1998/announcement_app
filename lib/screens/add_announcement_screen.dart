import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_models_and_providers/announcement.dart';
import '../data_models_and_providers/filter_provider.dart';
import '../widgets/app_drawer.dart';

class AddAnnouncementScreen extends StatefulWidget {
  static const routeName = '/add_announcement_screen';

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  Category dropdownValue = Category.Animals;

  final _form = GlobalKey<FormState>();
  var _announcement = Announcement(
    id: null,
    category: null,
    title: '',
    description: '',
    imageUrl: '',
    userEmail: '',
    userNumber: '',
    price: 0,
  );
  bool _isLoading = false;

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    _announcement.category = dropdownValue;

    setState(() {
      _isLoading = true;
    });

    Provider.of<Announcements>(context, listen: false)
        .addAnnouncement(_announcement)
        .catchError((error) {
            return showDialog<Null>(context: context, builder: (ctx) => AlertDialog(
              title: Text('An error occured'),
              content: Text('Something went wrong'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
        })
        .then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeOfDevice = MediaQuery.of(context).size;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Add your announcement'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Choose category'),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        height: sizeOfDevice.height * (1 / 14),
                        child: DropdownButton<Category>(
                          value: dropdownValue,
                          underline: Container(
                            height: 2,
                            color: ColorScheme.fromSwatch().secondary,
                          ),
                          onChanged: (newValue) {
                            dropdownValue = newValue!;
                            setState(() {});
                          },
                          icon: const Icon(Icons.arrow_downward),
                          items: <Category>[
                            Category.Electronics,
                            Category.Animals,
                            Category.Fruits,
                          ]
                              .map<DropdownMenuItem<Category>>(
                                (Category e) => DropdownMenuItem<Category>(
                                  value: e,
                                  child: Text(e.name.toString()),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _announcement.title = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value';
                          }
                          if (value.length > 15 || value.length < 6) {
                            return 'Please provide title between 6 - 15 characters';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _announcement.description = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value';
                          }
                          if (value.length > 500 || value.length < 20) {
                            return 'Please provide description between 20 - 500 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _announcement.price = double.parse(value!);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) < 0) {
                            return 'Please enter number greater than zero.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.url,
                        onSaved: (value) {
                          _announcement.imageUrl = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide an URL';
                          }
                          if (!value.startsWith('http') ||
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('jpg') &&
                              !value.endsWith('bmp')) {
                            return 'Pleas enter a valid image URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Telephone Number',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _announcement.userNumber = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a telephone number';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please provide a valid telephone number';
                          }
                          if (value.length != 9) {
                            return 'Your number have to have 9 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _announcement.userEmail = value!;
                        },
                        validator: (value) {
                          bool isEmailValid = RegExp(
                                  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(value!);
                          if (!isEmailValid) {
                            return 'Please provide valid e-mail';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
