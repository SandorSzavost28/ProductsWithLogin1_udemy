import 'package:flutter/material.dart';

//ChangeNotifier es lo que nos va permitir que la clase sea colocada en el Multiprovider
class LoginFormProvider extends ChangeNotifier {

  //COnectar el form a algun objeto en el provider
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  //Necesito mantener
  String email = '';
  String password = '';


  //Simulacion http
  bool _isLoading = false;
  // getter como propiedad privada, retorna _isLoading
  bool get isLoading => _isLoading;
  //setter para establever el valor en _isLoading 
  set isLoading( bool value){
    //asigna el valor a la propiedad
    this._isLoading = value;
    //notificador cuando llame o establezca un nuevo valor, notificara a todos
    notifyListeners();
  }


  //Se hara reactivo solamente lo que se necesite redibujar
  //Metodo booleano que rerese true si es valido o false si es invalido
  bool isValidForm(){

    //print(formKey.currentState?.validate());

    // print(object);
    return formKey.currentState?.validate() ?? false;
 
  }

}