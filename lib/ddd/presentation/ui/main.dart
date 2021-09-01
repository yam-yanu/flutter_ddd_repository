import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:repository_sample/ddd/domain/model/product.dart';
import 'package:repository_sample/ddd/infra/migrate_db.dart';
import 'package:repository_sample/ddd/presentation/provider/cart.dart';
import 'package:repository_sample/ddd/presentation/provider/product.dart';
import 'package:repository_sample/isar.g.dart';

final isarProvider = FutureProvider<Isar>((ref) => openIsar());

class DDDShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MigrateDBWidget(
          child: Consumer(builder: (context, watch, _) {
            final productNotifier = watch(productProvider);
            final products = productNotifier.products;
            if (products == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    childAspectRatio: 4 / 5,
                    crossAxisCount: 2,
                    children: products
                        .map((product) => ProductView(product: product))
                        .toList(),
                  ),
                ),
                CartView(),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final cartNotifier = watch(cartProvider);
        final productNotifier = watch(productProvider);
        final cart = cartNotifier.cart;
        final products = productNotifier.products;
        if (cart == null || products == null || cart.subtotals.isEmpty) {
          return SizedBox();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.white.withOpacity(0.9),
              height: 80,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: cart.subtotals.map((subtotal) {
                                  final product = products
                                      .where((product) =>
                                          product.id == subtotal.productId)
                                      .first;
                                  return Row(
                                    children: [
                                      Image.asset(
                                        '${product.id}-0.jpg',
                                        package: 'shrine_images',
                                        fit: BoxFit.cover,
                                        width: 36,
                                        height: 36,
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: Center(
                                          child: Text(
                                            "✕ ${subtotal.quantity}",
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Text(
                              "\$${cart.payment}",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_shopping_cart,
                            color: Colors.grey[800],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'リセット',
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      cartNotifier.empty();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}

class MigrateDBWidget extends StatelessWidget {
  const MigrateDBWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: migrateDB(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cartNotifier = context.read(cartProvider);
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              '${product.id}-0.jpg',
              package: 'shrine_images',
              fit: BoxFit.cover,
              width: 180,
              height: 180,
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.add_shopping_cart),
              ),
              onTap: () {
                cartNotifier.addProduct(product);
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(product.name),
        Text('\$${product.price}'),
      ],
    );
  }
}
