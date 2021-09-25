import 'package:flutter/material.dart';
import 'package:validacionforms1_udemy/models/models.dart';

class ProductFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  //Propiedad para almacenar el producto_seleccionado
  Product product;
  //Constructor y recibe el this.product, debe ser una copia, IMPORTANTE
  ProductFormProvider(this.product);

  //Método para actualizar el valor de available por medio del SwitchListTile
  updateAvailability(bool value){
    print(value);
    //Actualizamos el valor de acuerdo al valor del switch
    this.product.available = value;
    //notificamos listeners
    notifyListeners();

  }


  bool isValidForm(){

    print(product.name);
    print(product.price);
    print(product.available);

    return formKey.currentState?.validate() ?? false; // Si regresa NULL sera false
  }



}