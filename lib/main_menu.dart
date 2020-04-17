import 'package:crud_test/views/home.dart';
import 'package:crud_test/views/product.dart';
import 'package:crud_test/views/profile.dart';
import 'package:crud_test/views/users.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("main menu"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.lock_open),
                onPressed: () {
                  signOut();
                })
          ],
        ),
        body: TabBarView(
          children: <Widget>[Home(), Product(), Users(), Profile()],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(style: BorderStyle.none)),
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.apps),
              text: "Product",
            ),
            Tab(
              icon: Icon(Icons.group),
              text: "Users",
            ),
            Tab(
              icon: Icon(Icons.account_circle),
              text: "Profile",
            )
          ],
        ),
      ),
    );
  }
}
