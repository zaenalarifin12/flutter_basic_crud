import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String nama, username, password;
  final _key = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              TextFormField(
                onSaved: (e) => nama = e,
                validator: (e){
                  if(e.isEmpty){
                    return "nama harus di isi";
                  }
                },
                decoration: InputDecoration(labelText: "Nama"),
              ),
              TextFormField(
                onSaved: null,
                validator: (e) {
                  if(e.isEmpty){
                    return "username harus diisi";
                  }
                },
                decoration: InputDecoration(
                  labelText: "Username"
                ),
              ),
              TextFormField(
                obscureText: true,
                onSaved: null,
                validator: (e) {
                  if(e.isEmpty){
                    return "password tidak boleh kosong";
                  }
                },
                decoration: InputDecoration(
                  labelText: "password"
                ),
              ),
              RaisedButton(
                child: Text(
                  "Register"
                ),
                  onPressed: (){}
              )
            ],
          )),
    );
  }
}