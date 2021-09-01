// ignore_for_file: unused_import, implementation_imports

import 'dart:ffi';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:isar/src/isar_native.dart';
import 'package:isar/src/query_builder.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;
import 'ddd/infra/repository/isar/isar_model.dart';
import 'mvvm/model/isar_model.dart';
import 'god/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';

const _utf8Encoder = Utf8Encoder();

final _schema =
    '[{"name":"DDDCart","idProperty":"productId","properties":[{"name":"productId","type":3},{"name":"quantity","type":3}],"indexes":[],"links":[]},{"name":"DDDProduct","idProperty":"id","properties":[{"name":"id","type":3},{"name":"name","type":5},{"name":"price","type":3}],"indexes":[],"links":[]},{"name":"MVVMCart","idProperty":"productId","properties":[{"name":"productId","type":3},{"name":"quantity","type":3}],"indexes":[],"links":[]},{"name":"MVVMProduct","idProperty":"id","properties":[{"name":"id","type":3},{"name":"name","type":5},{"name":"price","type":3}],"indexes":[],"links":[]},{"name":"Product","idProperty":"id","properties":[{"name":"id","type":3},{"name":"name","type":5},{"name":"price","type":3}],"indexes":[],"links":[]},{"name":"Cart","idProperty":"productId","properties":[{"name":"productId","type":3},{"name":"quantity","type":3}],"indexes":[],"links":[]}]';

Future<Isar> openIsar(
    {String name = 'isar',
    String? directory,
    int maxSize = 1000000000,
    Uint8List? encryptionKey}) async {
  final path = await _preparePath(directory);
  return openIsarInternal(
      name: name,
      directory: path,
      maxSize: maxSize,
      encryptionKey: encryptionKey,
      schema: _schema,
      getCollections: (isar) {
        final collectionPtrPtr = malloc<Pointer>();
        final propertyOffsetsPtr = malloc<Uint32>(3);
        final propertyOffsets = propertyOffsetsPtr.asTypedList(3);
        final collections = <String, IsarCollection>{};
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 0));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['DDDCart'] = IsarCollectionImpl<DDDCart>(
          isar: isar,
          adapter: _DDDCartAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 2),
          propertyIds: {'productId': 0, 'quantity': 1},
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.productId,
          setId: (obj, id) => obj.productId = id,
        );
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 1));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['DDDProduct'] = IsarCollectionImpl<DDDProduct>(
          isar: isar,
          adapter: _DDDProductAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 3),
          propertyIds: {'id': 0, 'name': 1, 'price': 2},
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.id,
          setId: (obj, id) => obj.id = id,
        );
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 2));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['MVVMCart'] = IsarCollectionImpl<MVVMCart>(
          isar: isar,
          adapter: _MVVMCartAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 2),
          propertyIds: {'productId': 0, 'quantity': 1},
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.productId,
          setId: (obj, id) => obj.productId = id,
        );
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 3));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['MVVMProduct'] = IsarCollectionImpl<MVVMProduct>(
          isar: isar,
          adapter: _MVVMProductAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 3),
          propertyIds: {'id': 0, 'name': 1, 'price': 2},
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.id,
          setId: (obj, id) => obj.id = id,
        );
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 4));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['Product'] = IsarCollectionImpl<Product>(
          isar: isar,
          adapter: _ProductAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 3),
          propertyIds: {'id': 0, 'name': 1, 'price': 2},
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.id,
          setId: (obj, id) => obj.id = id,
        );
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 5));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['Cart'] = IsarCollectionImpl<Cart>(
          isar: isar,
          adapter: _CartAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 2),
          propertyIds: {'productId': 0, 'quantity': 1},
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.productId,
          setId: (obj, id) => obj.productId = id,
        );
        malloc.free(propertyOffsetsPtr);
        malloc.free(collectionPtrPtr);

        return collections;
      });
}

Future<String> _preparePath(String? path) async {
  if (path == null || p.isRelative(path)) {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, path ?? 'isar');
  } else {
    return path;
  }
}

