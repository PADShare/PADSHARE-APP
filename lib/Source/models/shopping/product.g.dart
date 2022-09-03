// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    json['name'] as String,
    json['productId'] as String,
    json['brand'] as String,
    json['category'] as String,
    json['quantity'] as int,
    json['price'] as int,
    (json['productImages'] as List)?.map((e) => e as String)?.toList(),
    (json['sizes'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
      'category': instance.category,
      'brand': instance.brand,
      'productId': instance.productId,
      'name': instance.name,
      'sizes': instance.sizes,
      'productImages': instance.productImages,
    };
