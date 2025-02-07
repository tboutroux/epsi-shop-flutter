import 'dart:convert';
import 'package:epsi_shop/bo/product.dart';
import 'package:epsi_shop/ui/pages/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatelessWidget {
  DetailPage({super.key, required this.idProduct});
  final int idProduct;

  Future<Product> getProductDetail() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products/$idProduct"));
    if (response.statusCode == 200) {
      return Product.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Produit"),
        actions: [
            IconButton(
              onPressed: () => context.go("/cart"),
              icon: Badge(
              label:
                Text(context.watch<Cart>().getAll().length.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
            )
          ],
      ),
      body: FutureBuilder<Product>(
        future: getProductDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Aucune donnée disponible'));
          } else {
            final product = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  product.image,
                  height: 250,
                ),
                TitleLinePrice(product: product),
                Description(product: product),
                Spacer(),
                ButtonReserverEssai(product: product)
              ],
            );
          }
        },
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        product.description,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class TitleLinePrice extends StatelessWidget {
  const TitleLinePrice({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            product.getPrice(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20,
            ),
            
          )
        ],
      ),
    );
  }
}
class ButtonReserverEssai extends StatelessWidget {
  const ButtonReserverEssai({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Consumer<Cart>(
          builder: (context, cart, child) {
            return ElevatedButton.icon(
              onPressed: () {
                context.read<Cart>().add(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${product.title} ajouté au panier"),
                  ),
                );
              },
              icon: Icon(Icons.add_shopping_cart),
              label: Text("Ajouter au panier"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
