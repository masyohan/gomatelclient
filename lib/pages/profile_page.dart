import 'package:flutter/material.dart';

import 'package:flutter_mata_elang/style/style.dart';
import 'package:flutter_mata_elang/style/icon.dart';
import 'package:flutter_mata_elang/widgets/buttons/main_button.dart';
import 'package:flutter_mata_elang/widgets/buttons/primary_button.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool _hide;
//  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _hide = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      key: scaffoldKey,
/*      drawer: Drawer(
        child: MenuDrawer()
      ),*/
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 25.0, right: 8.0),
            width: MediaQuery.of(context).size.width - 58.0,
            height: 48.0,
            child: MainButton(
              icon: STIcon.arrowLeft,
              onPressed: (context) => Navigator.pop(context)
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom:14.0),
                  child: TextFormField(
                    style: Style.body1.copyWith(color: Style.darkindigo),
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:14.0),
                  child: TextFormField(
                    style: Style.body1.copyWith(color: Style.darkindigo),
                    obscureText: _hide,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: Style.body1.copyWith(color: Style.cloudyblue),
                      suffixIcon: MainButton(icon: _hide ? STIcon.eye : STIcon.redeye, onPressed: (context) {
                        setState(() => _hide = !_hide);
                      }),
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:14.0),
                  child: TextFormField(
                    style: Style.body1.copyWith(color: Style.darkindigo),
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:14.0),
                  child: TextFormField(
                    style: Style.body1.copyWith(color: Style.darkindigo),
                    decoration: InputDecoration(
                      labelText: 'Nomor HP',
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:14.0),
                  child: TextFormField(
                    style: Style.body1.copyWith(color: Style.darkindigo),
                    decoration: InputDecoration(
                      labelText: 'Kota',
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
                ),
                PrimaryButton(
                  label: 'Simpan', 
                  onPressed: (context) => print('simpan')
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