class _DDDCartAdapter extends TypeAdapter<DDDCart> {
  @override
  int serialize(IsarCollectionImpl<DDDCart> collection, RawObject rawObj,
      DDDCart object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.productId;
    final _productId = value0;
    final value1 = object.quantity;
    final _quantity = value1;
    final size = dynamicSize + 18;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 18);
    writer.writeLong(offsets[0], _productId);
    writer.writeLong(offsets[1], _quantity);
    return bufferSize;
  }

  @override
  DDDCart deserialize(IsarCollectionImpl<DDDCart> collection,
      BinaryReader reader, List<int> offsets) {
    final object = DDDCart();
    object.productId = reader.readLong(offsets[0]);
    object.quantity = reader.readLong(offsets[1]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

class _DDDProductAdapter extends TypeAdapter<DDDProduct> {
  @override
  int serialize(IsarCollectionImpl<DDDProduct> collection, RawObject rawObj,
      DDDProduct object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.id;
    final _id = value0;
    final value1 = object.name;
    final _name = _utf8Encoder.convert(value1);
    dynamicSize += _name.length;
    final value2 = object.price;
    final _price = value2;
    final size = dynamicSize + 26;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 26);
    writer.writeLong(offsets[0], _id);
    writer.writeBytes(offsets[1], _name);
    writer.writeLong(offsets[2], _price);
    return bufferSize;
  }

  @override
  DDDProduct deserialize(IsarCollectionImpl<DDDProduct> collection,
      BinaryReader reader, List<int> offsets) {
    final object = DDDProduct();
    object.id = reader.readLong(offsets[0]);
    object.name = reader.readString(offsets[1]);
    object.price = reader.readLong(offsets[2]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

class _MVVMCartAdapter extends TypeAdapter<MVVMCart> {
  @override
  int serialize(IsarCollectionImpl<MVVMCart> collection, RawObject rawObj,
      MVVMCart object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.productId;
    final _productId = value0;
    final value1 = object.quantity;
    final _quantity = value1;
    final size = dynamicSize + 18;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 18);
    writer.writeLong(offsets[0], _productId);
    writer.writeLong(offsets[1], _quantity);
    return bufferSize;
  }

  @override
  MVVMCart deserialize(IsarCollectionImpl<MVVMCart> collection,
      BinaryReader reader, List<int> offsets) {
    final object = MVVMCart();
    object.productId = reader.readLong(offsets[0]);
    object.quantity = reader.readLong(offsets[1]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

class _MVVMProductAdapter extends TypeAdapter<MVVMProduct> {
  @override
  int serialize(IsarCollectionImpl<MVVMProduct> collection, RawObject rawObj,
      MVVMProduct object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.id;
    final _id = value0;
    final value1 = object.name;
    final _name = _utf8Encoder.convert(value1);
    dynamicSize += _name.length;
    final value2 = object.price;
    final _price = value2;
    final size = dynamicSize + 26;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 26);
    writer.writeLong(offsets[0], _id);
    writer.writeBytes(offsets[1], _name);
    writer.writeLong(offsets[2], _price);
    return bufferSize;
  }

  @override
  MVVMProduct deserialize(IsarCollectionImpl<MVVMProduct> collection,
      BinaryReader reader, List<int> offsets) {
    final object = MVVMProduct();
    object.id = reader.readLong(offsets[0]);
    object.name = reader.readString(offsets[1]);
    object.price = reader.readLong(offsets[2]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

class _ProductAdapter extends TypeAdapter<Product> {
  @override
  int serialize(IsarCollectionImpl<Product> collection, RawObject rawObj,
      Product object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.id;
    final _id = value0;
    final value1 = object.name;
    final _name = _utf8Encoder.convert(value1);
    dynamicSize += _name.length;
    final value2 = object.price;
    final _price = value2;
    final size = dynamicSize + 26;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 26);
    writer.writeLong(offsets[0], _id);
    writer.writeBytes(offsets[1], _name);
    writer.writeLong(offsets[2], _price);
    return bufferSize;
  }

  @override
  Product deserialize(IsarCollectionImpl<Product> collection,
      BinaryReader reader, List<int> offsets) {
    final object = Product();
    object.id = reader.readLong(offsets[0]);
    object.name = reader.readString(offsets[1]);
    object.price = reader.readLong(offsets[2]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

class _CartAdapter extends TypeAdapter<Cart> {
  @override
  int serialize(IsarCollectionImpl<Cart> collection, RawObject rawObj,
      Cart object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.productId;
    final _productId = value0;
    final value1 = object.quantity;
    final _quantity = value1;
    final size = dynamicSize + 18;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 18);
    writer.writeLong(offsets[0], _productId);
    writer.writeLong(offsets[1], _quantity);
    return bufferSize;
  }

  @override
  Cart deserialize(IsarCollectionImpl<Cart> collection, BinaryReader reader,
      List<int> offsets) {
    final object = Cart();
    object.productId = reader.readLong(offsets[0]);
    object.quantity = reader.readLong(offsets[1]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension GetCollection on Isar {
  IsarCollection<DDDCart> get dDDCarts {
    return getCollection('DDDCart');
  }

  IsarCollection<DDDProduct> get dDDProducts {
    return getCollection('DDDProduct');
  }

  IsarCollection<MVVMCart> get mVVMCarts {
    return getCollection('MVVMCart');
  }

  IsarCollection<MVVMProduct> get mVVMProducts {
    return getCollection('MVVMProduct');
  }

  IsarCollection<Product> get products {
    return getCollection('Product');
  }

  IsarCollection<Cart> get carts {
    return getCollection('Cart');
  }
}

extension DDDCartQueryWhereSort on QueryBuilder<DDDCart, QWhere> {
  QueryBuilder<DDDCart, QAfterWhere> anyProductId() {
    return addWhereClause(WhereClause(indexName: 'productId'));
  }
}

extension DDDCartQueryWhere on QueryBuilder<DDDCart, QWhereClause> {}

extension DDDProductQueryWhereSort on QueryBuilder<DDDProduct, QWhere> {
  QueryBuilder<DDDProduct, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: 'id'));
  }
}

extension DDDProductQueryWhere on QueryBuilder<DDDProduct, QWhereClause> {}

extension MVVMCartQueryWhereSort on QueryBuilder<MVVMCart, QWhere> {
  QueryBuilder<MVVMCart, QAfterWhere> anyProductId() {
    return addWhereClause(WhereClause(indexName: 'productId'));
  }
}

extension MVVMCartQueryWhere on QueryBuilder<MVVMCart, QWhereClause> {}

extension MVVMProductQueryWhereSort on QueryBuilder<MVVMProduct, QWhere> {
  QueryBuilder<MVVMProduct, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: 'id'));
  }
}

extension MVVMProductQueryWhere on QueryBuilder<MVVMProduct, QWhereClause> {}

extension ProductQueryWhereSort on QueryBuilder<Product, QWhere> {
  QueryBuilder<Product, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: 'id'));
  }
}

extension ProductQueryWhere on QueryBuilder<Product, QWhereClause> {}

extension CartQueryWhereSort on QueryBuilder<Cart, QWhere> {
  QueryBuilder<Cart, QAfterWhere> anyProductId() {
    return addWhereClause(WhereClause(indexName: 'productId'));
  }
}

extension CartQueryWhere on QueryBuilder<Cart, QWhereClause> {}

extension DDDCartQueryFilter on QueryBuilder<DDDCart, QFilterCondition> {
  QueryBuilder<DDDCart, QAfterFilterCondition> productIdEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<DDDCart, QAfterFilterCondition> productIdGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<DDDCart, QAfterFilterCondition> productIdLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<DDDCart, QAfterFilterCondition> productIdBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'productId',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<DDDCart, QAfterFilterCondition> quantityEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<DDDCart, QAfterFilterCondition> quantityGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<DDDCart, QAfterFilterCondition> quantityLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<DDDCart, QAfterFilterCondition> quantityBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'quantity',
      lower: lower,
      upper: upper,
    ));
  }
}

