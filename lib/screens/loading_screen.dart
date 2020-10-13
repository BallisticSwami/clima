import 'package:clima/services/weather.dart';
import 'package:clima/utilities/sizeconfig.dart';
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
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return LocationScreen(
    //     locationWeather: weatherData,
    //   );
    // }));
  }
  
  void pushNextPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        locationWeather: weatherData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xff171029),
      body: Center(
        child: SizedBox(
          height: SizeConfig.safeBlockHorizontal*25,
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
