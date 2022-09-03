import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

 part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product{

  int quantity;
  int price;
  String category;
  String brand;
  String productId;
  String name;
  List<String> sizes;
  List<String> productImages;

  // static String key;

  Product(this.name, this.productId, this.brand, this.category, this.quantity, this.price, this.productImages, this.sizes);

  factory Product.fromJson(Map<String,dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> tojson() => _$ProductToJson(this);

}