import 'package:flutter/material.dart';
import 'package:galeria_rest/models/models.dart';
import 'package:galeria_rest/screens/screens.dart';
import 'package:galeria_rest/services/services.dart';
import 'package:galeria_rest/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String homeroute = 'home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                productsService.selectedProduct =
                    productsService.products[index].copy();
                Navigator.pushNamed(context, ProductScreen.productroute);
              },
              child: ProducCard(
                product: productsService.products[index],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Importante: que en todo momento se tenga una copia del producto seleccionado para que de error
          productsService.selectedProduct =
              Product(available: false, name: 'Temporal', price: 0);
          Navigator.pushNamed(context, ProductScreen.productroute);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