extension DDDProductQueryFilter on QueryBuilder<DDDProduct, QFilterCondition> {
  QueryBuilder<DDDProduct, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> idGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> idLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> idBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> nameEqualTo(String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> nameStartsWith(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'name',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> nameEndsWith(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'name',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'name',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> priceEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> priceGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> priceLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<DDDProduct, QAfterFilterCondition> priceBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'price',
      lower: lower,
      upper: upper,
    ));
  }
}

extension MVVMCartQueryFilter on QueryBuilder<MVVMCart, QFilterCondition> {
  QueryBuilder<MVVMCart, QAfterFilterCondition> productIdEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<MVVMCart, QAfterFilterCondition> productIdGreaterThan(
      int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<MVVMCart, QAfterFilterCondition> productIdLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<MVVMCart, QAfterFilterCondition> productIdBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'productId',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<MVVMCart, QAfterFilterCondition> quantityEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<MVVMCart, QAfterFilterCondition> quantityGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<MVVMCart, QAfterFilterCondition> quantityLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<MVVMCart, QAfterFilterCondition> quantityBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'quantity',
      lower: lower,
      upper: upper,
    ));
  }
}

extension MVVMProductQueryFilter
    on QueryBuilder<MVVMProduct, QFilterCondition> {
  QueryBuilder<MVVMProduct, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> idGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> idLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> idBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> nameEqualTo(String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> nameStartsWith(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'name',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> nameEndsWith(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'name',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'name',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> priceEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> priceGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> priceLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<MVVMProduct, QAfterFilterCondition> priceBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'price',
      lower: lower,
      upper: upper,
    ));
  }
}

