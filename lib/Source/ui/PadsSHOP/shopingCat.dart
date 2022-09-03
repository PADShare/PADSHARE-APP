import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/models/shopping/cart_product.dart';
import 'package:padshare/Source/models/shopping/cartview_model.dart';
import 'package:padshare/Source/ui/PadsSHOP/checkout.dart';
import 'package:padshare/Source/utils/cart_productHelper.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
class ShoppingCat extends StatefulWidget{

  @override
  _ShoppingCatState createState() => _ShoppingCatState();
}

class _ShoppingCatState extends State<ShoppingCat> {
  StreamController _event =StreamController<int>.broadcast();
  List<CartProduct>  productList =[];
 // List<int> _counter = List();
  List<CartProduct> cartprod =[];
  List<CartProduct> _cartProduct = [];
  static int subTotal = 0;
  int _itemCount = 0;
  int _counter = 0;

  var count = 0;

  double mytotal =0.0;

  var _n = 0;

  double price;



  getalldata(){

    return FutureBuilder(
      future: _getallProductss(),
      builder: (_, snapshot){
        return CreateproductView( context,snapshot);
      }
    );
  }

   // totalprice(){
   //   for(int i =0; i < cartprod.length; i++){
   //     subTotal = subTotal + double.parse(cartprod[i].price.toString());
   //     print("TOTAL : ${subTotal}");
   //   }
   // }

  // _addProduct(int index) {
  //   setState(() {
  //     productList[index].counter++;
  //   });
  //   print(productList[index].counter);
  // }


  Future<List<CartProduct>> _getallProductss()async{
   var dbHelper = CartProductHelper.db;
  await  dbHelper.getAllProducts().then((result){
      print(result);
      // setState(() {
      //   cartprod = result;
      // });

       productList = result;


   });
   return productList;
  }


   _totalPrice()async{
    var dbHelper = CartProductHelper.db;
    var total = (await  dbHelper.gettotalPrice())[0]['Total'];
     print("my TTOTAL $total");
     setState(() {
       mytotal = double.parse(total.toString());
     });

      // cartprod.map((e) => print("TOTAL;: ${e.price}"));
     // return cartprod;
  }

 _increasePrice(CartProduct model, int index)async{
   var dbHelper = CartProductHelper.db;
   _cartProduct =  await dbHelper.getAllProducts();
            //   _cartProduct[index].counter++;


      setState(() {
        _counter = _cartProduct[index].counter + 1;
         mytotal += (double.parse(_cartProduct[index].price.toString()));
      });
 price = _counter * model.price;
  CartProduct product = CartProduct(
    productId: model.productId,
    counter: _counter,
    name: model.name,
    category: model.category,
    productImages: model.productImages,
    quantity: model.quantity,
    brand: model.brand,
    price: price,
    sizes: model.sizes
  );
   print(_counter);
      await dbHelper.updateCounter(product);
     print("UPDATED");
  // print(mytotal);
   print(_counter);
 }

  _decreasePrice(CartProduct model, int index)async{
   //  var dbHelper = CartProductHelper.db;
   //  _cartProduct =  await dbHelper.getAllProducts();
   // // _cartProduct[index].counter--;
   //  _counter -= _cartProduct[index].counter;
   //   mytotal -= (double.parse(_cartProduct[index].price.toString()));
   //
   //  print(mytotal);
   //  print(_counter);
    var dbHelper = CartProductHelper.db;
    _cartProduct =  await dbHelper.getAllProducts();
    //   _cartProduct[index].counter++;


    setState(() {
      _counter = _cartProduct[index].counter - 1;
      mytotal += (double.parse(_cartProduct[index].price.toString()));
    });
    price = _counter * model.price;
    CartProduct product = CartProduct(
        productId: model.productId,
        counter: _counter,
        name: model.name,
        category: model.category,
        productImages: model.productImages,
        quantity: model.quantity,
        brand: model.brand,
        price: price,
        sizes: model.sizes
    );
    print(_counter);
    await dbHelper.updateCounter(product);
    print("UPDATED");
    // print(mytotal);
    print(_counter);
  }


