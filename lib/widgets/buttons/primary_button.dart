import 'package:flutter/material.dart';

import 'package:flutter_mata_elang/style/style.dart';

class PrimaryButton extends StatelessWidget {

  final String label;
  final Function onPressed;
  final bool disabled;

  PrimaryButton({Key key, this.label, this.onPressed, this.disabled = false }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => disabled ? print('') :  onPressed(context),
      child: Container(
        alignment: Alignment.center,
        child: Text(label, style: Style.subTitle1,),
        height: 50.0,
        decoration: BoxDecoration(
          color: disabled ? Style.palered: Style.oldred,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50),
          gradient: new LinearGradient(
            colors: disabled ? [Style.lightred, Style.palered] : [Color(0xFFf44336), Color(0xFFd32f2f)],
            begin: Alignment.centerRight,
            end: new Alignment(-1.0, -1.0)
          ),
          
        ),
      ),
    );
  }
}
