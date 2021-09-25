import 'package:flutter/material.dart';
import 'package:validacionforms1_udemy/models/models.dart';

class ProductCard extends StatelessWidget {
  
  final Product product;

  const ProductCard({
    Key? key,
    required this.product
    }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        
        margin: EdgeInsets.only(top: 20, bottom: 20),
        width: double.infinity,
        height: 350,
        //color: Colors.red,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft, //Alternativa al Positioned
          children: [

            _BackgroundImage( product.picture ),

            _ProductDetails(
              subTitle: product.id!, 
              title: product.name,
              ),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(product.price)
            ),

            //Mostrar de manera condicional
            if( product.available == false)
            Positioned(
              top: 0,
              left: 0,
              child: _NotAvailable(),
            ),



          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0,7)
      )
    ]
  );
}

class _NotAvailable extends StatelessWidget {
  // const _NotAvailable({
  //   Key? key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(25))

      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible', 
            style: TextStyle( color: Colors.white, fontSize: 20),
          )
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  //Se agregan para jalar los datos
  final double price;
  const _PriceTag(this.price);

    @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomLeft: Radius.circular(25))

      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$$price', style: TextStyle( color: Colors.white, fontSize: 20),)),
      ),
    );
  }
}



class _ProductDetails extends StatelessWidget {

  //Se agrega para poder jalar el valor desde el ProductService
  final String title;
  final String subTitle;

  const _ProductDetails({
    required this.title, 
    required this.subTitle
  });

  // const _ProductDetails({
  //   Key? key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        //color: Colors.indigo,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.title, 
              style: TextStyle( fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              this.subTitle, 
              style: TextStyle( fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(25),
      topRight: Radius.circular(25),

    )
  );
}



class _BackgroundImage extends StatelessWidget {

  final String? url;

  const _BackgroundImage(this.url);



  // const _BackgroundImage({
  //   Key? key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 350,
        //Condicional de null en imagen
        child: url == null
          ? Image(
            image: AssetImage('assets/no-image.png'),
            fit: BoxFit.cover
          )
          : FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'), 
          image: NetworkImage(url!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}