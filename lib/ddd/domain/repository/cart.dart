import 'package:repository_sample/ddd/domain/model/cart.dart';

abstract class CartRepository {
  Future<Cart> find();
  Future<void> add(Cart cart);
  Future<void> empty(Cart cart);
}
