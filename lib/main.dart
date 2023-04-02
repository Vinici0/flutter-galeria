import 'package:flutter/material.dart';
import 'package:galeria_rest/screens/screens.dart';
import 'package:galeria_rest/services/products_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  //Para tener la informacion centralizada en un solo lugar
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProductsService()),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.homeroute,
      title: 'Material App',
      routes: {
        HomeScreen.homeroute: (context) => const HomeScreen(),
        ProductScreen.productroute: (context) => const ProductScreen(),
        LoginScreen.loginroute: (context) => const LoginScreen(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(elevation: 0, color: Colors.indigo),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
