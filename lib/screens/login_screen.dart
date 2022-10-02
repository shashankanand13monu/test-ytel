import 'dart:convert';

// import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
//import http
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:ytel/domain/user_models.dart';
import 'package:ytel/providers/auth_method.dart';
import 'package:ytel/providers/user_provider.dart';
import 'package:ytel/screens/homepage.dart';

import '../widgets/dialog_box.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //create a global key
  final formKey = GlobalKey<FormState>();
  String apiToken = "";
  // String email = "";
  String refreshToken = "";
  String tokenType = "";

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    // final authProvider = Provider.of<AuthProvider>(context);

    void login(String email, String password, BuildContext context) async {

      Map<String, String> body = {
        'captcha': '123456',
        'grantType': "resource_owner_credentials",
        'password': password,
        'username': email,
        'refreshToken': "120",
      };

      final form = formKey.currentState;
      if (form!=null && form.validate()) {
        form.save();
        final Future<Map<String, dynamic>> response =
            auth.login(email, password);

        response.then((response) {
          if (response['status']) {
            User user = User.fromJson(response['user']);
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            //Navigate to HomeScreen() without route name
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(
              apiToken: apiToken,
            email: email,
            refreshToken: refreshToken,
            tokenType: tokenType,)));



          } else {
            // Flushbar(
            //   title: "Error",
            //   message: response['message'],
            //   duration: Duration(seconds: 3),
            // )..show(context);
            print('errorrr...');
          }
        });
      } else {
        //Flushbar Display
        // Flushbar(
        //   title: "Error",
        //   message: "Please enter a valid email and password",
        //   duration: Duration(seconds: 3),
        // ).show(context);
            print('errorrr');

      }
      //create a post request

      

      try {
        Response response = await post(
            Uri.parse('https://api.ytel.com/auth/v2/token/'),
            body: jsonEncode(body),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            });

        if (response.statusCode == 200) {
          // print("Login Success");
          //Display Dialog Box
           var data = jsonDecode(response.body.toString());
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogBox(
                    text: data['message']==null? "Login Success":data['message'],
                  ));

            if(data['message']==null){
              // Navigator.pushReplacementNamed(context, '/home');
              apiToken= data['accessToken'];
              refreshToken= data['refreshToken'];
              tokenType= data['tokenType'];
              
              Provider.of<AuthProvider>(context,listen: false).signIn(email, password);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(
              apiToken: apiToken,
            email: email,
            refreshToken: refreshToken,
            tokenType: tokenType,
              )));
            }

          //Store Data
         
          // print(data['access_token']);
          print(data);
        } else {
          print("Login Failed...");
          //Display Dialog Box
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogBox(
                    text: "Login Failed",
                  ));
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //In center
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  auth.loggedInStatus == Status.Authenticating
                      ? CircularProgressIndicator()
                      : Container(
                          width: 140,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              print(_emailController.text);
                              print(_passwordController.text);
                              
                              // auth.login(_emailController.text,
                              //     _passwordController.text);


                              login(_emailController.text,
                                  _passwordController.text, context);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
