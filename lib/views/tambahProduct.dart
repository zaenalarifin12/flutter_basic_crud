import 'dart:convert';
//import 'dart:html';

import 'package:crud_test/modal/BaseUrl.dart';
import 'package:crud_test/views/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TambahProduct extends StatefulWidget {
  final VoidCallback reload;
  TambahProduct(this.reload);

  @override
  _TambahProductState createState() => _TambahProductState();
}

class _TambahProductState extends State<TambahProduct> {
  String namaProduct, qty, harga, idUsers;

  final _key = new GlobalKey<FormState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final response = await http.post(BaseUrl.addProduct, body: {
      "namaProduct": namaProduct,
      "qty": qty,
      "harga": harga,
      "idUsers": idUsers
    });

    final data = jsonDecode(response.body);
    int value = data["value"];
    String pesan = data["pesan"];

    if (value == 1) {
      print(pesan);
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Product"),
      ),
      body: Form(
        key: _key,
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              TextFormField(
                onSaved: (e) {
                  namaProduct = e;
                },
                validator: (e) {
                  if (e.isEmpty) {
                    return "nama product masih kosong";
                  }
                },
                decoration: InputDecoration(labelText: "nama product"),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (e) {
                  qty = e;
                },
                validator: (e) {
                  if (e.isEmpty) {
                    return "stok product 0";
                  }
                },
                decoration: InputDecoration(labelText: "jumlah product"),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (e) {
                  harga = e;
                },
                validator: (e) {
                  if (e.isEmpty) {
                    return "stok product 0";
                  }
                },
                decoration: InputDecoration(labelText: "jumlah product"),
              ),
              RaisedButton(
                  color: Colors.purple,
                  child: Text("Simpan"),
                  onPressed: () {
                    check();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
