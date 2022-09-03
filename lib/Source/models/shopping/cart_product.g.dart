// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProduct _$CartProductFromJson(Map<String, dynamic> json) {
  return CartProduct(
    name: json['name'] as String,
    productId: json['productId'] as String,
    brand: json['brand'] as String,
    category: json['category'] as String,
    quantity: json['quantity'] as int,
    price: (json['price'] as num)?.toDouble(),
    productImages: json['productImages'] as String,
    sizes: json['sizes'] as String,
    counter: json['counter'] as int,
  );
}

Map<String, dynamic> _$CartProductToJson(CartProduct instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
      'category': instance.category,
      'brand': instance.brand,
      'productId': instance.productId,
      'name': instance.name,
      'sizes': instance.sizes,
      'productImages': instance.productImages,
      'counter': instance.counter,
    };
