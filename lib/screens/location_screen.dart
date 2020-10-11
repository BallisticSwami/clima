import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/sizeconfig.dart';
import 'city_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with TickerProviderStateMixin {
  WeatherModel weatherModel = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  String countryName;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    if (weatherData == null) {
      temperature = 0;
      weatherIcon = 'Error';
      weatherMessage = 'Unable to get weather data';
      cityName = 'city';
      countryName = 'country';
      return;
    }
    temperature = weatherData['main']['temp'].toInt();
    var condition = weatherData['weather'][0]['id'];
    weatherIcon = weatherModel.getWeatherIcon(condition);

    cityName = weatherData['name'];
    weatherMessage = weatherModel.getMessage(temperature);
    countryName = weatherData['sys']['country'];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MyTheme().initBlock(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            'Press Back again to Exit',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.safeBlockHorizontal*4),
          ),
          backgroundColor: Colors.black38,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/location_background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Tooltip(
                        message: 'Reset Location',
                        textStyle: TextStyle(color: Colors.white),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(30)),
                        child: FlatButton(
                          shape: StadiumBorder(),
                          splashColor: Colors.white10,
                          highlightColor: Colors.white10,
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: SpinKitDoubleBounce(
                                      controller: AnimationController(
                                          vsync: this,
                                          duration:
                                              Duration(milliseconds: 1000)),
                                      duration: Duration(seconds: 10),
                                      color: Colors.white60,
                                      size: 100,
                                    ),
                                  );
                                });
                            var weatherData =
                                await weatherModel.getLocationWeather();
                            updateUI(weatherData);
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.near_me,
                            size: SizeConfig.safeBlockHorizontal * 11,
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Choose Location',
                        textStyle: TextStyle(color: Colors.white),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(30)),
                        child: FlatButton(
                          shape: StadiumBorder(),
                          splashColor: Colors.white10,
                          highlightColor: Colors.white10,
                          onPressed: () async {
                            var typedName = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CityScreen();
                                },
                              ),
                            );
                            if (typedName != null) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: SpinKitDoubleBounce(
                                        controller: AnimationController(
                                            vsync: this,
                                            duration:
                                                Duration(milliseconds: 1000)),
                                        duration: Duration(seconds: 10),
                                        color: Colors.white60,
                                        size: 100,
                                      ),
                                    );
                                  });
                              var weatherData =
                                  await weatherModel.getCityWeather(typedName);
                              setState(() {
                                updateUI(weatherData);
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Icon(
                            Icons.location_city,
                            size: SizeConfig.safeBlockHorizontal * 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$temperature°',
                        style: MyTheme.kTempTextStyle,
                      ),
                      Text(
                        weatherIcon,
                        style: MyTheme.kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: SizeConfig.safeBlockHorizontal * 4),
                  child: Text(
                    '$weatherMessage in $cityName, $countryName',
                    textAlign: TextAlign.right,
                    style: MyTheme.kMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
