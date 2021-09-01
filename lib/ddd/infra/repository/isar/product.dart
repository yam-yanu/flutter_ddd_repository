import 'package:isar/isar.dart';
import 'package:repository_sample/ddd/domain/model/product.dart';
import 'package:repository_sample/ddd/domain/repository/product.dart';
import 'package:repository_sample/isar.g.dart';

class IsarProductRepository implements ProductRepository {
  Isar? _isar;

  @override
  Future<List<Product>> all() async {
    final isarProducts =
        await (await _getIsar()).dDDProducts.where().findAll();
    return isarProducts.map((product) {
      return Product(
        id: product.id,
        name: product.name,
        price: product.price,
      );
    }).toList();
  }

  Future<Isar> _getIsar() async {
    return _isar ??= await openIsar();
  }

}
