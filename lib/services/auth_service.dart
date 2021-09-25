import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier{

  //La info que tenemos
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyC2dfWF3lq66Onpw34RiVz9uvVBeCVHT6k';

  final storage = new FlutterSecureStorage();

  Future <String?> createUser (String email, String password) async {

    //El post necesita la informacion como un mapa, que sera 
    //posteriormente json.encode*, para que lo lea en la peticion post
    final Map<String, dynamic> authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true,
     };

     final url = Uri.https(_baseUrl, '/v1/accounts:signUp',{'key':_firebaseToken});

     final resp = await http.post(url,body: json.encode(authData)); //*

     final Map<String,dynamic> decodedResp = json.decode(resp.body);

    //  print(decodedResp);
    if ( decodedResp.containsKey('idToken')){
      
      await storage.write(key: 'token', value: decodedResp['idToken']);
      //Guardar en lugar seguro
      return null;
    }else{
      return decodedResp['error']['message'];
    }


  }

  Future <String?> login (String email, String password) async {

    //El post necesita la informacion como un mapa, que sera 
    //posteriormente json.encode*, para que lo lea en la peticion post
    final Map<String, dynamic> authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true,
     };

     final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword',{'key':_firebaseToken});

     final resp = await http.post(url,body: json.encode(authData)); //*

     final Map<String,dynamic> decodedResp = json.decode(resp.body);

    //  print(decodedResp);

    //  return 'Error en login'; 

    if ( decodedResp.containsKey('idToken')){
      //Guardar en lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    }else{
      return decodedResp['error']['message'];
    }

  }

  Future logout() async{

    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async{
    //Si el token no existe regresa ''
    return await storage.read(key: 'token') ?? '';

  }


}


