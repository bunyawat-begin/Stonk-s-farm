import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stonkfarm/userinfo.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //forsifnVariable
  final formKey = GlobalKey<FormState>();
  String password, check, userName, email;

  String forcheck(String passsword, String check) {
    this.password = passsword;
    this.check = check;
    if (passsword == check) {
      return null;
    } else {
      return 'Incorrect password please try again';
    }
  }

  void alertMessage(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                size: 40.0,
                color: Colors.red.shade800,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  Future<void> setUpdisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.currentUser().then((res) {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = userName;
      res.updateProfile(userUpdateInfo);

      //routeToUserinfo
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (BuildContext context) => Userinfo(),
      );
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.language),
      onPressed: () {
        print("click button");
      },
    );
  }

  Widget nameText() {
    return TextFormField(
      style: TextStyle(color: Colors.blue[600]),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(
          Icons.face,
          size: 40.0,
        ),
        helperText: '',
        helperStyle: TextStyle(
          color: Colors.blue[300],
          fontStyle: FontStyle.italic,
        ),
        hintText: 'User name',
        hintStyle: TextStyle(),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Plz enter this';
        } else {
          return null;
        }
      },
      onSaved: (String val) {
        userName = val.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(
          Icons.email,
          size: 40.0,
        ),
        helperText: '',
        helperStyle: TextStyle(
          color: Colors.blue[300],
          fontStyle: FontStyle.italic,
        ),
        hintText: 'E-mail',
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Plz enter email for ex. game@abc.com';
        } else {
          return null;
        }
      },
      onSaved: (String val) {
        email = val.trim();
      },
    );
  }

  Widget passwordlText() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(
          Icons.lock,
          size: 40.0,
        ),
        helperText: '',
        helperStyle: TextStyle(
          color: Colors.blue[300],
          fontStyle: FontStyle.italic,
        ),
        hintText: 'Password',
      ),
      autofocus: false,
      obscureText: true,
      validator: (password) {
        if (password.length < 6) {
          return 'Plz type it more 6 character';
        } else {
          this.password = password;
          return null;
        }
      },
      onSaved: (String val) {
        password = val.trim();
      },
    );
  }

  Widget confirmPasswordlText() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(
          Icons.lock,
          size: 40.0,
        ),
        helperText: '',
        helperStyle: TextStyle(
          color: Colors.blue[300],
          fontStyle: FontStyle.italic,
        ),
        hintText: 'Confirm password',
      ),
      autofocus: false,
      obscureText: true,
      validator: (check) {
        return forcheck(password, check);
      },
      onSaved: (String val) {
        check = val.trim();
      },
    );
  }

  Widget submitBtn() {
    return Container(
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              color: Colors.blue.shade300,
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                print('submit!!!');
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  print(
                      'name = $userName, email = $email, password = $password, check = $check');
                  print('it is work!!!');
                  registerThread();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((res) {
      print('Success');
      setUpdisplayName();
    }).catchError((res) {
      String title = res.code;
      String message = res.message;
      print('title = $title, message = $message');
      alertMessage(title, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        title: Text('Register'),
        actions: <Widget>[
          registerButton(),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            nameText(),
            emailText(),
            passwordlText(),
            confirmPasswordlText(),
            SizedBox(
              height: 10.0,
            ),
            submitBtn(),
          ],
        ),
      ),
    );
  }
}
