import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_product.g.dart';

@JsonSerializable(explicitToJson: true)
class CartProduct{
  int quantity;
  double price;
  String category;
  String brand;
  String productId;
  String name;
  String sizes;
  String productImages;
  int counter;

  // static String key;

  CartProduct({this.name, this.productId, this.brand, this.category, this.quantity, this.price, this.productImages, this.sizes, this.counter});

  factory CartProduct.fromJson(Map<String,dynamic> json) => _$CartProductFromJson(json);
  Map<String, dynamic> tojson() => _$CartProductToJson(this);

}