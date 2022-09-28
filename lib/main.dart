import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytel/providers/auth_method.dart';
import 'package:ytel/screens/homepage.dart';
import 'package:ytel/screens/login_screen.dart';
import 'package:ytel/screens/test_screen.dart';
import 'package:ytel/utils/shared_preference.dart';

import 'domain/user_models.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return TestScreen();


                  
                } else if (snapshot.hasError) {
                  return Text('errror');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.blue,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }
              return LoginScreen();
            }),
        routes: {
          '/login': (context) => LoginScreen(),
          // '/home': (context) => HomePage(user: U,),
        },
      ),
    );
  }
}
