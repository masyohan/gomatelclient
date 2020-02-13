import 'package:flutter/material.dart';

import 'package:flutter_mata_elang/style/style.dart';
import 'package:flutter_mata_elang/widgets/line_bar.dart';
import 'package:flutter_mata_elang/model/profile.dart';
import 'package:date_format/date_format.dart';

class SearchList extends StatelessWidget {
  final Function onPressed;
  final Profile profile;
  RegExp regExp = new RegExp(r'\d+');
  SearchList({Key key, this.profile, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String angka = regExp.allMatches(profile.plate).first[0];
    String depan = profile.plate.toString().split(angka)[0];
    String belakang = profile.plate.toString().split(angka)[1];
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
              child: Row(
                
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Row(
                  children: <Widget>[
                    Text('${depan}',
                      style: Style.subTitle1
                          .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text('${angka}',
                      style: Style.subTitle1
                          .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text('${belakang}',
                      style: Style.subTitle1
                          .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        profile.vehicle.trim(),
                        style: Style.caption.copyWith(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      child: Text(
                        '${profile.finance.trim()} ${profile.phone.trim()} ${profile.number.isNotEmpty ?'['+profile.number.trim()+']' : ''} ${profile.ovd.isNotEmpty ?profile.ovd.trim():''} ${profile.saldo.isNotEmpty ? 'Rp'+profile.saldo.substring(0,3) : ''} ${(profile.date.split(' ')[0].split('-').reversed.join('-'))}',
                        style: Style.body2
                            .copyWith(color: Style.darkindigo),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        onTap: () => onPressed(context)
      ),
    );
    /*
    return ListTile(
        onTap: () => onPressed(context),
        leading: Text(profile.plate, style:Style.subTitle1.copyWith(color: Style.oldred)),
        title: Text('${profile.finance} ${profile.phone} ${profile.number} ${profile.saldo}', style:Style.body2.copyWith(color: Style.darkindigo)),
        subtitle: Text(profile.vehicle, style:Style.caption.copyWith(color: Style.oldred)),
/*        Row(
          children: <Widget> [
            Text('${profile.name.length > 20 ? profile.name.substring(0, 20) : profile.name}...', style:Style.body2.copyWith(color: Style.oldred)),
          ]
        ),*/
/*        subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text('${profile.finance}, ${profile.address}', style:Style.body2.copyWith(color: Style.darkindigo)),
          LineBar(
            width: MediaQuery.of(context).size.width - 40.0,
            color: Style.cloudyblue
          )
        ]
        ),*/
    ); */
  }
}
