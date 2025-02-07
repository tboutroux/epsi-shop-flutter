import 'package:flutter/material.dart';
import 'package:epsi_shop/bo/product.dart';
import 'package:provider/provider.dart';

// Modèle pour gérer le panier
class Cart extends ChangeNotifier {
  final List<Product> _items = [];

  // Ajouter un produit au panier
  void add(Product product) {
    _items.add(product);
    notifyListeners(); // Notifie les écouteurs que le panier a été modifié
  }

  // Retirer un produit du panier
  void remove(Product product) {
    _items.remove(product);
    notifyListeners(); // Notifie les écouteurs que le panier a été modifié
  }

  // Récupérer tous les produits du panier
  List<Product> getAll() {
    return _items;
  }

  // Calculer le prix total du panier
  String getTotalPrice() {
    double total = _items.fold(0, (sum, product) => sum + product.price);
    total = total * 1.2; // TVA
    return "${total.toStringAsFixed(2)}€";
  }

  // Vider le panier
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Page du panier
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Panier'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          final items = cart.getAll();
          if (items.isEmpty) {
            return const Center(
              child: Text("Votre panier est vide."),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final product = items[index];
                    return ListTile(
                      leading: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(product.title),
                      subtitle: Text(product.getPrice()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => cart.remove(product),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total : ${cart.getTotalPrice()}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Action pour valider le panier
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Commande validée !"),
                          ),
                        );
                      },
                      child: const Text("Valider la commande"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}