import 'package:clima/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static double themeblockhz;
  static double themeblockvt;

  void initBlock(BuildContext context) {
    SizeConfig().init(context);
    themeblockhz = SizeConfig.safeBlockHorizontal;
    themeblockvt = SizeConfig.safeBlockVertical;
  }

  static TextStyle kTempTextStyle = TextStyle(
    fontFamily: 'Spartan MB',
    fontSize: 100.0,
  );

  static TextStyle kMessageTextStyle = TextStyle(
    fontFamily: 'Spartan MB',
    fontSize: 60.0,
  );

  static TextStyle kButtonTextStyle = TextStyle(
    fontSize: 30.0,
    fontFamily: 'Spartan MB',
  );

  static TextStyle kConditionTextStyle = TextStyle(
    fontSize: 100.0,
  );
}
