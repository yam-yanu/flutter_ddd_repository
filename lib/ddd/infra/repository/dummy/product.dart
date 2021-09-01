import 'package:repository_sample/ddd/domain/model/product.dart';
import 'package:repository_sample/ddd/domain/repository/product.dart';

final products = [
  Product(id: 0, name: 'バガボンドサック', price: 120),
  Product(id: 1, name: 'ステラサンドグラス', price: 58),
  Product(id: 2, name: 'ホイットニーベルト', price: 35),
];

class DummyProductRepository extends ProductRepository {

  @override
  Future<List<Product>> all() async {
    return products;
  }

}
