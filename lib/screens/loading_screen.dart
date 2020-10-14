import 'package:Clima/services/weather.dart';
import 'package:Clima/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'location_screen.dart';
import 'package:flare_loading/flare_loading.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  var weatherData;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    weatherData = await WeatherModel().getLocationWeather();
    isLoaded = true;
  }

  void pushNextPage() async {
    var page = await buildPageAsync();
    var route = MaterialPageRoute(builder: (context) => page);
    Navigator.pushReplacement(context, route);
  }

  Future<Widget> buildPageAsync() async {
    return Future.microtask(() {
      return LocationScreen(
        locationWeather: weatherData,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xff171029),
      body: Center(
        child: SizedBox(
          height: SizeConfig.safeBlockHorizontal * 25,
          child: FlareLoading(
            name: 'assets/weather_loading_opt.flr',
            isLoading: isLoaded,
            onSuccess: (test) {
              pushNextPage();
            },
            onError: null,
            startAnimation: 'Sun Rotate',
            loopAnimation: 'Sun Rotate',
            endAnimation: 'End Anim',
          ),
        ),
      ),
    );
  }
}
