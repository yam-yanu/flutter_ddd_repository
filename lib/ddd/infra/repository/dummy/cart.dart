import 'package:repository_sample/ddd/domain/model/cart.dart';
import 'package:repository_sample/ddd/domain/repository/cart.dart';

class DummyCartRepository extends CartRepository {

  @override
  Future<Cart> find() async {
    return Cart(subtotals: []);
  }

  @override
  Future<void> add(Cart cart) async {
    return;
  }

  @override
  Future<void> empty(Cart cart) async {
    return;
  }

}
