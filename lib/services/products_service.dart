//Peticiones HTTP, POSTs, 

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:validacionforms1_udemy/models/models.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

class ProductsService extends ChangeNotifier{ //Se usa con Provider
  

  //Url del postman
  final String _baseUrl = 'flutter-productos1-default-rtdb.firebaseio.com';
  //Lista de productos, todos los del ProuctService que quiero mostrar en pantalla
  final List<Product> products = [];
  //Propiedad de producto seleccionado
  late Product selectedProduct;

  //v245 auth
  final storage = new FlutterSecureStorage();


  //v227 propiedad para actualizar imagen seleccionada
  //nos indicará si existe imagen, o si quiere actualizar
  File? newPictureFile;
  
  //Propiedad que indique si esat cargando
  bool isLoading = true;

  bool isSavind= false;

  //cuando la instancia ProductService sea llamada , 
  //se disparará metodo para CARGAR los productos
  ProductsService(){
    this.loadProducts();
  }
  //Metodo CARGAR //v215 agregamos <List<Product>> para indicar el tipo de retorno
  Future<List<Product>> loadProducts() async{

    //Indicamos que esta cargando
    this.isLoading = true;


    //notificamos
    notifyListeners();

    //URL que tengo que llamar
    final url = Uri.https(_baseUrl, 'products.json',{
      'auth' : await storage.read(key: 'token') ?? ''
    });
    //respuesta
    final resp = await http.get(url);
    // convertir resp.body en un mapa de Productos
    final Map<String, dynamic> productsMap = json.decode( resp.body );
    //Impresion prueba
    //print( productsMap );
    //Convertir el Mapa a Lista
    //primero barrer caa una de las llaves que tiene, y crear un 
    //Producto completo y lo agrega a la lista products del inicio
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);

    });

    //Impresion de prueba
    //print(this.products[0].name);

    this.isLoading = false;
    notifyListeners();

    return this.products;




  }
  //

  //metodo para salcar o crear
  Future saveOrCreateProduct(Product product) async {
    isSavind=true;
    notifyListeners();

    if (product.id == null){
      //Crear producto
      await this.createProduct(product);



    }else{
      //Actualizar
      await this.updateProduct(product);
      
    }


    isSavind=false;
    notifyListeners();

    //TODO mostrar notificación de guardado/actualizar

  }


  Future<String> updateProduct(Product product) async{

     //URL que tengo que llamar
    final url = Uri.https(_baseUrl, 'products/${ product.id }.json',{
      'auth' : await storage.read(key: 'token') ?? ''
    });
    //respuesta put/actualizar
    final resp = await http.put( url, body: product.toJson());
    
    final decodedData = resp.body;

    //print(decodedData);

    //TODO actualizar lista de productos
    final index = this.products.indexWhere((element) => (element.id == product.id));

    this.products[index]= product;

    return product.id!;


  }

  Future<String> createProduct(Product product) async{

     //URL que tengo que llamar
    final url = Uri.https(_baseUrl, 'products.json',{
      'auth' : await storage.read(key: 'token') ?? ''
    });
    //respuesta post/crear
    final resp = await http.post( url, body: product.toJson());
    
    final decodedData = json.decode(resp.body);
    //Asignamos el id de acuerdo al que retornó firebase, de acuerdo al campo 'name'
    product.id = decodedData['name'];
    
    this.products.add(product);

    return product.id!;

  }

  //v227 Método para actualizar la imagen en vista 
  //previa al seleccionar nueva imagen de la camara o galería
  void updateSelectedProductImage(String path){

    this.selectedProduct.picture = path;

    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();

  }

  //v228 método para subir imagen, 
  Future <String?> uploadImage() async {

    //Validacion para saber si no hay nada seleccionado
    if ( this.newPictureFile == null ) return null;
    //Iniciamos proceso de gragación
    this.isSavind = true;
    notifyListeners();
    
    //se crea la url
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dav4dev420h1gh/image/upload?upload_preset=iwpoud1q');
    // Se crea el Request del 
    final imageUploadRequest = http.MultipartRequest('POST', url);
    //adjunta archivo
    final file = await  http.MultipartFile.fromPath('file', newPictureFile!.path);
    //enlazar file con imageUploadRequest
    imageUploadRequest.files.add(file);
    //Disparar petición
    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    //validacion de error en carga
    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salió mal');
      print(resp.body);
      return null;
    } 
    
    this.newPictureFile = null;
    
    //todo correcto en respuesta de carga
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];


  }



}