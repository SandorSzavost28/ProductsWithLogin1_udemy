import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  // const AuthBackground({Key? key}) : super(key: key);

  //Se crea para enviarle un Wigdet como argumento
  //Voy a recibir un Wigdet
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
      width: double.infinity, //Tamaño completo de la pantalla
      height: double.infinity, //Tamaño completo de la pantalla
      child: Stack(
        //Widgets encima de otros
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          this.child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 85,
        ),
        margin: EdgeInsets.only(top: 30),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  // const _PurpleBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      //child: null,
      height: size.height * 0.4,
      width: double.infinity,
      //color: Colors.indigo,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(
            child: _Bubble(),
            top: 10,
            left: 30,
          ),
          Positioned(
            child: _Bubble(),
            top: 20,
            left: 230,
          ),
          Positioned(
            child: _Bubble(),
            top: 180,
            left: 20,
          ),
          Positioned(
            child: _Bubble(),
            top: 120,
            left: 160,
          ),
          Positioned(
            child: _Bubble(),
            top: 120,
            left: 300,
          )
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 178, 1),
        ]),
      );
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
