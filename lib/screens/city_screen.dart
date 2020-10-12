import 'package:clima/services/suggestions.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/sizeconfig.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> with TickerProviderStateMixin {
  String cityNameInput;
  var _controller = TextEditingController();
  bool enableClear = false;
  final _formKey = GlobalKey<AutoCompleteTextFieldState<Cities>>();


  void _loadData() async {
    print('loading data');
    await CityModel.loadCities();
    print('data loaded');
  }

  _showDialog() async {
    return await showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 1500), () {
                          Navigator.of(context).pop(true);
                        });
           return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: SpinKitDoubleBounce(
              controller: AnimationController(
                  vsync: this, duration: Duration(milliseconds: 1000)),
              duration: Duration(seconds: 1),
              color: Colors.white60,
              size: 100,
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog());
    _loadData();
  }

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
  Widget build(BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.35), BlendMode.multiply),
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
                        color: Colors.white,
                        size: SizeConfig.safeBlockHorizontal * 11,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 5),
                child: AutoCompleteTextField<Cities>(
                    suggestionsAmount: 4,
                    controller: _controller,
                    style: TextStyle(color: Colors.black87),
                    decoration: kTextFieldInputDecoration(),
                    itemBuilder: (context, item) {
                      return Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.safeBlockHorizontal * 0.7),
                        child: ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            item.city,
                            style: TextStyle(color: Colors.black54),
                          ),
                          trailing: Text(item.country,
                              style: TextStyle(
                                  color: Colors.black12,
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                    itemSorter: (a, b) {
                      return a.city.compareTo(b.city);
                    },
                    itemSubmitted: (item) {
                      setState(() {
                        _controller.text = item.city;
                      });
                    },
                    key: _formKey,
                    suggestions: CityModel.cities,
                    itemFilter: (item, query) {
                      return item.city
                          .toLowerCase()
                          .startsWith(query.toLowerCase());
                    },
                    clearOnSubmit: false,
                    onFocusChanged: (value) {
                      setState(() {
                        cityNameInput = _controller.text.toLowerCase();
                        if (cityNameInput == '') {
                          enableClear = false;
                        } else {
                          enableClear = true;
                        }
                        print(enableClear);
                      });
                    },
                    textChanged: (value) {
                      setState(() {
                        cityNameInput = _controller.text.toLowerCase();
                        if (cityNameInput == '') {
                          enableClear = false;
                        } else {
                          enableClear = true;
                        }
                        print(enableClear);
                      });
                    }),
              ),
              FlatButton(
                onPressed: () {
                  print(cityNameInput);
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
