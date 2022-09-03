

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:padshare/Source/models/shopping/cart_product.dart';
import 'package:padshare/Source/utils/cart_productHelper.dart';

class CartViewModel extends GetxController{

  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  List<CartProduct> _cartProduct = [];
  List<CartProduct> get cartProduct => _cartProduct;

CartViewModel(){
  getAllProduct();
}
  getAllProduct() async{
  _loading.value = true;

   var dbHelper = CartProductHelper.db;
  _cartProduct =  await dbHelper.getAllProducts();

  print("DATADD:");
 print(_cartProduct.length);

_loading.value = false;
update();
  }

  addProduct(CartProduct cartProduct) async{

    // var dbhelper = CartProductHelper.db;
    // await dbhelper.insert(cartProduct);
   if(_cartProduct.length == 0){

     var dbhelper = CartProductHelper.db;
     await dbhelper.insert(cartProduct);

   }else{
     for(int i=0; i < _cartProduct.length ; i++){
       if(_cartProduct[i].productId == cartProduct.productId){
         return;
       }else{
         var dbhelper = CartProductHelper.db;
         await dbhelper.insert(cartProduct);
       }
     }

   }


    update();

   // print(_cartProduct.length);

  }

}