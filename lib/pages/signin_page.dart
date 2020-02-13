import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'package:flutter_mata_elang/style/style.dart';
import 'package:flutter_mata_elang/style/icon.dart';
import 'package:flutter_mata_elang/widgets/buttons/main_button.dart';
import 'package:flutter_mata_elang/widgets/buttons/text_button.dart';
import 'package:flutter_mata_elang/widgets/buttons/primary_button.dart';
import 'package:flutter_mata_elang/pages/signup_page.dart';
import 'package:flutter_mata_elang/pages/search_page.dart';
import 'package:flutter_mata_elang/managers/auth_manager.dart';
import 'package:flutter_mata_elang/model/user.dart';
import 'package:flutter_mata_elang/services/service_locator.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _hide;
  String _email;
  String _password;
  int _code;
  bool _open = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  _setEmail() => _email = _emailController.text;
  _setPassword() => _password = _passwordController.text;

  _setSubmit() {
    _open = true;
    User _user = User(email: _email, password: _password);
    getIt.get<AuthManager>().signin.execute(_user);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _hide = true;
    _emailController.addListener(_setEmail);
    _passwordController.addListener(_setPassword);

    super.initState();
  }

  Future<void> _showDialog(String val) async {
    _open = false;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR!',
                style: Style.subTitle1.copyWith(color: Style.darkindigo)),
            content:
                Text(val, style: Style.subTitle1.copyWith(color: Style.oldred)),
            actions: <Widget>[
              TextButton(
                  text: Text('tutup',
                      style: Style.button.copyWith(color: Style.oldred)),
                  onPressed: (context) {
                    Navigator.of(context).pop();
                    _code = 0;
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.verybluelight,
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFf44336), Color(0xFFd32f2f)],
                ),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Text(""),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32, right: 32),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 14.0, top: 35.0),
                  child: TextFormField(
                    controller: _emailController,
                    style: Style.body1.copyWith(color: Style.darkindigo),
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            Style.body1.copyWith(color: Style.cloudyblue),
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
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: _passwordController,
                    style: Style.body1.copyWith(color: Style.darkindigo),
                    obscureText: _hide,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            Style.body1.copyWith(color: Style.cloudyblue),
                        suffixIcon: MainButton(
                            icon: _hide ? STIcon.eye : STIcon.redeye,
                            onPressed: (context) {
                              setState(() => _hide = !_hide);
                            }),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Style.cloudyblue,
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Style.lightred, width: 2.0))),
                  ),
                ),
                PrimaryButton(
                    label: 'Login', onPressed: (context) => _setSubmit()
//                  onPressed: (context) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()))
                    ),
                StreamBuilder<http.Response>(
                    stream: getIt.get<AuthManager>().signin,
                    builder: (BuildContext context,
                        AsyncSnapshot<http.Response> snapshot) {
                      if (snapshot.hasData) {
                        _code = snapshot.data.statusCode;
                        if (_code == 404 && _open == true) {
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _showDialog(snapshot.data.body));
                        } else if (_code == 200) {
//                        print('hasil: ' + snapshot.data.body);
//                        getIt.get<AuthManager>().signinLog.execute(snapshot.data.body);
                          WidgetsBinding.instance.addPostFrameCallback((_) =>
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SearchPage())));
                        }
//                      print(snapshot.data.statusCode);
                      }
                      return StreamBuilder<bool>(
                          stream: getIt.get<AuthManager>().signinLog,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            return Container();
                          });
                    }),
                Container(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Belum punya akun ? ',
                            style: Style.subTitle1
                                .copyWith(color: Style.slategrey)),
                        
                      ]),
                ),
                TextButton(
                            text: Text('Registrasi',
                                style:
                                    Style.button.copyWith(color: Style.oldred)),
                            onPressed: (context) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignUpPage()))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _callback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
