import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stonkfarm/result.dart';

// ignore: must_be_immutable
class Database extends StatefulWidget {
  String data;
  Database(this.data, {Key key}) : super(key: key);
  @override
  _DatabaseState createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String input, type;
  final formKey = GlobalKey<FormState>();
  int result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'กรอกข้อมูลกันเล้ย!!!',
          style: TextStyle(fontFamily: 'Sriracha'),
        ),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
              key: formKey,
              child: Container(
                child: Center(
                  child: ListView(
                    children: [
                      textHeader(),
                      SizedBox(
                        height: 15.0,
                      ),
                      textInput(),
                      typeInput(),
                      submitBtn(),
                      SizedBox(
                        height: 20.0,
                      ),
                      texthelp(),
                      SizedBox(
                        height: 15.0,
                      ),
                      showLogo(),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget typeInput() {
    return TextFormField(
      style: TextStyle(color: Colors.blue[600]),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(
          Icons.label_important,
          size: 40.0,
        ),
        helperText: 'ยาง,ปาล์ม,ข้าว,มัน,ข้าวโพด นะครับ',
        helperStyle: TextStyle(color: Colors.blue[300], fontFamily: 'Sriracha'),
        hintText: 'ระบุชนิดพืช',
        hintStyle: TextStyle(
          fontFamily: 'Sriracha',
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Plz enter';
        } else {
          return null;
        }
      },
      onSaved: (String val) {
        type = val.trim();
      },
    );
  }

  String unit(String val) {
    if (val != 'ข้าว') {
      return 'บาท/กิโลกรัม';
    } else {
      return 'บาท/ตัน';
    }
  }

  Widget textHeader() {
    return Center(
      child: Text(
        "มา Stonk กันเถอะ!!!!",
        style: TextStyle(
            fontFamily: 'Sriracha', fontSize: 30.0, color: Colors.blue[800]),
      ),
    );
  }

  Widget textInput() {
    return TextFormField(
      style: TextStyle(color: Colors.blue[600]),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(
          Icons.label_important,
          size: 40.0,
        ),
        helperText: 'ระบุวันที่ เช่น 2563.12 คือ ธันวาคม 2563',
        helperStyle: TextStyle(color: Colors.blue[300], fontFamily: 'Sriracha'),
        hintText: 'ระบุวันที่',
        hintStyle: TextStyle(
          fontFamily: 'Sriracha',
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Plz enter';
        } else {
          return null;
        }
      },
      onSaved: (String val) {
        input = val.trim();
      },
    );
  }

  Widget submitBtn() {
    return Container(
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue.shade300)),
                color: Colors.blue.shade300,
                child: Text(
                  'Stonk!!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sriracha',
                  ),
                ),
                onPressed: () {
                  formKey.currentState.save();
                  print('submit!!! $input');
                  double val = double.tryParse(input);
                  createRecord(val);
                  getData();
                  print(text(widget.data));
                  MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (BuildContext context) => Result(
                          result, type, text(widget.data), unit(this.type)));
                  Future.delayed(Duration(seconds: 10), () {
                    Navigator.of(context).push(materialPageRoute);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget texthelp() {
    return Center(
      child: Text(
        "การส่งข้อมูลอาจจะใช้เวลาสักครู่โปรดรอนะจ้ะ",
        style: TextStyle(fontFamily: 'Sriracha'),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.asset('images/dio.jpg'),
    );
  }

  String text(String text) {
    String word = text;
    word = word.substring(0, word.indexOf('.'));
    return word;
  }

  void createRecord(double val) {
    String path = text(widget.data);
    databaseReference
        .child('Input/$path')
        .set({'input': val, 'name': widget.data, 'result': 0, 'type': type});
    databaseReference
        .child('Output/$path')
        .set({'input': val, 'name': widget.data, 'result': 0, 'type': type});
  }

  void getData() {
    Future.delayed(Duration(seconds: 5), () {
      databaseReference.once().then((DataSnapshot snapshot) {
        print(
            'result : ${snapshot.value['Output'][text(widget.data)]['result']}');
        result = snapshot.value['Output'][text(widget.data)]['result'];
      });
    });
  }
}
