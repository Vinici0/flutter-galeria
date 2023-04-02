import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galeria_rest/providers/product_form_provider.dart';
import 'package:galeria_rest/services/products_service.dart';
import 'package:galeria_rest/ui/input_decorations.dart';
import 'package:galeria_rest/widgets/product_image.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  static String productroute = 'product';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    //Ahora se tiene acceso a todo el servicio de productos
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
    // return _ProductScreenBody(productService: productService);
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    super.key,
    required this.productService,
  });

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productService.selectedProduct.picture,
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final PickedFile? pickedFile = await picker.getImage(
                          source: ImageSource.camera, imageQuality: 100);
                      if (pickedFile == null) {
                        print('No se selecciono ninguna imagen');
                        return;
                      }
                      print('Se selecciono una imagen');
                      productService
                          .updateSelectedProductImage(pickedFile!.path);
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const _ProductForm(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: productService.isSaving
              ? null
              : () async {
                  //En caso el formulario no sea valido no se hace nada
                  if (!productForm.isValidForm()) return;
                  //uploadImage
                  final String? imageUrl = await productService.uploadImage();

                  if (imageUrl != null) {
                    productService.selectedProduct.picture = imageUrl;
                  }

                  //En caso de que sea valido se guarda el producto
                  await productService.saveOrCreateProduct(productForm.product);
                },
          child: productService.isSaving
              ? const CircularProgressIndicator()
              : const Icon(Icons.save_outlined)),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: _buildBoxDecoration(),
          child: Form(
              key: productForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: product.name,
                    onChanged: (value) => product.name = value,
                    validator: (value) => value != null && value.length < 1
                        ? 'El nombre es obligatorio'
                        : null,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre del producto', labelText: 'Nombre'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: 0.toString(),
                    inputFormatters: [
                      //Sirve para limitar el numero de caracteres que se pueden ingresar
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      if (double.tryParse(value) != null) {
                        product.price = double.parse(value);
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Precio del producto en \$ ',
                        labelText: 'Precio'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SwitchListTile.adaptive(
                    //adaptive sirve para que se adapte a la plataforma si es !!!adroid o ios!!!
                    value: product.available,
                    title: const Text('Disponible'),
                    activeColor: Colors.indigo,
                    onChanged: (value) {
                      productForm.updateAvailability(value);
                    },
                  ),
                ],
              ))),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            //Sirve para agregar sombras a los contenedores
            color: Colors.black.withOpacity(0.5),
            // spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      );
}
