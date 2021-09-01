import 'package:repository_sample/isar.g.dart';
import 'package:repository_sample/mvvm/model/isar_model.dart';

const products = [
  {'id': 0, 'name': 'バガボンドサック', 'price': 120},
  {'id': 1, 'name': 'ステラサングラス', 'price': 58},
  {'id': 2, 'name': 'ホイットニーベルト', 'price': 35},
  {'id': 3, 'name': 'ガーデンスタンド', 'price': 98},
  {'id': 4, 'name': 'ストラットイヤリング', 'price': 34},
  {'id': 5, 'name': 'ソックス(ヴァーシティ)', 'price': 12},
  {'id': 6, 'name': 'ウィーブキーリング', 'price': 16},
  {'id': 7, 'name': 'ギャツビーハット', 'price': 40},
  {'id': 8, 'name': 'シュラグバッグ', 'price': 198},
  {'id': 9, 'name': 'キルトデスクトリオ', 'price': 58},
];

Future<void> migrateDB() async {
  final isar = await openIsar();
  await isar.writeTxn((isar) async {
    await isar.mVVMProducts.putAll(products.map((productMap) {
      return MVVMProduct()
        ..id = productMap['id'] as int
        ..name = productMap['name'] as String
        ..price = productMap['price'] as int;
    }).toList());
  });
}
