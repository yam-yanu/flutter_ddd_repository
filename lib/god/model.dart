import 'package:isar/isar.dart';

@Collection()
class Product {
  late int id;
  late String name;
  late int price;
}

@Collection()
class Cart {
  @Id()
  late int productId;
  late int quantity;
}
