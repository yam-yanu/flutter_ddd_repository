import 'package:isar/isar.dart';
import 'package:repository_sample/mvvm/model/product.dart';
import 'package:repository_sample/isar.g.dart';

class ProductRepository {
  Isar? _isar;

  Future<List<Product>> all() async {
    final isarProducts =
        await (await _getIsar()).mVVMProducts.where().findAll();
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
