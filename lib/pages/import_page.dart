import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_mata_elang/style/style.dart';
import 'package:flutter_mata_elang/style/icon.dart';
import 'package:flutter_mata_elang/pages/search_page.dart';
import 'package:flutter_mata_elang/widgets/buttons/main_button.dart';
import 'package:flutter_mata_elang/widgets/menus/menu_drawer.dart';
import 'package:flutter_mata_elang/widgets/keyboard/keyboard.dart';
import 'package:flutter_mata_elang/widgets/lists/bulk_list.dart';
import 'package:flutter_mata_elang/pages/addbulk_page.dart';
import 'package:flutter_mata_elang/pages/bulk_page.dart';
import 'package:flutter_mata_elang/services/service_locator.dart';
import 'package:flutter_mata_elang/managers/blk_manager.dart';
import 'package:flutter_mata_elang/model/profile.dart';
import 'package:csv/csv.dart';
import 'package:flutter_mata_elang/managers/blk_manager.dart';
import 'package:documents_picker/documents_picker.dart';

class ImportPage extends StatefulWidget {
  ImportPage({Key key}) : super(key: key);

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String _text = '';
  String _csvpath;

  List<String> _docPaths;

  Future _getCSV() async {
    //_csvpath = await FilePicker.getFilePath(fileExtension: 'csv');
    _docPaths = await DocumentsPicker.pickDocuments;
    final _input = new File(_docPaths[0]).openRead();
    print(_docPaths[0]);
    //final _fields = await _input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    //List<Profile> _table = CsvToListConverter(eol: '\n').convert(_input.toString()).map((item) => Profile.fromList(item)).toList();
    //print(_table[5000].toMap());
    //List<Profile> _table = _fields.map((item) => Profile.fromList(item)).toList();

    //getIt.get<BlkManager>().insertBulks.execute(_table.toList());
  }

  Future kembali() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
  }

  /*onPressed(KeyboardKey key) {

    if( key.type == KeyType.text) {
      _text = _text + key.key.toUpperCase();
    } else if(key.type == KeyType.symbol) {
      switch(key.action){
        case KeyAction.backspace:
          _text = _text.substring(0, _text.length - 1);
          break;
        case KeyAction.delete:
          _text = '';
          break;
        default:
      }
    }

    getIt.get<BlkManager>().searchQuery.execute(_text);
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    getIt.get<BlkManager>().searchQuery.execute(_text);

    return WillPopScope(
      onWillPop: () async => kembali(),
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(child: MenuDrawer()),
        body: Padding(
          padding: EdgeInsets.only(top: 25.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  MainButton(
                      icon: STIcon.menu,
                      onPressed: (context) =>
                          scaffoldKey.currentState.openDrawer()),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 8.0),
                    width: MediaQuery.of(context).size.width - 106.0,
                    height: 48.0,
                  ),
                  MainButton(
                      icon: Icon(Icons.add), onPressed: (context) => _getCSV()
//                  onPressed: (context) => scaffoldKey.currentState.openDrawer()
                      ),
                ],
              ),

/*            Container(
                color: Style.white,
                child: SpecialKeyboard(
                  height: 300,
                  onPressed: onPressed,
                )
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
