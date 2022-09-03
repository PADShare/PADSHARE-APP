import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/models/shopping/cart_product.dart';
import 'package:padshare/Source/models/shopping/cartview_model.dart';
import 'package:padshare/Source/models/shopping/product.dart';
import 'package:padshare/Source/ui/PadsSHOP/shopingCat.dart';
import 'package:padshare/Source/utils/cart_productHelper.dart';

class ShopDetails extends StatefulWidget{

  QueryDocumentSnapshot product;

  ShopDetails({this.product, });

  @override
  _ShopDetailsState createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {

// List<Product> myproduct = new List<Product>.empty(growable: true);
  List<Product> myproduct = [];
  List<CartProduct>  productList =[];
ValueSetter<Product> _valueSetter;

  List<Product> myproducts = List<Product>();

  Future<List<CartProduct>> _getallProductss()async{
    var dbHelper = CartProductHelper.db;
    await  dbHelper.getAllProducts().then((result){
      print(result);
      // setState(() {
      //   cartprod = result;
      // });

     setState(() {
       productList = result;
     });





    });
    return productList;
  }

  @override
  void initState() {
    // TODO: implement initState
    _getallProductss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // print(widget.product);

    return new Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        leading: new GestureDetector(onTap: (){
          Navigator.of(context).pop();
        },

            child: Icon(Icons.arrow_back, color: Color(0xff692CAB),size: 25,)),
        elevation: 0,
        title: Center(child: new Text("Product", style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal,fontWeight: FontWeight.w700, color: Color(0xff6C1682)),textAlign: TextAlign.center,)),
        actions: [
          FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: (){},
              child: Icon(Icons.favorite, color: Colors.grey, )),

          Padding(
            padding: const EdgeInsets.only(right:20.0),
            child: GestureDetector(
              onTap: ()async{
               //  await Navigator.push(context,
               //    MaterialPageRoute(builder: (_)=> ShoppingCat())
               // );
               //  Get.put(ShoppingCat());
                 Get.to(() => ShoppingCat());
              },
              // child: Icon(Icons.shopping_cart_sharp, size: 25, color: Colors.orangeAccent,),
              // child: Icons.badge,
              child: Badge(
                position: BadgePosition.topEnd(top: 2, end: -8),
                badgeContent: new Text("${productList.length}", style: GoogleFonts.roboto(color:Colors.white),),
                child:Icon(Icons.shopping_cart_sharp, size: 30, color: Colors.orangeAccent,),
              ),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xffF4F6FE),
      body: new Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: new Container(
              height: 390,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(49),
                  bottomLeft: Radius.circular(49),
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey[300],
                      // spreadRadius: 2,
                      offset: Offset(0,7)
                  )
                ]
              ),
              child: new Column(
                children: [



                  Padding(
                    padding: const EdgeInsets.only(top:60.0, left: 50, right:50, bottom:30),
                    child: new Container(
                      width: 200,
                      height: 200,
                      child: Image.network(widget.product.data()['productImages'][0], fit: BoxFit.cover, width: 200,),
                    ),
                  ),
                //   new Padding(padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                //    child: Image.asset("assets/images/image2.png", fit: BoxFit.cover, width: 200,),
                // // child: Image.network(widget.product.data()['productImages'][0], fit: BoxFit.cover, width: 200,),
                //
                //   ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8,left: 35,right: 20),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Container(
                          child:new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8,right: 8, bottom: 4),
                                child: new Text(widget.product.data()['name'], style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff666363),fontStyle: FontStyle.normal),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0,right: 8),
                                child: new Text(widget.product.data()['category'], style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff666363),fontStyle: FontStyle.normal),),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Row(
                                  children: [
                                    new Container(
                                       width: 20,
                                       height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Color(0xff692CAB), width: 1, style: BorderStyle.solid)
                                      ),
                                      child: Center(
                                        child: InkWell(
                                         // child: Icon(Icons.minimize_outlined, size: 20,color:Color(0xff692CAB) ,),
                                          child: new Text("-", textAlign: TextAlign.center, style: TextStyle(color: Color(0xff692CAB)),),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 13,left: 13),
                                      child: InkWell(child: Center(child: new Text("2", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13, fontStyle: FontStyle.normal, color:Color(0xff692CAB) ),))),
                                    ),
                                    new Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color:Color(0xff692CAB)
                                          // border: Border.all(color: Color(0xff692CAB), width: 1, style: BorderStyle.solid)
                                      ),
                                      child: Center(child: new Text("+", textAlign: TextAlign.center, style: TextStyle(color: Color(0xffffffff)),))
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: new Text("\$ ${widget.product.data()['price']}",style: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xff666363),fontStyle: FontStyle.normal),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:20.0,left: 30,right: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  new Text("Descriprtion of the medicine  how doe  it work what and all it will do so  whag can we do with it blah blah blah, what does the medicine  mean to the patient, and what it means to the patient"
                           "Can we donate this to the patient, does the patient get an over dose and at the end of the day, why does one react to dose the way they do when we adminiater  it",
                           style: GoogleFonts.roboto(height: 2,fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal)),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Container(
                width: 65,
                height:65,
    decoration: BoxDecoration(
                      color: Color(0xff3E4347),
                      // border: Border.all(color: Color(0xff6C1682),width: 2),,
                      borderRadius: BorderRadius.circular(23),
                    ),
            child:FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        onPressed: ()async{
                          var dbhelper = CartProductHelper.db;

                           // print("cart::");
                           // await dbhelper.insert(CartProduct());
                         await dbhelper.insert(
                              CartProduct(
                                  name: widget.product.data()['name'],
                                  category: widget.product.data()['category'],
                                  brand: widget.product.data()['brand'],
                                  price: widget.product.data()['price'],
                                  quantity: widget.product.data()['quantity'],
                                  productId: widget.product.data()['productId'],
                                  sizes: widget.product.data()['sizes'][0],
                                  counter: 1,
                                  productImages: widget.product.data()['productImages'][0]
                                   ));

                          print("INSERTED");
                          setState((){});
                        },

  child: Icon(Icons.add_shopping_cart_outlined, size: 25,),



             )



            //     child: Wrap(
            //       alignment: WrapAlignment.center,
            //       children: [
            //         Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //
            //             new Container(
            //                 width: 65,
            //                 height: 60,
            //               decoration: BoxDecoration(
            //                 color: Color(0xff3E4347),
            //                 // border: Border.all(color: Color(0xff6C1682),width: 2),,
            //                 borderRadius: BorderRadius.circular(23),
            //               ),
            //               child:  FloatingActionButton(
            //                   backgroundColor: Colors.transparent,
            //                   elevation: 0,
            //
            //                   // Navigator.of(context).push(
            //                   //     MaterialPageRoute(builder: (_)=> ShoppingCat())
            //                   // );
            //                   // var data = widget.product.data();
            //                   // print(data);
            //                   // data.forEach((key, value) {
            //                   //   var cartProd = Product.fromJson(json.decode(json.encode(value)));
            //                   //
            //                   //   myproduct.add(cartProd);
            //                   //
            //                   // });
            //                   //
            //                   //   print("PRODUCT");
            //                   //   print(myproduct);
            //                   // },
            //                   child: Image.asset("assets/images/addCat.png",width: 25,),
            //                   // child: new Text(
            //                   //   "Wallet", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
            //                   // ),
            //               ),
            //             ),
            //
            //             Container(
            //
            //               child: GetBuilder<CartViewModel>(
            //                 init: CartViewModel(),
            //                 builder:(controller) => Ge(
            // //                   onPressed:() => controller.addProduct(
            // //               CartProduct(
            // //               name: widget.product.data()['name'],
            // //                 category: widget.product.data()['category'],
            // //                 brand: widget.product.data()['brand'],
            // //                 price: widget.product.data()['price'],
            // //                 quantity: widget.product.data()['quantity'],
            // //                 productId: widget.product.data()['productId'],
            // //                 sizes: widget.product.data()['sizes'][0],
            // //                 productImages: widget.product.data()['productImages'][0]
            // //
            // //             )
            // // ),
            //   onPressed: (){
            //                     print("DATQPP");
            //   },
            //                   child: Padding(
            //                     padding: const EdgeInsets.only(bottom:8.0),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //
            //                         Icon(Icons.add_shopping_cart_outlined, size: 17,),
            //                         new Text(" Add to Cart", style: TextStyle(fontSize: 13)),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             )
            //
            //           ],
            //         ),
            //       ],
            //     )

          ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
         color: Colors.transparent,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24)
            )
          ),
        ),
      ),
    );
  }
}