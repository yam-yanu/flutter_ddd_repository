import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repository_sample/ddd/domain/model/cart.dart';
import 'package:repository_sample/ddd/domain/model/product.dart';
import 'package:repository_sample/ddd/domain/repository/cart.dart';
import 'package:repository_sample/ddd/infra/repository/isar/cart.dart';

class CartNotifier extends ChangeNotifier {
  CartNotifier(this._repository);

  final CartRepository _repository;

  Cart? cart;

  Future<void> find() async {
    cart = await _repository.find();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    if (cart == null) {
      return;
    }
    cart!.add(product);
    _repository.add(cart!);
    notifyListeners();
  }

  Future<void> empty() async {
    if (cart == null) {
      return;
    }
    cart!.empty();
    _repository.empty(cart!);
    notifyListeners();
  }

}

final cartProvider = ChangeNotifierProvider(
  (ref) => CartNotifier(IsarCartRepository())..find(),
);