extension ProductQueryFilter on QueryBuilder<Product, QFilterCondition> {
  QueryBuilder<Product, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> idGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> idLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> idBetween(int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> nameEqualTo(String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> nameStartsWith(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'name',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> nameEndsWith(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'name',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'name',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> priceEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> priceGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> priceLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<Product, QAfterFilterCondition> priceBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'price',
      lower: lower,
      upper: upper,
    ));
  }
}

extension CartQueryFilter on QueryBuilder<Cart, QFilterCondition> {
  QueryBuilder<Cart, QAfterFilterCondition> productIdEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<Cart, QAfterFilterCondition> productIdGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<Cart, QAfterFilterCondition> productIdLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<Cart, QAfterFilterCondition> productIdBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'productId',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<Cart, QAfterFilterCondition> quantityEqualTo(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<Cart, QAfterFilterCondition> quantityGreaterThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<Cart, QAfterFilterCondition> quantityLessThan(int value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'quantity',
      value: value,
    ));
  }

  QueryBuilder<Cart, QAfterFilterCondition> quantityBetween(
      int lower, int upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'quantity',
      lower: lower,
      upper: upper,
    ));
  }
}

extension DDDCartQueryLinks on QueryBuilder<DDDCart, QFilterCondition> {}

extension DDDProductQueryLinks on QueryBuilder<DDDProduct, QFilterCondition> {}

extension MVVMCartQueryLinks on QueryBuilder<MVVMCart, QFilterCondition> {}

extension MVVMProductQueryLinks on QueryBuilder<MVVMProduct, QFilterCondition> {
}

extension ProductQueryLinks on QueryBuilder<Product, QFilterCondition> {}

extension CartQueryLinks on QueryBuilder<Cart, QFilterCondition> {}

extension DDDCartQueryWhereSortBy on QueryBuilder<DDDCart, QSortBy> {
  QueryBuilder<DDDCart, QAfterSortBy> sortByProductId() {
    return addSortByInternal('productId', Sort.Asc);
  }

  QueryBuilder<DDDCart, QAfterSortBy> sortByProductIdDesc() {
    return addSortByInternal('productId', Sort.Desc);
  }

  QueryBuilder<DDDCart, QAfterSortBy> sortByQuantity() {
    return addSortByInternal('quantity', Sort.Asc);
  }

  QueryBuilder<DDDCart, QAfterSortBy> sortByQuantityDesc() {
    return addSortByInternal('quantity', Sort.Desc);
  }
}

extension DDDCartQueryWhereSortThenBy on QueryBuilder<DDDCart, QSortThenBy> {
  QueryBuilder<DDDCart, QAfterSortBy> thenByProductId() {
    return addSortByInternal('productId', Sort.Asc);
  }

  QueryBuilder<DDDCart, QAfterSortBy> thenByProductIdDesc() {
    return addSortByInternal('productId', Sort.Desc);
  }

  QueryBuilder<DDDCart, QAfterSortBy> thenByQuantity() {
    return addSortByInternal('quantity', Sort.Asc);
  }

  QueryBuilder<DDDCart, QAfterSortBy> thenByQuantityDesc() {
    return addSortByInternal('quantity', Sort.Desc);
  }
}

