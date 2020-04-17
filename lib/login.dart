import 'dart:convert';
//import 'dart:html';

import 'package:crud_test/modal/BaseUrl.dart';
import 'package:crud_test/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/login_status.dart';
import 'package:http/http.dart' as http;

import 'main_menu.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn; //set kondisi awal
  String username, password, msg;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  /// SHOWHIDE PASSWORD
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  /// CHECK FORM
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  /// REQUEST POST LOGIN
  login() async {
    final response = await http.post( BaseUrl.login ,
        body: {"username": username, "password": password});

    final data = jsonDecode(response.body);

    int value       = data["value"];
    String _id       = data["id"];
    String _nama     = data["nama"];
    String _username = data["username"];

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, _id, _nama, _username);
      });
    } else {
      // gagal login
    }
  }

  savePref(int value, String id, String nama, String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("id", id);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
              preferences.getString("id");
              preferences.getString("nama");
              preferences.getString("username");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  removePref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.clear();

      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            title: Text("Login"),
          ),
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                TextFormField(
                  onSaved: (e) => username = e,
                  validator: (e) {
                    if (e.isEmpty) {
                      msg = "please insert username";
                      return msg;
                    }
                  },
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextFormField(
                    obscureText: _secureText,
                    onSaved: (e) => password = e,
                    validator: (e) {
                      if (e.isEmpty) {
                        msg = "please insert password";
                        return msg;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              showHide();
                            }))),
                RaisedButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("login"),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  child: Center(child: Text("Register akun")),
                )
              ],
            ),
          ),
        );
        break;

      case LoginStatus.signIn:
        return MainMenu(removePref);
        break;
      default:
    }
  }
}
