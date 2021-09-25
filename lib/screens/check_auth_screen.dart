import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacionforms1_udemy/screens/screens.dart';
import 'package:validacionforms1_udemy/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return Text('Espere');

            if (snapshot.data == '') {
              Future.microtask(() {
                // Navigator.of(context).pushReplacementNamed('login');
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginScreen(),
                      transitionDuration: Duration(seconds: 0),
                    ));
              });
            } else {
              Future.microtask(() {
                // Navigator.of(context).pushReplacementNamed('login');
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => HomeScreen(),
                      transitionDuration: Duration(seconds: 0),
                    ));
              });
            }

            return Container();
          },
        ),
      ),
    );
  }
}
