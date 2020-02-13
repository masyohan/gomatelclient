import 'package:flutter/material.dart';

import 'package:flutter_mata_elang/style/style.dart';
import 'package:flutter_mata_elang/style/icon.dart';
import 'package:flutter_mata_elang/widgets/buttons/main_button.dart';
import 'package:flutter_mata_elang/widgets/menus/menu_drawer.dart';
import 'package:flutter_mata_elang/widgets/buttons/secondary_button.dart';
import 'package:flutter_mata_elang/pages/search_page.dart';
import 'package:flutter_mata_elang/services/service_locator.dart';
import 'package:flutter_mata_elang/services/data_sql.dart';
class JumlahDataPage extends StatefulWidget {
  JumlahDataPage({Key key}) : super(key: key);

  @override
  _JumlahDataPageState createState() => _JumlahDataPageState();
}

class _JumlahDataPageState extends State<JumlahDataPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int jumlahData;
  int totalData;
  Future kembali() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
  }
  void getJumlah() async{
    jumlahData = await getIt.get<DataSql>().getCount();
  }

  @override
  Widget build(BuildContext context) {
    getJumlah();
    setState(() { totalData = jumlahData; });
    print(totalData);
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
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SecondaryButton(
                            icon: Icon(Icons.data_usage),
                            label: 'Total Data : ${totalData.toString()}',
                            onPressed: (context) => print('bill')),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
