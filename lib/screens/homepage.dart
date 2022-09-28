import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../domain/user_models.dart';
import '../utils/shared_preference.dart';

String stringResponse = "";
Map mapResponse = {};
Map dataResponse = {};
List listResponse = [];

class HomePage extends StatefulWidget {
  //Accepts the data
  String apiToken ;
  String email ;
  String refreshToken;
  String tokenType ;

  HomePage({
    Key? key,
    required this.apiToken,
    required this.email,
    required this.refreshToken,
    required this.tokenType,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(
        apiToken: apiToken,
        email: email,
        refreshToken: refreshToken,
        tokenType: tokenType,
      
  );
}

class _HomePageState extends State<HomePage> {
  String apiToken ;
  String email ;
  String refreshToken ;
  String tokenType ;
  _HomePageState({
    required this.apiToken,
    required this.email,
    required this.refreshToken,
    required this.tokenType,
  });
  

  // Future apiCall() async {
  //   http.Response response;
  //   response = await http.get(Uri.parse("https://reqres.in/api/users/2"));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       // stringResponse = response.body;
  //       mapResponse = jsonDecode(response.body);
  //       dataResponse = mapResponse["data"];
  //       //or
  //       // listResponse = mapResponse["data"];
  //     });
  //   }
  // }

  @override
  void initState() {
    // apiCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Container with hello world
      body: Center(
        child: Column(
          children: [
            Container(
              width: 349,
              height: 300,
              color: Colors.blue,
              child: Center(
                child: apiToken.isEmpty
                    ? CircularProgressIndicator(
                        color: Colors.green,
                      )
                    : Text(apiToken),
              ),
            ),

            //Logout Button
            RaisedButton(
              onPressed: () {
                UserPreferences().removeUser();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text("Logout"),
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );
  }
}
