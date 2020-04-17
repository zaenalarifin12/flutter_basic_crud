import 'dart:convert';

import 'package:crud_test/modal/BaseUrl.dart';
import 'package:crud_test/modal/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  final ProductModel model;
  final VoidCallback reload;
  EditProduct(this.model, this.reload);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _key = new GlobalKey<FormState>();
  String namaProduct, qty, harga;

  TextEditingController txtNama, txtQty, txtHarga;

  setup() {
    txtNama = TextEditingController(text: widget.model.namaProduct);
    txtQty  = TextEditingController(text: widget.model.qty);
    txtHarga= TextEditingController(text: widget.model.harga);
  }

  check() {
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      submit();
    }
  }
  
  submit() async {
    final response  = await http.post(BaseUrl.editProduct, body: {
      "id" : widget.model.id,
      "namaProduct" : namaProduct,
      "qty"         : qty,
      "harga"       : harga
    });

    final data    = jsonDecode(response.body);
    int value     = data["value"];
    String pesan  = data["message"];

    if(value == 1){
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    }else{
//      todo
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Product"
        ),
      ),
      body: Form(
        key: _key,
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              TextFormField(
                controller: txtNama,
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
                controller: txtQty,
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
                controller: txtHarga,
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
                  child: Text("Edit"),
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
