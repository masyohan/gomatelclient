import 'package:flutter/material.dart';

import 'package:flutter_mata_elang/widgets/buttons/key_button.dart';
import 'package:flutter_mata_elang/style/style.dart';
import 'package:flutter_mata_elang/style/icon.dart';
import 'package:flutter_mata_elang/widgets/buttons/main_button.dart';
import 'package:flutter_mata_elang/widgets/menus/menu_drawer.dart';
import 'package:flutter_mata_elang/widgets/keyboard/keyboard.dart';
import 'package:flutter_mata_elang/widgets/lists/search_list.dart';
import 'package:flutter_mata_elang/pages/detail_page.dart';
import 'package:flutter_mata_elang/services/service_locator.dart';
import 'package:flutter_mata_elang/managers/sql_manager.dart';
import 'package:flutter_mata_elang/model/profile.dart';
import 'package:flutter_mata_elang/pages/addbulk_page.dart';
import 'package:flutter_mata_elang/managers/csv_manager.dart';
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String _text = '';
  String _lastkey = '';
  double _height = 375.0;
  String _option = 'nopol';
  bool _hide = false;
  DateTime currentBackPressTime;

  Future<void> _synCron() async {
    await getIt.get<CsvManager>().loadCsv.execute();
    //progressDialog.dismiss();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Tekan kembali untuk keluar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<void> _showDialog() async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Lakukan Sinkronisasi ? "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ya"),
              onPressed: () async {
                //Navigator.of(context).pop();
                ProgressDialog progressDialog = ProgressDialog(context,
                    message: Text("Mengunduh data dari server"),
                    title: Text("Proses Sinkronisasi"));
                progressDialog.show();
                //await _synCron();
                await Future.delayed(Duration(seconds: 10));
                progressDialog.dismiss();
              },
            ),
            new FlatButton(
              child: new Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  onPressed(KeyboardKey key) {
    if (key.type == KeyType.text) {
      _text = _text + key.key.toUpperCase();
    } else if (key.type == KeyType.symbol) {
      switch (key.action) {
        case KeyAction.backspace:
          _text = _text.substring(0, _text.length - 1);
          break;
        case KeyAction.delete:
          _lastkey = _text;
          _text = '';
          break;
        case KeyAction.hide:
          setState(() {
            _hide = true;
            _height = 125.0;
          });
          break;
        default:
      }
    }

    (_text.isEmpty) ? print('text kosong') : print('textisi');

    getIt.get<SqlManager>().searchQuery.execute([_text, _option]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(Style.fontSize);
    return WillPopScope(
      onWillPop: () async => onWillPop(),
      child: Scaffold(
        backgroundColor: Colors.black,
        key: scaffoldKey,
        drawer: Drawer(child: MenuDrawer()),
        body: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black,
                child: Row(
                  children: <Widget>[
                    MainButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: (context) =>
                            scaffoldKey.currentState.openDrawer()),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 8.0),
//                    width: MediaQuery.of(context).size.width - 80.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Text(
                          _text,
                          style: Style.h6.copyWith(color: Style.darkindigo),
                        ),
                      ),
                    ),
                    MainButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: (context) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => AddBulkPage(
                                      platno: _text,
                                    )))),
                    /*MainButton(
                        icon: Icon(
                          Icons.sync,
                          color: Colors.white,
                        ),
                        onPressed: (context) {
                          _showDialog();
                        }) */
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height - _height,
                  child: StreamBuilder<List<dynamic>>(
                    stream: getIt.get<SqlManager>().searchCases,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      print(snapshot);
                      if (snapshot.hasData &&
                          snapshot.data.length > 0 &&
                          _text.isNotEmpty) {
                        return Container(
                          color: Colors.white,
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 3.0, bottom: 0.0),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              Profile _item =
                                  Profile.fromMap(snapshot.data[index]);
                              return Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    children: <Widget>[
                                      SearchList(
                                          profile: _item,
                                          onPressed: (context) =>
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          DetailPage(
                                                            profile: _item,
                                                          )))),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Text(
                          'Data tidak ditemukan',
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    },
                  )),
              _hide
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: KeyButton(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 10,
                        child: Icon(Icons.keyboard, color: Style.white),
                        onPressed: (context) => setState(() {
                          _hide = false;
                          _height = 375.0;
                        }),
                      ),
                    )
                  : Container(
                      color: Color(0xFFd32f2f),
                      child: SpecialKeyboard(
                        height: 302,
                        onPressed: onPressed,
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