extension DDDProductQueryWhereSortBy on QueryBuilder<DDDProduct, QSortBy> {
  QueryBuilder<DDDProduct, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.Asc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.Desc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> sortByPrice() {
    return addSortByInternal('price', Sort.Asc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> sortByPriceDesc() {
    return addSortByInternal('price', Sort.Desc);
  }
}

extension DDDProductQueryWhereSortThenBy
    on QueryBuilder<DDDProduct, QSortThenBy> {
  QueryBuilder<DDDProduct, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.Asc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.Desc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> thenByPrice() {
    return addSortByInternal('price', Sort.Asc);
  }

  QueryBuilder<DDDProduct, QAfterSortBy> thenByPriceDesc() {
    return addSortByInternal('price', Sort.Desc);
  }
}

extension MVVMCartQueryWhereSortBy on QueryBuilder<MVVMCart, QSortBy> {
  QueryBuilder<MVVMCart, QAfterSortBy> sortByProductId() {
    return addSortByInternal('productId', Sort.Asc);
  }

  QueryBuilder<MVVMCart, QAfterSortBy> sortByProductIdDesc() {
    return addSortByInternal('productId', Sort.Desc);
  }

  QueryBuilder<MVVMCart, QAfterSortBy> sortByQuantity() {
    return addSortByInternal('quantity', Sort.Asc);
  }

  QueryBuilder<MVVMCart, QAfterSortBy> sortByQuantityDesc() {
    return addSortByInternal('quantity', Sort.Desc);
  }
}

extension MVVMCartQueryWhereSortThenBy on QueryBuilder<MVVMCart, QSortThenBy> {
  QueryBuilder<MVVMCart, QAfterSortBy> thenByProductId() {
    return addSortByInternal('productId', Sort.Asc);
  }

  QueryBuilder<MVVMCart, QAfterSortBy> thenByProductIdDesc() {
    return addSortByInternal('productId', Sort.Desc);
  }

  QueryBuilder<MVVMCart, QAfterSortBy> thenByQuantity() {
    return addSortByInternal('quantity', Sort.Asc);
  }

  QueryBuilder<MVVMCart, QAfterSortBy> thenByQuantityDesc() {
    return addSortByInternal('quantity', Sort.Desc);
  }
}

extension MVVMProductQueryWhereSortBy on QueryBuilder<MVVMProduct, QSortBy> {
  QueryBuilder<MVVMProduct, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.Asc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.Desc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> sortByPrice() {
    return addSortByInternal('price', Sort.Asc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> sortByPriceDesc() {
    return addSortByInternal('price', Sort.Desc);
  }
}

extension MVVMProductQueryWhereSortThenBy
    on QueryBuilder<MVVMProduct, QSortThenBy> {
  QueryBuilder<MVVMProduct, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.Asc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.Desc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> thenByPrice() {
    return addSortByInternal('price', Sort.Asc);
  }

  QueryBuilder<MVVMProduct, QAfterSortBy> thenByPriceDesc() {
    return addSortByInternal('price', Sort.Desc);
  }
}

extension ProductQueryWhereSortBy on QueryBuilder<Product, QSortBy> {
  QueryBuilder<Product, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<Product, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<Product, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.Asc);
  }

  QueryBuilder<Product, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.Desc);
  }

  QueryBuilder<Product, QAfterSortBy> sortByPrice() {
    return addSortByInternal('price', Sort.Asc);
  }

  QueryBuilder<Product, QAfterSortBy> sortByPriceDesc() {
    return addSortByInternal('price', Sort.Desc);
  }
}

extension ProductQueryWhereSortThenBy on QueryBuilder<Product, QSortThenBy> {
  QueryBuilder<Product, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<Product, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<Product, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.Asc);
  }

  QueryBuilder<Product, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.Desc);
  }

  QueryBuilder<Product, QAfterSortBy> thenByPrice() {
    return addSortByInternal('price', Sort.Asc);
  }

  QueryBuilder<Product, QAfterSortBy> thenByPriceDesc() {
    return addSortByInternal('price', Sort.Desc);
  }
}

extension CartQueryWhereSortBy on QueryBuilder<Cart, QSortBy> {
  QueryBuilder<Cart, QAfterSortBy> sortByProductId() {
    return addSortByInternal('productId', Sort.Asc);
  }

  QueryBuilder<Cart, QAfterSortBy> sortByProductIdDesc() {
    return addSortByInternal('productId', Sort.Desc);
  }

  QueryBuilder<Cart, QAfterSortBy> sortByQuantity() {
    return addSortByInternal('quantity', Sort.Asc);
  }

  QueryBuilder<Cart, QAfterSortBy> sortByQuantityDesc() {
    return addSortByInternal('quantity', Sort.Desc);
  }
}

extension CartQueryWhereSortThenBy on QueryBuilder<Cart, QSortThenBy> {
  QueryBuilder<Cart, QAfterSortBy> thenByProductId() {
    return addSortByInternal('productId', Sort.Asc);
  }

