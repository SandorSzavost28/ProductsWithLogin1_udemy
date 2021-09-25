import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacionforms1_udemy/models/models.dart';
import 'package:validacionforms1_udemy/screens/screens.dart';
import 'package:validacionforms1_udemy/services/services.dart';
import 'package:validacionforms1_udemy/widgets/widgets.dart';
// import 'package:image_picker/image_picker.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Leer el ProducService
    final productService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context,listen: false);

    if ( productService.isLoading ) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        leading: IconButton(
          icon: Icon(Icons.login_outlined),
          onPressed: (){
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          }, 
        ),

      ),
      body: ListView.builder(
        //v215 se cambia la cantidad a lenggh de 
        itemCount: productService.products.length,
        itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () { 
            
            //Devuelve una copia del mismo producto en selecttedProduct
            productService.selectedProduct = productService.products[index].copy();
            
            //PushNamed para crear una nueva tareta en el stack de taretas            
            Navigator.pushNamed(context, 'product');
            
          }, 
          //v215 se agrega el argumento product;
          child: ProductCard(product: productService.products[index],));
       },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          //Creación del nueva instancia product de Producto de acuerdo al 
          //Producto seleccionado, con valores vacios
          productService.selectedProduct = new Product(
            //requiere estos valores
            available: false,
            name: '',
            price: 0,
          );

          Navigator.pushNamed(context, 'product'); 


        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      
   );
  }
}