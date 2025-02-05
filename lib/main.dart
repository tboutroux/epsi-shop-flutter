import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/ui/pages/cart.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MyApp(),
    ),
  );
}
