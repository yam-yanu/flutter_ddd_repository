import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repository_sample/ddd/domain/model/product.dart';
import 'package:repository_sample/ddd/domain/repository/product.dart';
import 'package:repository_sample/ddd/infra/repository/isar/product.dart';

class ProductNotifier extends ChangeNotifier {
  ProductNotifier(this._repository);

  final ProductRepository _repository;

  List<Product>? products;

  Future<void> fetchAll() async {
    products = await _repository.all();
    notifyListeners();
  }
}

final productProvider = ChangeNotifierProvider(
  (ref) => ProductNotifier(IsarProductRepository())..fetchAll(),
);
