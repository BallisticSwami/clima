import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/sizeconfig.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String cityNameInput;
  var _controller = TextEditingController();
  bool enableClear = false;

  InputDecoration kTextFieldInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      icon: Icon(
        Icons.location_city,
        color: Colors.white,
      ),
      hintText: 'Enter City Name',
      hintStyle: TextStyle(color: Colors.black12),
      suffixIcon: Visibility(
        visible: enableClear,
        child: IconButton(
            icon: Icon(Icons.clear_rounded, color: Colors.black87),
            onPressed: () {
              setState(() {
                _controller.clear();
                enableClear = false;
              });
            }),
      ),
      border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(SizeConfig.safeBlockHorizontal * 2.4),
          borderSide: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: SizeConfig.safeBlockVertical * 2,
              ),
              Container(
                margin:
                    EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Tooltip(
                    message: 'Go Back',
                    textStyle: TextStyle(color: Colors.white),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(30)),
                    child: FlatButton(
                      shape: StadiumBorder(),
                      splashColor: Colors.white10,
                      highlightColor: Colors.white10,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: SizeConfig.safeBlockHorizontal * 11,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 5),
                child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.black87),
                    decoration: kTextFieldInputDecoration(),
                    onChanged: (value) {
                      setState(() {
                        cityNameInput = value;
                        if(cityNameInput == '') {
                          enableClear = false;
                        }
                        else{
                          enableClear = true;
                        }
                      });
                    }),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, cityNameInput);
                },
                child: Text(
                  'Get Weather',
                  style: MyTheme.kButtonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
