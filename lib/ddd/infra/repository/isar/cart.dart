import 'package:isar/isar.dart';
import 'package:repository_sample/ddd/domain/model/cart.dart';
import 'package:repository_sample/ddd/domain/repository/cart.dart';
import 'package:repository_sample/ddd/infra/repository/isar/isar_model.dart';
import 'package:repository_sample/isar.g.dart';

class IsarCartRepository implements CartRepository {
  Isar? _isar;

  @override
  Future<Cart> find() async {
    final isarCart = await (await _getIsar()).dDDCarts.where().findAll();
    // 今のところ全件取得するのでちゃんと考えたい
    final isarProducts =
        await (await _getIsar()).dDDProducts.where().findAll();
    return Cart(
      subtotals: isarCart.map((cart) {
        final product =
            isarProducts.where((product) => product.id == cart.productId).first;
        return Subtotal(
          productId: product.id,
          unitPrice: product.price,
          quantity: cart.quantity,
        );
      }).toList(),
    );
  }

  @override
  Future<void> add(Cart cart) async {
    await (await _getIsar()).writeTxn((isar) async {
      final carts = await isar.dDDCarts.where().findAll();
      await isar.dDDCarts.deleteAll(carts.map((cart) => cart.productId).toList());
      await isar.dDDCarts.putAll(cart.subtotals.map((subtotal) {
        return DDDCart()
          ..productId = subtotal.productId
          ..quantity = subtotal.quantity;
      }).toList());
    });
  }

  Future<void> empty(Cart cart) async {
    await (await _getIsar()).writeTxn((isar) async {
      final carts = await isar.dDDCarts.where().findAll();
      await isar.dDDCarts.deleteAll(carts.map((cart) => cart.productId).toList());
    });
  }

  Future<Isar> _getIsar() async {
    return _isar ??= await openIsar();
  }
}
