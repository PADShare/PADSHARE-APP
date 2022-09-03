import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/models/shopping/cart_product.dart';
import 'package:padshare/Source/ui/PadsSHOP/paynow.dart';
import 'package:padshare/Source/utils/cart_productHelper.dart';

class Checkout extends StatefulWidget{

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  List<CartProduct>  productList =[];
  // List<int> _counter = List();
  List<CartProduct> cartprod =[];
  List<CartProduct> _cartProduct = [];
  int _counter = 0;

  var count = 0;
  double mytotal =0.0;
  int mtotal =0;

  bool isLoading = true;

  var _n = 0;

  double price;

  Future<List<CartProduct>> _getallProductss()async{
    var dbHelper = CartProductHelper.db;
    await  dbHelper.getAllProducts().then((result){
      print(result);
      productList = result;





    });
    return productList;
  }

 getallCartProducts(){
    return FutureBuilder(
      future:_getallProductss(),
      builder: (_, snapshot){
        // mytotal = snapshot.data;
       return CreateListviewItems(context,snapshot);
      },
    );
  }
  _totalPrice()async{
    var dbHelper = CartProductHelper.db;
    var total = (await  dbHelper.gettotalPrice())[0]['Total'];
    print("my TTOTAL $total");
    setState(() {
      mytotal = double.parse(total.toString());
    });

  print(mytotal);
    // cartprod.map((e) => print("TOTAL;: ${e.price}"));
    // return cartprod;
  }

  @override
  void initState() {
    // TODO: implement initState
    _totalPrice();
    Future.delayed(Duration(seconds: 2)).then((value){

      setState(() {
        isLoading = false;
      });
    });
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: Color(0xffF4F6FE),
        extendBodyBehindAppBar: true,
       appBar: new AppBar(
         backgroundColor: Colors.transparent,
         elevation: 0,
         leading: GestureDetector(
           onTap: (){
             Navigator.of(context).pop();
           },
           child: new Icon(Icons.arrow_back, color: Color(0xff692CAB),),
         ),
       ),
       body: SafeArea(
         child: IntrinsicHeight(
           child: new Column(
             children: [
                  Expanded(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(top:10.0 , bottom: 10, right: 20,left: 20),
                       child: new Container(
                         padding: const EdgeInsets.only(bottom: 10),
                         decoration: BoxDecoration(
                             border: Border(
                                 bottom: BorderSide(
                                     width: 1,
                                     color: Colors.grey[300],
                                     style: BorderStyle.solid
                                 )
                             )
                         ),
                         child: new Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             new Text("Checkout", style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal),),
                             SizedBox(height: 4,),
                             new Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 new Text("${mtotal} Items", style: GoogleFonts.roboto(color: Colors.grey, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                                 new GestureDetector(onTap: (){},
                                     child: Icon(Icons.delete_forever, color: Colors.grey, size: 20,))
                               ],
                             )
                           ],),
                       ),
                     ),
                     new Container(
                       height: MediaQuery.of(context).size.height *0.40,
                       decoration: BoxDecoration(
                         color: Color(0xffF4F6FE),
                         borderRadius: BorderRadius.circular(24),
                       ),
                       child: isLoading ? Center(child: CircularProgressIndicator(),) : getallCartProducts(),

                     ),
                     new Container(
                       padding: const EdgeInsets.only(bottom: 25),
                       decoration: BoxDecoration(
                         border: Border(
                             top: BorderSide(
                                 width: 1,
                                 color: Colors.grey[300],
                                 style: BorderStyle.solid
                             )
                         ),
                       ),

                       child: Padding(
                         padding: const EdgeInsets.only(top:10.0,bottom: 30,left: 30,right: 30),
                         child: new Wrap(
                           children: [
                             Padding(
                               padding: const EdgeInsets.only(bottom: 8),
                               child: new Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   new Text("Subtotal", style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),),
                                   new Text("\$ ${mytotal}", style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),),
                                 ],
                               ),
                             ),
                             SizedBox(height: 10,),
                             Padding(
                               padding: const EdgeInsets.only(bottom: 8),
                               child: new Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   new Text("Tax", style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),),
                                   new Text("\$ 3.55", style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),),
                                 ],
                               ),
                             ),
                             SizedBox(height: 20,),
                             Padding(
                               padding: const EdgeInsets.only(bottom: 8),
                               child: new Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   new Text("TOTAL", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),
                                   new Text("\$ ${mytotal + 3.55}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),
                                 ],
                               ),
                             ),

                             SizedBox(height: 40,),
                             GestureDetector(
                               onTap: (){
                                 Navigator.of(context).push(
                                     MaterialPageRoute(
                                         builder: (_) => PaymentChekout(cartProduct: productList,)
                                     )
                                 );
                               },
                               child: Container(
                                 width: 500,
                                 height: 45,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25),
                                   color: Color(0xff16CF8C),
                                 ),

                                 child: Center(child: new Text("Buy Now", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700), textAlign: TextAlign.center,)),
                               ),
                             )
                           ],
                         ),
                       ),
                     )
                   ],
                 ),
               ),



             ],
           ),
         ),
       ));
  }

  CreateListviewItems(BuildContext context, AsyncSnapshot snapshot) {
    productList = snapshot.data;


    if( productList !=null) {
      mtotal = productList.length;
      return ListView.builder(
        itemCount: productList.length,
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 25, bottom: 2),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: new Container(
                          width: 77,
                          height: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  // image: AssetImage("assets/images/image2.png")
                                  image: NetworkImage(
                                      productList[index].productImages)
                              )
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      new Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text("${productList[index].name}",
                              style: TextStyle(color: Color(0xff666363),
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16),),
                            new SizedBox(height: 4,),
                            new Text('\$${productList[index].price}',
                              style: TextStyle(color: Color(0xff666363),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,),),
                            Divider(),
                            new Text("Size: ${productList[index].sizes}",
                              style: TextStyle(color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal),),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                new Container(
                  child: new Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (productList[index].counter > 1) {
                            _decreasePrice(productList[index], index);
                          }
                        },
                        child: new Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: new Text("-", style: TextStyle(
                                color: Color(0xff6C1682), fontSize: 15),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: new Text(
                          "${productList[index].counter}", style: TextStyle(
                            color: Color(0xff6C1682),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal),),
                      ),
                      GestureDetector(
                        onTap: () {
                          _increasePrice(productList[index], index);
                        },
                        child: new Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color(0xff6C1682),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(child: new Text("+",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.center,)),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          );
        },

      );
    }
    return Center(child: CircularProgressIndicator(),);
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
}