import 'package:isar/isar.dart';

@Collection()
class MVVMCart {
  @Id()
  late int productId;
  late int quantity;
}

@Collection()
class MVVMProduct {
  late int id;
  late String name;
  late int price;
}
