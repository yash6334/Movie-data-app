import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes_app/Widgets/addPage.dart';
import 'package:notes_app/Widgets/homePage.dart';

class PersonalisedDrawer extends StatefulWidget {
  @override
  _PersonalisedDrawerState createState() => _PersonalisedDrawerState();
}

class _PersonalisedDrawerState extends State<PersonalisedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 5,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              otherAccountsPictures: <Widget>[
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/try1.jpeg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/try2.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(),
                  ),
                ),
              ],
              accountName: Text("Yash Agarwal"),
              accountEmail: Text("yash6334@gmail.com"),
              currentAccountPicture: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/try.jpg"), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(),
                ),
              ),
            ),
            ListTile(
                title: Text("All Movies"),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false);
                }),
            ListTile(
                title: Text("Add movie"),
                trailing: Icon(Icons.arrow_right),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPage(NoteMode.Adding, null)))),
            Divider(color: Colors.blue),
            ListTile(
              title: Text("Close"),
              trailing: Icon(Icons.close),
              onTap: () => exit(0),
            ),
          ],
        ));
  }
}
