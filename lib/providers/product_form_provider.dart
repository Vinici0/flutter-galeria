import 'package:flutter/material.dart';
import 'package:galeria_rest/models/product.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    this.product.available = value;
    //Como tiene que cambiar el estado de la pantalla, se usa el notifyListeners
    notifyListeners();
  }

  bool isValidForm() {
    print(product.name);
    print(product.price);
    print(product.available);

    return formKey.currentState?.validate() ?? false;
  }
}
