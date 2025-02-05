import 'dart:convert';
import 'package:epsi_shop/bo/product.dart';
import 'package:flutter/material.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.image,
                  height: 150,
                ),
                TitleLinePrice(product: product),
                Description(product: product),
                Spacer(),
                ButtonReserverEssai()
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            product.getPrice(),
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}

class ButtonReserverEssai extends StatelessWidget {
  const ButtonReserverEssai({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child:
            ElevatedButton(onPressed: () {}, child: Text("Réserver un essai")),
      ),
    );
  }
}
