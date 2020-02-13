import 'dart:io';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_mata_elang/managers/auth_manager.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter_mata_elang/managers/blk_manager.dart';
import 'package:flutter_mata_elang/services/service_locator.dart';
import 'package:flutter_mata_elang/style/icon.dart';
import 'package:flutter_mata_elang/style/style.dart';
import 'package:flutter_mata_elang/widgets/buttons/main_button.dart';
import 'package:flutter_mata_elang/widgets/buttons/primary_button.dart';
import 'package:flutter_mata_elang/widgets/buttons/text_button.dart';
import 'package:flutter_mata_elang/model/profile.dart';
import 'package:flutter_mata_elang/pages/addnote_page.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter_mata_elang/services/data_sql.dart';

class AddBulkPage extends StatefulWidget {
  final String platno;
  AddBulkPage({Key key, this.platno}) : super(key: key);

  @override
  _AddBulkPageState createState() => _AddBulkPageState();
}

class _AddBulkPageState extends State<AddBulkPage> {
//  Profile bulk;
  final ContactPicker _contactPicker = new ContactPicker();

  Contact _contact;
  String _data;
  String _name;
  String _phone;
  String _date;
  String _display;
  RegExp regExp = new RegExp(r'(([0-9a-zA-Z ]*,)+\w+\n?)+');
  int _currValue = 0;
  var _tipeKiriman = ['SK', 'Kiriman'];
  int _jumlahData;
  String newData;
  bool _hide;
  TextEditingController _dataController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();

  _setData() => _data = _dataController.text;
  _setPhone() => _phone = _phoneController.text;
  _setName() => _name = _nameController.text;
  _setDate() => _date = _dateController.text;
  _removeSpace() {
    newData = _data.replaceAll(" ", "");
    setState(() {
      _dataController.text = newData.toString();
    });
  }

  _setSave() {
    String _status = regExp.hasMatch(_data).toString();
    print(_status);
    String _name2 = '(' + _tipeKiriman[_currValue] + ') ' + _name;
    if (_status == 'false') {
      print('gagal input');
      _showError();
    } else {
      int _lineCount = _data.split('\n').length;
      int _commaCount = ','.allMatches(_data).length;
      print(_lineCount);
      if (_commaCount == _lineCount) {
        List<Profile> _prof = _data.split('\n').map((item) {
          List<String> _it = item.split(',');
          String _nopol = _currValue == 0 ? _it[0] + '*':_it[0];

          return Profile(
              date: _date,
              finance: _name2,
              phone: _phone,
              plate: _nopol,
              vehicle: _it[1],
              note: '',
              number: '',
              ovd: '',
              name: '',
              engine: '',
              frame: '',
              saldo: '',
              address: '');
        }).toList();
        getIt.get<BlkManager>().insertBulks.execute(_prof);
      } else {
        print('gagal input');
        _showError();
      }
    }

//    print(bulk.toMap());
  }

  Future<void> _showError() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Pastikan Format Benar"),
          content: new Text("Nopol,Jenis Kendaraan"),
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

  Future<void> _showSuccess() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sukses"),
          content: new Text("Data Berhasil Disimpan !"),
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

  Future _getDate() async {
    DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2016),
        lastDate: DateTime(2024));

    if (_picked != null)
      setState(() {
        _display = formatDate(
            DateTime(_picked.year, _picked.month, _picked.day),
            [dd, '-', mm, '-', yyyy]);
        _date = _picked.toString();
      });
//    print();
  }

  Future _getPhone() async {
    Contact contact = await _contactPicker.selectContact();
    setState(() {
      _phoneController.text = contact.phoneNumber.number.toString();
      _nameController.text = contact.fullName.toString();
    });
//    print();
  }

  @override
  void initState() {
    _dataController.addListener(_setData);
    _nameController.addListener(_setName);
    _phoneController.addListener(_setPhone);
    _date = DateTime.now().toString();
    _display = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    if (widget.platno != '') {
      _dataController.text = widget.platno + ',Merk';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    getIt.get<SqlManager>().selectCase.execute(profile);
    RegExp regExp = new RegExp(r'\d+');
    print(regExp.allMatches('B123FA').first[0]);

    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: MainButton(
              icon: STIcon.arrowLeft,
              onPressed: (context) => Navigator.pop(context)),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 73,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        MainButton(
                          icon: Icon(Icons.delete_outline),
                        ),
                        new Text('Hapus Spasi'),
                      ],
                    ),
                    onTap: () => _removeSpace(),
                  ),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        MainButton(
                          icon: Icon(Icons.save),
                        ),
                        new Text('Simpan'),
                      ],
                    ),
                    onTap: () => _setSave(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Text('Tipe : '),
                    Radio(
                      groupValue: _currValue,
                      onChanged: (int i) => setState(() => _currValue = i),
                      value: 0,
                    ),
                    new Text('SK'),
                    Radio(
                      groupValue: _currValue,
                      onChanged: (int i) => setState(() => _currValue = i),
                      value: 1,
                    ),
                    new Text('Kiriman'),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, bottom: 5.0, right: 10.0),
                child: TextFormField(
                  controller: _nameController,
                  style: Style.body1.copyWith(color: Style.darkindigo),
                  decoration: InputDecoration(
                      labelText: 'Nama',
                      labelStyle: Style.body1.copyWith(color: Style.cloudyblue),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Style.cloudyblue,
                      )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Style.lightred, width: 2.0))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, bottom: 5.0, right: 10.0),
                child: TextFormField(
                  controller: _phoneController,
                  style: Style.body1.copyWith(color: Style.darkindigo),
                  decoration: InputDecoration(
                      labelText: 'No Telp',
                      labelStyle: Style.body1.copyWith(color: Style.cloudyblue),
                      suffixIcon: MainButton(
                        icon: Icon(Icons.contacts),
                        onPressed: (context) {
                          _getPhone();
                        },
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Style.cloudyblue,
                      )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Style.lightred, width: 2.0))),
                ),
              ),
/*                  Padding(
                  padding: EdgeInsets.only(top:5.0, left: 10.0, right: 10.0),
                  child: TextFormField(
                    controller: _dateController,
                    style: Style.body1.copyWith(color: Style.darkindigo),
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      labelStyle: Style.body1.copyWith(color: Style.cloudyblue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Style.cloudyblue,
                        )
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Style.lightred,
                          width: 2.0
                        )
                      )
                    ),
                  ),
                ),*/
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, bottom: 1.0, right: 10.0),
                child: TextButton(
                    text: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Tanggal ' + (_display != null ? ': $_display' : ''),
                          style: Style.body1.copyWith(color: Style.cloudyblue),
                        )),
                    onPressed: (context) => _getDate()),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, bottom: 5.0, right: 10.0),
                child: TextFormField(
                  controller: _dataController,
                  style: Style.body1.copyWith(color: Style.darkindigo),
                  maxLines: 10,
                  decoration: InputDecoration(
                      hintText: 'Nopol,Merk Mobil\nNopol,Merk Mobil',
                      labelText: 'Data',
                      labelStyle: Style.body1.copyWith(color: Style.cloudyblue),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Style.cloudyblue,
                      )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Style.lightred, width: 2.0))),
                ),
              ),
              StreamBuilder<List<dynamic>>(
                  stream: getIt.get<BlkManager>().insertBulks,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      myCallback(() {
                        Navigator.pop(context, true);
                        _showSuccess();
                      });
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, left: 50.0, right: 50.0, bottom: 10.0),
                    );
                  }),
            ],
          ),
        ),
      ],
    ));
  }

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
