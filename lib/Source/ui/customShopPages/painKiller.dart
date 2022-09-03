import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/models/shopping/product.dart';
import 'package:padshare/Source/ui/PadsSHOP/shopDetails.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class PainKilllersPage extends StatefulWidget{

  @override
  _PainKilllersPageState createState() => _PainKilllersPageState();
}

class _PainKilllersPageState extends State<PainKilllersPage> {
  List<Product> myproduct = [];

  displayLoading(){
    // return  Future.delayed(Duration.zero, () => showDiaLogs());
  }

  bool isloading = true;

  Color _selectedColor = Color(0xff388774);

  Color _notSelectedColor = Color(0xffFFFFFF);

  Orientation _orientationBuilder = Orientation.landscape;

  var selected = false;

  List<DocumentSnapshot> padsShop;

  @override
  void initState() {
    // TODO: implement initState
    getallProducts();
    super.initState();
    displayLoading();
  }

  getallProducts()async{
    await  _firestore.collection("products")
        .where("category", isEqualTo: "pain Killers")
        .get()
        .then((snapshot) {
      // Product product =
      setState(() {
        padsShop =  snapshot.docs;

      });

      Future.delayed(Duration(seconds: 1)).then((value){
        setState(() {
          isloading = false;
        });
      });

      // padsShop.forEach((element) {
      //   var cartProd = Product.fromJson(json.decode(json.encode(element)));
      //   myproduct.add(cartProd);
      // });

      // print("product::12");
      // print(myproduct);
      print("product::");
      // print(padsShop[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(

      body: NestedScrollView(
        headerSliverBuilder: (context,bool nbool){
          return <Widget>[

          ];
        },
        body: isloading ? Center(child: CircularProgressIndicator(),) : new Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20,right: 20, top:10),
          // child: new Text("DATA"),
          child: padsShop.length == 0 ?
          // Center(child: new Text("No Data to Display..", style: GoogleFonts.roboto(fontWeight: FontWeight.w200, color: Colors.black54, fontSize: 14, fontStyle: FontStyle.italic),),)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  // color: Colors.cyan.shade200
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 160,),
                  new Text("Information!", style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 25),),
                  SizedBox(height: 13,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: new Text("This service is not yet available.Kindly check back later.", textAlign: TextAlign.center, style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 19),),
                  ),
                ],
              ),
            ),
          )
              : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8
            ),
            itemCount: padsShop.length,
            itemBuilder: (BuildContext context, int index){
              // return Text("DATA");
              return StorListItems(context, padsShop[index].data()['productImages'][0], padsShop[index].data()['name'] ??"", "${padsShop[index].data()['price'] ?? ""}/=", "4.8", padsShop[index]);
            },
          ),
        ) ,
        // body: new Container(
        //   width: MediaQuery.of(context).size.width,
        //   padding: EdgeInsets.only(left: 20,right: 20, top:10),
        //   child: GridView.count(crossAxisCount: 3,  mainAxisSpacing: 10, childAspectRatio: 0.8, children: <Widget>[
        //
        //     StorListItems(context, "assets/images/image3.png", "StayFree Pads", "5000/=", "4.8"),
        //     StorListItems(context, "assets/images/image2.png", "Whisper Pads", "5000/=", "3.8"),
        //     StorListItems(context, "assets/images/image5.png", "FreeSpirit Pads", "5000/=", "5.8"),
        //     StorListItems(context, "assets/images/image4.png", "Always Ultra", "4000/=", "4.8"),
        //     StorListItems(context, "assets/images/image1.png", "Always Infinit", "5000/=", "4.8"),
        //     StorListItems(context, "assets/images/image2.png", "Whisper Pads", "5000/=", "3.8"),
        //
        //   ],),
        // ),
      ),
    );

  }

  StorListItems(context, String image, title, price, rating, index) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(
                builder:  (_) => new ShopDetails(product: index)
            )
        );
        setState(() {
          selected = true;
        });
      },
      child: new Container(

          width: MediaQuery
              .of(context)
              .size
              .width,
          margin: EdgeInsets.only(right: 12, top: 10),
          decoration: BoxDecoration(
              color: Color(0xfff8f9fa),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topLeft:  Radius.circular(12),
                topRight: Radius.circular(12),
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
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(
                  children: <Widget>[
                    Expanded(

                      child: Container(
                          decoration: BoxDecoration(
                              color:   _notSelectedColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12)
                              )
                          ),
                          child: image == null ? Image.asset(image,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * .2673, height: MediaQuery
                                .of(context)
                                .size
                                .width * .2,
                            alignment: Alignment.center,) : Image.network(image,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * .2673, height: MediaQuery
                                .of(context)
                                .size
                                .width * .2,
                            alignment: Alignment.center,) ),
                      flex: 2,

                    ),
                  ],
                ),
              ),





              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Color(0xfff8f9fa),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .width * .108,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(title, style: TextStyle(
                                  color: Color(0xff929496),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300),textAlign: TextAlign.start,),
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: new Text(price,
                                    style: GoogleFonts.openSans(color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),),
                                ),

                                new Container(
                                  width:  MediaQuery.of(context).size.width *.06,
                                  height: MediaQuery.of(context).size.height *.01,
                                  decoration: BoxDecoration(
                                    // color: Colors.orange[900],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1.0, right: 1.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Image.asset("assets/images/heart.png", color: Color(
                                            0xffc9c5c0) ,width: 8,scale: 0.5,)
                                        // Icon(, color: Color(0xffED8A19),
                                        //   size: 8,),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          )
      ),
    );
  }

  Widget showDiaLogs(){

    AlertDialog alertDialog = AlertDialog(
      title: Text("Information"),
      content: Text("This service is not yet available.Kindly check back later."),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);

            // Navigator.push(context, MaterialPageRoute(builder: (_)=>ManageAddress()));
          },
        )
      ],
    );

    showDialog(context: context, builder: (_)=> alertDialog);
  }
}