  QueryBuilder<Cart, QAfterSortBy> thenByProductIdDesc() {
    return addSortByInternal('productId', Sort.Desc);
  }

  QueryBuilder<Cart, QAfterSortBy> thenByQuantity() {
    return addSortByInternal('quantity', Sort.Asc);
  }

  QueryBuilder<Cart, QAfterSortBy> thenByQuantityDesc() {
    return addSortByInternal('quantity', Sort.Desc);
  }
}

extension DDDCartQueryWhereDistinct on QueryBuilder<DDDCart, QDistinct> {
  QueryBuilder<DDDCart, QDistinct> distinctByProductId() {
    return addDistinctByInternal('productId');
  }

  QueryBuilder<DDDCart, QDistinct> distinctByQuantity() {
    return addDistinctByInternal('quantity');
  }
}

extension DDDProductQueryWhereDistinct on QueryBuilder<DDDProduct, QDistinct> {
  QueryBuilder<DDDProduct, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<DDDProduct, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<DDDProduct, QDistinct> distinctByPrice() {
    return addDistinctByInternal('price');
  }
}

extension MVVMCartQueryWhereDistinct on QueryBuilder<MVVMCart, QDistinct> {
  QueryBuilder<MVVMCart, QDistinct> distinctByProductId() {
    return addDistinctByInternal('productId');
  }

  QueryBuilder<MVVMCart, QDistinct> distinctByQuantity() {
    return addDistinctByInternal('quantity');
  }
}

extension MVVMProductQueryWhereDistinct
    on QueryBuilder<MVVMProduct, QDistinct> {
  QueryBuilder<MVVMProduct, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<MVVMProduct, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<MVVMProduct, QDistinct> distinctByPrice() {
    return addDistinctByInternal('price');
  }
}

extension ProductQueryWhereDistinct on QueryBuilder<Product, QDistinct> {
  QueryBuilder<Product, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Product, QDistinct> distinctByName({bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, QDistinct> distinctByPrice() {
    return addDistinctByInternal('price');
  }
}

extension CartQueryWhereDistinct on QueryBuilder<Cart, QDistinct> {
  QueryBuilder<Cart, QDistinct> distinctByProductId() {
    return addDistinctByInternal('productId');
  }

  QueryBuilder<Cart, QDistinct> distinctByQuantity() {
    return addDistinctByInternal('quantity');
  }
}

extension DDDCartQueryProperty on QueryBuilder<DDDCart, QQueryProperty> {
  QueryBuilder<int, QQueryOperations> productIdProperty() {
    return addPropertyName('productId');
  }

  QueryBuilder<int, QQueryOperations> quantityProperty() {
    return addPropertyName('quantity');
  }
}

extension DDDProductQueryProperty on QueryBuilder<DDDProduct, QQueryProperty> {
  QueryBuilder<int, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<String, QQueryOperations> nameProperty() {
    return addPropertyName('name');
  }

  QueryBuilder<int, QQueryOperations> priceProperty() {
    return addPropertyName('price');
  }
}

extension MVVMCartQueryProperty on QueryBuilder<MVVMCart, QQueryProperty> {
  QueryBuilder<int, QQueryOperations> productIdProperty() {
    return addPropertyName('productId');
  }

  QueryBuilder<int, QQueryOperations> quantityProperty() {
    return addPropertyName('quantity');
  }
}

extension MVVMProductQueryProperty
    on QueryBuilder<MVVMProduct, QQueryProperty> {
  QueryBuilder<int, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<String, QQueryOperations> nameProperty() {
    return addPropertyName('name');
  }

  QueryBuilder<int, QQueryOperations> priceProperty() {
    return addPropertyName('price');
  }
}

extension ProductQueryProperty on QueryBuilder<Product, QQueryProperty> {
  QueryBuilder<int, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<String, QQueryOperations> nameProperty() {
    return addPropertyName('name');
  }

  QueryBuilder<int, QQueryOperations> priceProperty() {
    return addPropertyName('price');
  }
}

extension CartQueryProperty on QueryBuilder<Cart, QQueryProperty> {
  QueryBuilder<int, QQueryOperations> productIdProperty() {
    return addPropertyName('productId');
  }

  QueryBuilder<int, QQueryOperations> quantityProperty() {
    return addPropertyName('quantity');
  }
}
