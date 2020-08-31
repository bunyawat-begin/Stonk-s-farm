import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Result extends StatefulWidget {
  int data;
  String plant, user, unit;
  Result(this.data, this.plant, this.user, this.unit, {Key key})
      : super(key: key);
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String text;
  final databaseReference = FirebaseDatabase.instance.reference();
  String result(int val) {
    return val.toString();
  }

  void getData() {
    text = widget.data.toString();
    print('text = $text');
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget header() {
    return Center(
      child: Text(
        'WOW STONKS',
        style: TextStyle(fontSize: 35.0, fontFamily: 'Sriracha',color: Colors.purple[900]),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.asset('images/stonk.png'),
    );
  }

  Widget textOther() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
          "                  ถ้าหากผลลัพธ์เป็น 0 \nกรุณากลับหน้าแรกและกรอกข้อมูลใหม่นะครับ",
          style: TextStyle(fontFamily: 'Sriracha')),
    ));
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('ว้าว สุดยอดไปเลย',style: TextStyle(fontFamily: 'Sriracha'),),
        backgroundColor: Colors.blue.shade300,
      ),
      body: SafeArea(
          child: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: ListView(
              children: <Widget>[
                header(),
                SizedBox(
                  height: 15,
                ),
                showLogo(),
                SizedBox(
                  height: 15,
                ),
                outputNumber(),
                textOther(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget outputNumber() {
    String output = result(widget.data);
    String unit = widget.unit.toString();
    return Center(
      child: Text(
        'ผลลัพธ์คือ $output $unit',
        style: TextStyle(fontSize: 20.0, fontFamily: 'Sriracha'),
      ),
    );
  }
}
