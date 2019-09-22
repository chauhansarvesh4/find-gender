import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'gender_res.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GENDER FINDER',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.black,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _height;
  double _width;

  bool _isM, _isL, _isS;

  TextEditingController _nameEditController;

  bool _isFind;
  GenderRes _genderRes;

  @override
  void initState() {
    _isL = false;
    _isM = false;
    _isS = false;
    _nameEditController = TextEditingController();

    _isFind = false;
    _genderRes = GenderRes(name: "", gender: "", probability: 0.0, count: 0);

    super.initState();
  }

  void showGender(BuildContext context, GenderRes genderRes) {
  
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${genderRes.gender}",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Probability ${genderRes.probability}",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _nameEditController.text = "";
                    },
                    color: Colors.green,
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void fetchGenderRes(String name, BuildContext context) async {
    final response = await http.get('https://api.genderize.io?name=$name');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print(GenderRes.fromJson(json.decode(response.body)).toString());
      setState(() {
        _isFind = false;
        _genderRes = GenderRes.fromJson(json.decode(response.body));
        print(_genderRes.toString());
      });

      showGender(context, _genderRes);
    } else {
      // If that response was not OK, throw an error.
      setState(() {
        _isFind = false;
        _genderRes =
            GenderRes(name: "", gender: "Error", probability: 0.0, count: 0);
      });

      showGender(context, _genderRes);
      //throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    print("height $_height"); //916
    print("width $_width"); //1920

    if (_width < 960 && _height < 458) {
      _isS = true;
      _isL = false;
      _isM = false;
    }

    if ((_width > 960 && _width < 1920) && (_height > 458 && _height < 916)) {
      _isS = false;
      _isL = true;
      _isM = _isM;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("GENDER FINDER"),
        centerTitle: true,
        leading: Icon(Icons.face),
      ),
      body: Container(
        child: Center(
          child: Container(
              width: _width / 2,
              height: _height * 70 / 100,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color(0xffffcdd2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "PLEASE ENTER YOUR NAME",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: _isL ? 40 : (_isS ? 20 : 30),
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.red,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: _nameEditController,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: _isL ? 36 : (_isS ? 18 : 26),
                              fontWeight: FontWeight.bold),
                          decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            hintText: 'Name',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          onPressed: () {
                            setState(() {
                              _isFind = true;
                            });
                            String name =
                                _nameEditController.text.toString().trim();
                            
                            fetchGenderRes(name, context);
                          },
                          color: Colors.red,
                          splashColor: Colors.redAccent,
                          child: Text("FIND GENDER",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 26)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //CircularProgressIndicator()
                        _isFind ? CircularProgressIndicator() : SizedBox(width: 0,)
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              )),
        ),
      ),
    );
  }
}
