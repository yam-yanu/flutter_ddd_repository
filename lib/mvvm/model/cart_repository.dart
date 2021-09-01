import 'package:isar/isar.dart';
import 'package:repository_sample/mvvm/model/cart.dart';
import 'package:repository_sample/isar.g.dart';
import 'package:repository_sample/mvvm/model/isar_model.dart';

class CartRepository {
  Isar? _isar;

  Future<Cart> find() async {
    final isarCart = await (await _getIsar()).mVVMCarts.where().findAll();
    // 今のところ全件取得するのでちゃんと考えたい
    final isarProducts =
        await (await _getIsar()).mVVMProducts.where().findAll();
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

  Future<void> add(Cart cart) async {
    await (await _getIsar()).writeTxn((isar) async {
      final carts = await isar.mVVMCarts.where().findAll();
      await isar.mVVMCarts.deleteAll(carts.map((cart) => cart.productId).toList());
      await isar.mVVMCarts.putAll(cart.subtotals.map((subtotal) {
        return MVVMCart()
          ..productId = subtotal.productId
          ..quantity = subtotal.quantity;
      }).toList());
    });
  }

  Future<void> empty(Cart cart) async {
    await (await _getIsar()).writeTxn((isar) async {
      final carts = await isar.mVVMCarts.where().findAll();
      await isar.mVVMCarts.deleteAll(carts.map((cart) => cart.productId).toList());
    });
  }

  Future<Isar> _getIsar() async {
    return _isar ??= await openIsar();
  }
}
