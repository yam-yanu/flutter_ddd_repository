import 'package:flutter_test/flutter_test.dart';
import 'package:repository_sample/ddd/domain/model/product.dart';
import 'package:repository_sample/ddd/infra/repository/dummy/cart.dart';
import 'package:repository_sample/ddd/presentation/provider/cart.dart';

void main() {
  test('cart notifier test', () async {
    // isarを使用するとDBの状況に左右されるのでDummyを入れ込む
    final notifier = CartNotifier(DummyCartRepository());

    await notifier.find();
    // cartが入っているか確認
    expect(notifier.cart, isNotNull);
    // 小計が何もないことを確認
    expect(notifier.cart!.subtotals, isEmpty);

    final product = Product(id: 1, name: 'test1', price: 100);
    notifier.addProduct(product);
    expect(
      notifier.cart!.subtotals
          .where((subtotal) => subtotal.productId == product.id)
          .isNotEmpty,
      true,
    );
  });
}
