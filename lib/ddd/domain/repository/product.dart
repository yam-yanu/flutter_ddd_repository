import 'package:repository_sample/ddd/domain/model/product.dart';

abstract class ProductRepository {
  Future<List<Product>> all();
}
