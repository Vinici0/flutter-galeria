import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    print('url: $url');
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Container(
            decoration: _buildBoxDecoration(),
            width: double.infinity,
            height: 450,
            child: Opacity(
              opacity: 0.9,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: getImage(url),
              ),
            )));
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.red,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              //Sirve para agregar sombras a los contenedores
              color: Colors.black.withOpacity(0.5),
              // spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ]);

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
        image: NetworkImage(url!),
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
