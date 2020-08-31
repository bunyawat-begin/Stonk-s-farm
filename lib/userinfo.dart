import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stonkfarm/database.dart';
import 'package:stonkfarm/home.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Userinfo extends StatefulWidget {
  String data;
  Userinfo(this.data, {Key key}) : super(key: key);
  @override
  _UserinfoState createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  //Explicit
  String loginPerson = '...';
  TextEditingController email = TextEditingController();
  String userMail;
  Widget data() {
    return Text(widget.data);
  }

  //Methods
  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<void> findUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      loginPerson = firebaseUser.displayName;
    });
    print('login = $loginPerson');
  }

  Widget signoutButton() {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        tooltip: 'Sign out',
        onPressed: () {
          alertFun();
        });
  }

  void alertFun() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('R U Sure $loginPerson ?'),
            content: Text('Do U wanna Sign out ?'),
            actions: <Widget>[
              cancelButton(),
              okButton(),
            ],
          );
        });
  }

  Widget cancelButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'));
  }

  Widget okButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          forSignout();
        },
        child: Text('OK'));
  }

  Future<void> forSignout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((res) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  Widget showSideBar() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          header(),
          showMenu(),
          showInfo(),
          SizedBox(
            height: 200,
          ),
          signOutMenu(),
        ],
      ),
    );
  }

  Widget header() {
    return DrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Header.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            showIconApp(),
            showAppName(),
            SizedBox(
              height: 6.0,
            ),
            showLoginStatus(),
          ],
        ));
  }

  Widget showIconApp() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      "Stonk's farm",
      style: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  Widget showLoginStatus() {
    return Text(
      'Log in By $loginPerson',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  Widget showMenu() {
    return ListTile(
      leading: Icon(
        Icons.settings,
      ),
      title: Text('Setting'),
      subtitle: Text('This is SETTING'),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget showInfo() {
    return ListTile(
      leading: Icon(
        Icons.info,
      ),
      title: Text('Show Info'),
      subtitle: Text('This is INFO'),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget signOutMenu() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
      ),
      title: Text('Show Info'),
      subtitle: Text('This is INFO'),
      onTap: () {
        Navigator.of(context).pop();
        alertFun();
      },
    );
  }

  Widget buttonPage() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue.shade500)),
        color: Colors.blue.shade500,
        child: Text(
          'พร้อมแล้ว ไปกันเลย!!',
          style: TextStyle(fontFamily: 'Sriracha', color: Colors.white),
        ),
        onPressed: () {
          userMail = email.text;
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => Database(widget.data),
          );
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget textWelcome() {
    return Center(
      child: Text(
        "Welcome to my application",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontFamily: 'Ubuntu', fontSize: 23.0),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 250.0,
      height: 250.0,
      child: Image.asset('images/stonk.png'),
    );
  }

  Widget textLink() {
    return InkWell(
      child: Center(
          child: Text(
        "คลิกเพื่อลดต้นทุนปุ๋ยที่นี่ !!!",
        style: TextStyle(
            fontFamily: 'Sriracha', fontSize: 15.0, color: Colors.red.shade500),
      )),
      onTap: () => launch('https://stark-savannah-41843.herokuapp.com/'),
    );
  }

  Widget textExplain() {
    return Center(
        child: Text(
      "ในการกรอกวันที่ : สามารถกรอกในรูปแบบ ปี.เลขเดือนได้นะครับ เช่น เดือนมกราคม 2564 คือ 2564.01",
      style: TextStyle(fontFamily: 'Sriracha',fontSize: 15.0,color: Colors.deepPurple[700]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stonk's Farm Welcome",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade300,
        actions: <Widget>[
          signoutButton(),
        ],
      ),
      body: SafeArea(
          child: Container(
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(50.0),
            children: <Widget>[
              textWelcome(),
              SizedBox(
                height: 30,
              ),
              textExplain(),
              buttonPage(),
              showLogo(),
              SizedBox(height: 8.0),
              textLink(),
            ],
          ),
        ),
      )),
      //drawer: showSideBar(),
    );
  }
}
