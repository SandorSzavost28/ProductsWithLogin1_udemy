import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:validacionforms1_udemy/providers/product_form_provider.dart';
import 'package:validacionforms1_udemy/services/services.dart';
import 'package:validacionforms1_udemy/ui/input_decorations.dart';
import 'package:validacionforms1_udemy/widgets/widgets.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Propiedad para acceder al ProductsService
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider( productService.selectedProduct ),
      child: _ProductsScreenBody(productService: productService),
    );
    
    //return 
  }
}

class _ProductsScreenBody extends StatelessWidget {
  const _ProductsScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            
            Stack(
              children: [
    
                ProductImage(url: productService.selectedProduct.picture),
    
                Positioned(
                  top: 30,
                  left: 10,
                  child: IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    }, 
                    icon: Icon(
                      Icons.arrow_back_ios_new, 
                      size: 30, 
                      color: Colors.pink[600],
                      //color: Colors.white,
                    )
                  ),
                ),
                
                Positioned(
                  top: 30,
                  right: 10,
                  child: IconButton(
                    onPressed: ()async{
                      //v226 propiedades necesarias para image_picker
                      final picker = new ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                      );

                      if (pickedFile == null){
                        print('No seleccionó nada');
                        return;
                      }
                      //print('Tenemos imagen ${pickedFile.path}' );
                      productService.updateSelectedProductImage(pickedFile.path);


                    }, 
                    icon: Icon(
                      Icons.camera_alt_outlined, 
                      size: 30, 
                      color: Colors.pink[600],
                      //color: Colors.white,
                    )
                  ),
                )
    
              ],
            ),
    
            _ProductForm(),
            
            SizedBox(height: 100,)
    
    
    
          ]
        ),
      ),
    
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:  FloatingActionButton(
        
        child: productService.isSavind
        ? CircularProgressIndicator( color: Colors.white,)
        : Icon(Icons.save_outlined),

        onPressed: productService.isLoading
        ? null
        : () async {
          //llamada isValidForm
          //Si no es valido solo return
          if ( !productForm.isValidForm() ) return;

          //v228 llamada al uploadImage
          final String? imageUrl = await productService.uploadImage();

          // print(imageUrl);

          //Carga de imagen a Firebase
          if ( imageUrl != null) productForm.product.picture = imageUrl;


          //Grabacion de datos del form
          await productService.saveOrCreateProduct(productForm.product);



        },
      
      ),
    
     );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Para tener acceso al ProductFormProvider, tiene la informacion de producto que se está manejando
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        //height: 200,
        decoration: _buildBoxDecoration(),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: productForm.formKey,
          child: Column(
            children: [
              SizedBox( height: 10),

              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.length<1)
                    return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', 
                  labelText: 'Nombre:')
              ),
              
              SizedBox(height: 20),

              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null){
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Precio:')
              ),

              SizedBox(height: 20),

              SwitchListTile.adaptive(
                value: product.available, 
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value){
                  //cambio valor Disponible en Switch
                  productForm.updateAvailability(value);
                }),


              SizedBox(height: 20),

            ],
          )
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]

  );
}