import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wup/Pages/welcome.dart';

void main() => runApp(Wup());

class Wup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Wup",
      theme: ThemeData(
          primarySwatch: Colors.red,
          unselectedWidgetColor:Colors.white
      ),
      routes: {
        '/Home': (context) => WelcomePage(),
        '/Welcome': (context) => WelcomePage(),
      },
      home: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
            if (snapshot.hasData){
              FirebaseUser user = snapshot.data; // this is your user instance
              //User logged in
              return WelcomePage();
            }
            // User not logged in
            return WelcomePage();
          }
      ),
    );
  }
}
