import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stonkfarm/register.dart';
import 'package:stonkfarm/sigin.dart';
import 'package:stonkfarm/userinfo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //methods
  @override
  void initState() {
    super.initState();
    checkStatusLogin();
  }

  Future<void> checkStatusLogin() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser != null) {
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (BuildContext context) => Userinfo(),
      );
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  Widget showAppName() {
    return Text(
      "Welcome to Stonk's Farm",
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.blue.shade900,
        fontWeight: FontWeight.bold,
        fontFamily: 'Ubuntu',
      ),
    );
  }

  Widget showTitle() {
    return Text("Stonk's farm");
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buttonSignin(),
        SizedBox(
          width: 5.0,
        ),
        buttonSignup(),
      ],
    );
  }

  Widget buttonSignin() {
    return RaisedButton(
      color: Colors.blue.shade300,
      child: Text(
        'Sign in',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (BuildContext context) => SignIn(),
        );
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget buttonSignup() {
    return OutlineButton(
      child: Text('Sign up'),
      onPressed: () {
        print('Click sign up');

        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (BuildContext context) => Register(),
        );
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showLogo(),
              SizedBox(
                height: 8.0,
              ),
              showAppName(),
              showButton(),
            ],
          ),
        ),
      )),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        title: showTitle(),
      ),
    );
  }
}
