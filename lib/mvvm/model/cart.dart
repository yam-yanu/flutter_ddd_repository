import 'package:collection/collection.dart';
import 'package:repository_sample/mvvm/model/product.dart';

class Cart {
  Cart({
    required this.subtotals,
  });

  final List<Subtotal> subtotals;

  int get payment => _payment();

  void add(
    Product product, {
    int quantity = 1,
  }) {
    final target = subtotals
        .where((subtotal) => subtotal.productId == product.id)
        .firstOrNull;
    if (target == null) {
      subtotals.add(Subtotal(
        productId: product.id,
        unitPrice: product.price,
        quantity: quantity,
      ));
    } else {
      target.increaseQuantity();
    }
  }

  void empty() {
    subtotals.clear();
  }

  int _payment() {
    int payment = 0;
    subtotals.forEach((subtotal) => payment += subtotal.payment);

    // 合計金額が$100を超えた場合は送料無料
    final postage = 8;
    if (subtotals.isNotEmpty && payment < 100) {
      payment += postage;
    }

    // 税金計算(切り捨て)
    final tax = 1.1;
    return (payment * tax).toInt();
  }
}

class Subtotal {
  Subtotal({
    required this.productId,
    required this.unitPrice,
    required this.quantity,
  }) : assert(quantity > 0);

  final int productId;
  final int unitPrice;
  int quantity;

  int get payment => _payment();

  void increaseQuantity() {
    quantity += 1;
  }

  int _payment() {
    // 同じ商品を3個以上購入した場合は5%OFF(切り捨て)
    return (unitPrice * quantity * (quantity >= 3 ? 0.95 : 1)).toInt();
  }
}
