import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stonkfarm/userinfo.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Explicit
  final formkey = GlobalKey<FormState>();
  String email, password;

  //Methods
  Widget backButton() {
    return IconButton(
        icon: Icon(
          Icons.navigate_before,
          size: 36.0,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  Widget showAppName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showLogoApp(),
        SizedBox(
          width: 10.0,
        ),
        showText(),
      ],
    );
  }

  Widget showLogoApp() {
    return Container(
      width: 48.0,
      height: 48.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showText() {
    return Text(
      "Stonk's Farm",
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Ubuntu',
        color: Colors.blue.shade800,
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 300.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          icon: Icon(
            Icons.email,
            size: 30.0,
          ),
          hintText: 'E-Mail',
        ),
        onSaved: (String newValue) {
          email = newValue.trim();
        },
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 300.0,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          icon: Icon(
            Icons.lock_outline,
            size: 30.0,
          ),
          hintText: 'Password',
        ),
        onSaved: (String newValue) {
          password = newValue.trim();
        },
        autofocus: false,
        obscureText: true,
      ),
    );
  }

  Widget content() {
    return Center(
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 250,
            ),
            showAppName(),
            SizedBox(
              height: 10,
            ),
            emailText(),
            SizedBox(
              height: 8,
            ),
            passwordText(),
          ],
        ),
      ),
    );
  }

  Future<void> chekUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((res) {
      print('Success');
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Userinfo());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }).catchError((res) {
      String title = res.code;
      String message = res.message;
      alertMessage(title, message);
    });
  }

  void changeLanguage(String title, String message) {
    if (title == 'error') {
      title = 'ข้อผิดพลาด';
    }
    if (message == 'Given String is empty or null') {
      message = 'กรุณาใส่อีเมลล์และรหัสผ่าน';
    }
  }

  Widget showAlertTitle(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 40.0,
        color: Colors.red,
      ),
      title: Text(
        title, //0813970291
        style: TextStyle(
          color: Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget okButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('OK'));
  }

  void alertMessage(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: showAlertTitle(title),
            content: Text(message),
            actions: <Widget>[
              okButton(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              backButton(),
              content(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.navigate_next,
          size: 30.0,
        ),
        onPressed: () {
          formkey.currentState.save();
          print('email = $email, password = $password');
          print("it's work!!");
          chekUser();
        },
      ),
    );
  }
}
