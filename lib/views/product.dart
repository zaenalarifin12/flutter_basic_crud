import 'dart:convert';

import 'package:crud_test/modal/BaseUrl.dart';
import 'package:crud_test/modal/ProductModel.dart';
import 'package:crud_test/views/editProduct.dart';
import 'package:crud_test/views/tambahProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  Product({Key key}) : super(key: key);

  @override
  ProductState createState() => ProductState();
}

class ProductState extends State<Product> {
  var loading = false;
  final list = new List<ProductModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatProduct);

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new ProductModel(api["id"], api["namaProduct"], api["qty"],
            api["harga"], api["createDate"], api["nama"]);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              shrinkWrap: true,
              children: <Widget>[
                Text("Apakah kamu yakin menghapus product ini?"),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    InkWell(

                      onTap: () {
                        _delete(id);
                      },
                      child: Text("yes", style: TextStyle(color: Colors.red),),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response = await http.post(BaseUrl.deleteProduct, body: {"id": id});

    final data = jsonDecode(response.body);
    int value = data["value"];
    String pesan = data["pesan"];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TambahProduct(_lihatData)));
            }),
        body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(x.namaProduct),
                                Text(x.qty),
                                Text(x.harga),
                                Text(x.nama)
                              ],
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditProduct(x, _lihatData)));
                              }),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                dialogDelete(x.id);
                              })
                        ],
                      ),
                    );
                  }),
        ));
  }
}
