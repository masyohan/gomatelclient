import 'package:flutter/material.dart';

import 'package:flutter_mata_elang/style/style.dart';
import 'package:flutter_mata_elang/style/icon.dart';
import 'package:flutter_mata_elang/widgets/buttons/main_button.dart';
import 'package:flutter_mata_elang/widgets/buttons/primary_button.dart';
import 'package:flutter_mata_elang/widgets/menus/menu_drawer.dart';
import 'package:flutter_mata_elang/services/service_locator.dart';
import 'package:flutter_mata_elang/managers/sql_manager.dart';
import 'package:flutter_mata_elang/managers/csv_manager.dart';
import 'package:flutter_mata_elang/pages/search_page.dart';

class DataPage extends StatefulWidget {
  DataPage({Key key}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  bool disabled = false;
  bool load = false;
  bool insert = false;
  Future kembali() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
  }

  Future<void> _showSuccess() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sukses"),
          content: new Text("Berhasil Melakukan Sinkronisasi !"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Oke"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _showError() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Registrasi Gagal"),
          content: new Text("Silahkan lakukan registrasi kembali !"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Oke"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => kembali(),
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(child: MenuDrawer()),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                height: 48.0,
                child: MainButton(
                    icon: STIcon.menu,
                    onPressed: (context) =>
                        scaffoldKey.currentState.openDrawer()),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 20.0,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('',
                          style: Style.h6.copyWith(color: Style.slategrey)),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 100.0, bottom: 10.0),
                        child: StreamBuilder<bool>(
                            stream: getIt.get<CsvManager>().switchLoad,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (snapshot.hasData) {
                                load = snapshot.data;
                              }
                              return StreamBuilder<bool>(
                                  stream: getIt.get<SqlManager>().switchInsert,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    if (snapshot.hasData) {
                                      insert = snapshot.data;
                                      if (load || insert) {
                                        disabled = true;
                                      } else {
                                        disabled = false;

                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SearchPage()));
                                          _showSuccess();
                                        });
                                      }
                                    }

                                    if (disabled) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                              width: 30.0,
                                              height: 30.0,
                                              child:
                                                  CircularProgressIndicator()),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                                'Proses sinkronisasi data sedang berjalan..\n\nTunggu hingga proses selesai',
                                                style: Style.subTitle1.copyWith(
                                                    color: Style.red)),
                                          )
                                        ],
                                      );
                                    } else {
                                      return PrimaryButton(
                                        label: disabled
                                            ? 'Proses sinkronisasi'
                                            : 'Sinkron Data Anda',
                                        onPressed: (context) {
                                          disabled = true;
                                          getIt
                                              .get<CsvManager>()
                                              .loadCsv
                                              .execute();
                                        },
                                        disabled: disabled,
                                      );
                                    }
                                  });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            'Harap selalu update data anda agar mendapat data yang akurat dan up to date',
                            style:
                                Style.body2.copyWith(color: Style.slategrey)),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
