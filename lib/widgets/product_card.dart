import 'package:flutter/material.dart';
import 'package:galeria_rest/models/models.dart';
import 'dart:io';

class ProducCard extends StatelessWidget {
  final Product product;

  ProducCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 50, top: 30),
        width: double.infinity,
        height: 400,
        decoration: _cardsBorder(),
        child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          _BackGrounImage(product: product),
          _ProductsDetails(product: product),
          Positioned(top: 0, right: 0, child: _PriceTag(product: product)),
          if (!product.available)
            Positioned(top: 0, left: 0, child: _NotaAvailable(product: product))
        ]),
      ),
    );
  }

  BoxDecoration _cardsBorder() {
    return BoxDecoration(
        color: Colors.white,
        //AGREGA BORDES A TODOS LOS LADOS
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
        ]);
  }
}

class _NotaAvailable extends StatelessWidget {
  final Product product;

  const _NotaAvailable({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          )),
      child: FittedBox(
        fit: BoxFit
            .contain, //Para que el texto se ajuste al tamaño del contenedor
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            product.available ? 'Disponible' : 'No disponible',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final Product product;

  const _PriceTag({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )),
      child: FittedBox(
        fit: BoxFit
            .contain, //Para que el texto se ajuste al tamaño del contenedor
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            product.price.toString(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _ProductsDetails extends StatelessWidget {
  final Product product;

  const _ProductsDetails({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        // color: Colors.indigo,
        decoration: _builBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.id ?? '',
              style: TextStyle(color: Colors.white, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _builBoxDecoration() => const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            // topLeft: Radius.circular(25),
            // bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25)),
      );
}

class _BackGrounImage extends StatelessWidget {
  final Product product;

  const _BackGrounImage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      //Investigar como usar
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: getImage(product.picture),
      ),
    );
  }

  Widget getImage(String? picture) {
    print('picture: $picture');
    if (picture == null) {
      return const Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    }

    if (picture.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(picture),
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
