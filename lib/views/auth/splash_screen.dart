import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_quotes/controllers/authcontroller.dart';
import 'package:user_quotes/views/auth/name_screen.dart';
import 'package:user_quotes/views/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getdatafromSF() async {
    print('Inside getdatafromSF');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('uid');
    print('UID from SharedPreferences: $value');

    if (value != null) {
      StaticData.uid = value;
      print('UID is not null. Navigating to HomeScreen');
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(

          ),
        ),
      );
    } else {
      print('UID is null. Navigating to ScreenThree');
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (BuildContext context) => NameScreen(),
        ),
      );
    }
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = prefs.getBool('seen') ?? false;

    if (_seen) {
      // User has seen the app before, navigate to SplashScreen or HomeScreen based on your logic
      getdatafromSF();
    } else {
      // First-time user, set seen to true and navigate to SplashScreen
      await prefs.setBool('seen', true);
      // Add a delay of 3 seconds before navigating to the next screen
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => NameScreen()),
        );
      });
    }
  }

  @override
  void initState() {
    checkFirstSeen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
            height: height * 0.2,
            width: width * 0.4,
            child: Text(
              'User Quotes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),)),
      ),
    );
  }
}
