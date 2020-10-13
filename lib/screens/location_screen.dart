import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/sizeconfig.dart';
import 'city_screen.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flare_loading/flare_loading.dart';

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
  String bgImage;

  bool isLoaded = false;

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
      bgImage = 'default';
      return;
    }
    temperature = weatherData['main']['temp'].toInt();
    var condition = weatherData['weather'][0]['id'];
    bgImage = weatherModel.getWeatherBackground(condition);
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
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.safeBlockHorizontal * 4),
          ),
          backgroundColor: Colors.black45,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/weather_images/$bgImage.jpg'),
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
                            isLoaded = false;
                            showDialog(
                                barrierDismissible: false,
                                barrierColor: MyTheme.bgColor,
                                context: context,
                                builder: (context) {
                                  return WillPopScope(
                                    onWillPop: () async {
                                      return false;
                                    },
                                    child: AlertDialog(
                                      backgroundColor: MyTheme.bgColor,
                                      elevation: 0,
                                      content: SizedBox(
                                        height:
                                            SizeConfig.safeBlockHorizontal * 25,
                                        child: FlareLoading(
                                          name: 'assets/weather_loading_opt.flr',
                                          isLoading: isLoaded,
                                          onSuccess: (test) {
                                            Navigator.pop(context);
                                          },
                                          onError: null,
                                          startAnimation: 'Sun Rotate',
                                          loopAnimation: 'Sun Rotate',
                                          endAnimation: 'End Anim',
                                        ),
                                      ),
                                    ),
                                  );
                                });
                            var weatherData =
                                await weatherModel.getLocationWeather();
                            updateUI(weatherData);
                            setState(() {});
                            isLoaded = true;
                          },
                          child: Icon(
                            Icons.near_me,
                            color: Colors.white,
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
                              isLoaded = false;
                              showDialog(
                                  barrierColor: MyTheme.bgColor,
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return WillPopScope(
                                      onWillPop: () async {
                                      return false;
                                    },
                                      child: AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        content: SizedBox(
                                          height:
                                              SizeConfig.safeBlockHorizontal *
                                                  25,
                                          child: FlareLoading(
                                            name: 'assets/weather_loading_opt.flr',
                                            isLoading: isLoaded,
                                            onSuccess: (test) {
                                              Navigator.pop(context);
                                            },
                                            onError: null,
                                            startAnimation: 'Sun Rotate',
                                            loopAnimation: 'Sun Rotate',
                                            endAnimation: 'End Anim',
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                              var weatherData =
                                  await weatherModel.getCityWeather(typedName);
                              setState(() {
                                updateUI(weatherData);
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              isLoaded = true;
                            }
                          },
                          child: Icon(
                            Icons.location_city,
                            color: Colors.white,
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
                      Image(
                        image: AssetImage(
                            'images/weather_icons_octarine/$bgImage.png'),
                        height: SizeConfig.safeBlockHorizontal * 24,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: SizeConfig.safeBlockHorizontal * 4,
                      bottom: SizeConfig.safeBlockVertical * 3),
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
