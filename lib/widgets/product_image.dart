//import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {

  final String? url;

  const ProductImage({Key? key, this.url}) : super(key: key);
  // const ProductImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, ),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 380,
        child: Opacity(
          opacity: 0.95,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            child: getImage(url),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0,5)
      )
    ]
  );

  //v227 Metodo que regresa un Widget
  //3ra excepcion para crear el path correcto
  Widget getImage (String? picture){
    //Si es null regresa no-image.png
    if(picture == null) 
    return Image(
              image: AssetImage('assets/no-image.png'), 
              fit: BoxFit.cover,
            );
            
    //Si tiene un url
    if( picture.startsWith('http')) 
            return FadeInImage(
              placeholder: AssetImage('assets/jar-loading.gif'), 
              image: NetworkImage(this.url!),
              fit: BoxFit.cover,
            );

    //Si viene de un Archivo o File
    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
    

  }



}