import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:repository_sample/god/model.dart';
import 'package:repository_sample/isar.g.dart';

class GodShoppingPage extends StatefulWidget {
  @override
  _GodShoppingPageState createState() => _GodShoppingPageState();
}

class _GodShoppingPageState extends State<GodShoppingPage> {
  bool isMigrated = false;
  List<Product>? products;
  // キーにproductId, 値に数量が入る
  Map<int, int> cart = {};
  int totalPayment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MigrateDBWidget(
          onCompleteMigrate: (migrated) {
            if (isMigrated) {
              return;
            }
            setState(() {
              isMigrated = true;
            });
          },
          child: FutureBuilder<void>(
              future: _fetchProductsAndCart(),
              builder: (context, snapshot) {
                if (products == null || products!.isEmpty) {
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
                        children: products!
                            .map(
                              (product) => ProductView(
                                  product: product,
                                  onAddCart: (product) {
                                    // カートに商品を追加
                                    if (cart.containsKey(product.id)) {
                                      cart[product.id] = cart[product.id]! + 1;
                                    } else {
                                      cart[product.id] = 1;
                                    }
                                    _setCart(cart);
                                  }),
                            )
                            .toList(),
                      ),
                    ),
                    if (cart.isNotEmpty)
                      Column(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: cart.entries.map((entry) {
                                                final product = products!
                                                    .where((product) =>
                                                        product.id == entry.key)
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
                                                          "✕ ${entry.value}",
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
                                            "\$$totalPayment",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    _setCart({});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Future<void> _fetchProductsAndCart() async {
    if (products != null && products!.isNotEmpty) {
      return;
    }
    final isar = await openIsar();
    final result = await Future.wait([
      isar.products.where().findAll(),
      isar.carts.where().findAll(),
    ]);
    final newCart = <int, int>{};
    (result[1] as List<Cart>)
        .forEach((cart) => newCart[cart.productId] = cart.quantity);
    setState(() {
      products = result[0] as List<Product>;
    });
    _setCart(newCart);
  }

  Future<void> _setCart(Map<int, int> newCart) async {
    // 合計金額を計算
    // 同じ商品を3個以上購入した場合は5%OFF(切り捨て)
    int payment = 0;
    newCart.forEach((productId, quantity) {
      final product =
          products!.where((product) => product.id == productId).first;
      int paymentByProduct = product.price * quantity;
      if (quantity >= 3) {
        paymentByProduct = (paymentByProduct * 0.95).toInt();
      }
      payment += paymentByProduct;
    });

    // 合計金額が$100を超えた場合は送料無料
    final postage = 8;
    if (newCart.isNotEmpty && payment < 100) {
      payment += postage;
    }

    // 税金計算(切り捨て)
    final tax = 1.1;
    payment = (payment * tax).toInt();

    // Cartの情報をDBに保存
    final isar = await openIsar();
    await isar.writeTxn((isar) async {
      final carts = await isar.carts.where().findAll();
      await isar.carts.deleteAll(carts.map((cart) => cart.productId).toList());
      await isar.carts.putAll(newCart.entries.map((entry) {
        return Cart()
          ..productId = entry.key
          ..quantity = entry.value;
      }).toList());
    });

    setState(() {
      cart = newCart;
      totalPayment = payment;
    });
  }
}

class MigrateDBWidget extends StatelessWidget {
  const MigrateDBWidget({
    Key? key,
    required this.child,
    required this.onCompleteMigrate,
  }) : super(key: key);

  final Widget child;
  final Function(Isar isar) onCompleteMigrate;
  static Isar? _isar;

  static const products = [
    {'id': 0, 'name': 'バガボンドサック', 'price': 120},
    {'id': 1, 'name': 'ステラサングラス', 'price': 58},
    {'id': 2, 'name': 'ホイットニーベルト', 'price': 35},
    {'id': 3, 'name': 'ガーデンスタンド', 'price': 98},
    {'id': 4, 'name': 'ストラットイヤリング', 'price': 34},
    {'id': 5, 'name': 'ソックス(ヴァーシティ)', 'price': 12},
    {'id': 6, 'name': 'ウィーブキーリング', 'price': 16},
    {'id': 7, 'name': 'ギャツビーハット', 'price': 40},
    {'id': 8, 'name': 'シュラグバッグ', 'price': 198},
    {'id': 9, 'name': 'キルトデスクトリオ', 'price': 58},
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _migrateDB(context),
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

  Future<void> _migrateDB(BuildContext context) async {
    if (_isar != null) {
      onCompleteMigrate(_isar!);
      return;
    }
    final isar = await openIsar();
    await isar.writeTxn((isar) async {
      await isar.products.putAll(products.map((productMap) {
        return Product()
          ..id = productMap['id'] as int
          ..name = productMap['name'] as String
          ..price = productMap['price'] as int;
      }).toList());
    });
    _isar = isar;
    onCompleteMigrate(isar);
  }
}

class ProductView extends StatelessWidget {
  const ProductView({
    Key? key,
    required this.product,
    required this.onAddCart,
  }) : super(key: key);

  final Product product;
  final Function(Product product) onAddCart;

  @override
  Widget build(BuildContext context) {
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
                onAddCart(product);
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