  CreateproductView(BuildContext context, AsyncSnapshot snapshot){
    productList = snapshot.data;

      cartprod =    productList;


    if( productList !=null){
      return new ListView.builder(
                   itemCount: productList.length,
                   itemBuilder: (context, index){

                // var result =    snapshot.data.fold(0,(curr, next) => curr +  int.tryParse(snapshot.data[index]).toString());
                 // print("RE :${result}");
                    // return ProductListItemCart2(productList[index], index);
                     // return ProductListItemCart(name: productList.d, price:controller.cartProduct[index].price.toString(), imageUrl: controller.cartProduct[index].productImages);

                     return Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: new Container(
                         decoration: BoxDecoration(
                           color: Color(0xffF4F6FE),
                           borderRadius: BorderRadius.circular(24),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(left:10.0, right: 25),
                           child: new Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               new Container(
                                 child: Row(
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: new Container(
                                         width: 77,
                                         height: 77,
                                         decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(100),
                                             image: DecorationImage(
                                                 fit: BoxFit.cover,
                                                 // image: AssetImage("assets/images/image2.png")
                                                 image: NetworkImage(productList[index].productImages)
                                             )
                                         ),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: new Container(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             new Text(productList[index].name.toString(), style: TextStyle(color: Color(0xff666363), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13),),
                                             new SizedBox(height: 4,),
                                             new Text('\$ ${productList[index].price}',style: TextStyle(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal,),)
                                           ],
                                         ),
                                       ),
                                     ),

                                   ],
                                 ),
                               ),
                               new Container(
                                 child: new Column(
                                   children: [
                                     InkWell(
                                       onTap: (){

                                         if(productList[index].counter > 1){
                                           _decreasePrice(productList[index],index);
                                         }
                                         // index.floor();
                                         // setState(() {});
                                         // setState(() {
                                         //   model.counter --;
                                         // });
                                       },
                                       child: new Container(
                                         width: 20,
                                         height: 20,
                                         decoration: BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.circular(100),
                                         ),
                                         child: Center(
                                           child: new Text("-", style: TextStyle(color:Color(0xff6C1682), fontSize: 15),textAlign: TextAlign.center,),
                                         ),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(top:5.0, bottom: 5),
                                       child: new Text("${productList[index].counter}", style: TextStyle(color: Color(0xff6C1682), fontSize: 12, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal),),
                                     ),
                                     InkWell(
                                       // onTap: () => setState(() => productList[index].counter++),
                                       onTap:(){

                                         _increasePrice(productList[index],index);
                                        // productList.map((val){
                                        //   int id = productList.indexOf(val);
                                        //   print(id++);
                                        // }) ;
                     },
                                      // {
                                        // setState(() {
                                        //   productList[index].counter++;
                                        //  // print( productList[index].counter++);
                                        // });
                                        // add();
                                      //  print( productList[index].counter++);
                                         //  _incrementCounter(index);
                                         //count =  model.counter++;
                                         // _increasePrice(index);
                                         //   print(count++);
                                         // setState(() {});
                                      // },
                                       child: new Container(
                                         width: 20,
                                         height: 20,
                                         decoration: BoxDecoration(
                                           color: Color(0xff6C1682),
                                           borderRadius: BorderRadius.circular(100),
                                         ),
                                         child: Center(child: new Text("+", style: TextStyle(color:Colors.white, fontSize: 14),textAlign: TextAlign.center,)),
                                       ),
                                     ),
                                   ],
                                 ),
                               )

                             ],
                           ),
                         ),
                       ),
                     );
                   },
      );
    }
    return Center(child: CircularProgressIndicator(),);

  }
  @override
  void initState() {
    // TODO: implement initState

     // CartViewModel().getAllProduct();
    _totalPrice();
    //totalprice();
    super.initState();
   // _event.add(_counter);

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return Scaffold(
      backgroundColor: Color(0xffF4F6FE),
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
           onTap: (){
             Navigator.of(context).pop();
           },
          child: Icon(Icons.arrow_back, color: Color(0xff6C1682), size: 25,),
        ),
        title: Center(child: new Text("My Cart", style: TextStyle(color: Color(0xff6C1682), fontSize: 16, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal),textAlign: TextAlign.center,)),
      ),
      body: SafeArea(
         child: Padding(
           padding: const EdgeInsets.only(top:20.0),
            child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(43),
                   topRight: Radius.circular(43),
                 ),
                 color: Colors.white,
               ),
               child: getalldata(),


        )
         )
       //  child: Padding(
       //    padding: const EdgeInsets.only(top:20.0),
       //     child: GetBuilder<CartViewModel>(
       //      init: CartViewModel(),
       //      builder: (controller) =>
       //          Container(
       //        decoration: BoxDecoration(
       //          borderRadius: BorderRadius.only(
       //            topLeft: Radius.circular(43),
       //            topRight: Radius.circular(43),
       //          ),
       //          color: Colors.white,
       //
       //        ),
       //        child: new ListView.builder(
       //          itemCount: controller.cartProduct.length,
       //          itemBuilder: (context, index){
       //            return ProductListItemCart(name: controller.cartProduct[index].name, price:controller.cartProduct[index].price.toString(), imageUrl: controller.cartProduct[index].productImages);
       //          },
       //        ),
       //      ),
       //
       // )
       //  )
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: new Container(
          height: 66,
          decoration: BoxDecoration(color: Color(0xffF4F6FE),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(42),
              topLeft: Radius.circular(42)
            )
          ),

          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: new  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: new Text("\$ ${mytotal}", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w700,fontStyle: FontStyle.normal),),
                ),
                InkWell(
                  onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder:(_)=> Checkout()));
                  },
                  child: new Container(
                     width: 112,
                    height: 40,
                    decoration: BoxDecoration(
                      color:Color(0xff692CAB),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text("CheckOut ", style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 10),),
                          SizedBox(width: 3,),
                          Padding(
                            padding: const EdgeInsets.only(bottom:10.0),
                            child: new Icon(Icons.arrow_forward, color: Colors.white, size: 15,),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addPrice(int index){

    setState(() {

    });
  }

  ProductListItemCart2(CartProduct model, int index) {

    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Container(
        decoration: BoxDecoration(
          color: Color(0xffF4F6FE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:10.0, right: 25),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Container(
                        width: 77,
                        height: 77,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                // image: AssetImage("assets/images/image2.png")
                                image: NetworkImage(model.productImages)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text(model.name.toString(), style: TextStyle(color: Color(0xff666363), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13),),
                            new SizedBox(height: 4,),
                            new Text('\$ ${model.price}',style: TextStyle(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal,),)
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              new Container(
                child: new Column(
                  children: [
                    InkWell(
                      onTap: (){
                       // _decreasePrice(index);
                       index.floor();
                       // setState(() {});
                        // setState(() {
                        //   model.counter --;
                        // });
                      },
                      child: new Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: new Text("-", style: TextStyle(color:Color(0xff6C1682), fontSize: 15),textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0, bottom: 5),
                      child: new Text("$_n", style: TextStyle(color: Color(0xff6C1682), fontSize: 12, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal),),
                    ),
                    InkWell(
                      onTap: (){
                        //add();
                      //  _incrementCounter(index);
                      //count =  model.counter++;
                      // _increasePrice(index);
                      //   print(count++);
                      // setState(() {});
                      },
                      child: new Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(0xff6C1682),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(child: new Text("+", style: TextStyle(color:Colors.white, fontSize: 14),textAlign: TextAlign.center,)),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  ProductListItemCart({String name, String price, String imageUrl}) {

    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Container(
        decoration: BoxDecoration(
          color: Color(0xffF4F6FE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:10.0, right: 25),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Container(
                        width: 77,
                        height: 77,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                // image: AssetImage("assets/images/image2.png")
                               image: NetworkImage(imageUrl)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text(name, style: TextStyle(color: Color(0xff666363), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13),),
                            new SizedBox(height: 4,),
                            new Text('\$ ${price}',style: TextStyle(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal,),)
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              new Container(
                child: new Column(
                  children: [
                    new Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: new Text("-", style: TextStyle(color:Color(0xff6C1682), fontSize: 15),textAlign: TextAlign.center,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0, bottom: 5),
                      child: new Text("2", style: TextStyle(color: Color(0xff6C1682), fontSize: 12, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal),),
                    ),
                    new Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xff6C1682),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(child: new Text("+", style: TextStyle(color:Colors.white, fontSize: 14),textAlign: TextAlign.center,)),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}