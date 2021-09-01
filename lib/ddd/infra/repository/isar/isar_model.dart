import 'package:isar/isar.dart';

@Collection()
class DDDCart {
  @Id()
  late int productId;
  late int quantity;
}

@Collection()
class DDDProduct {
  late int id;
  late String name;
  late int price;
}
