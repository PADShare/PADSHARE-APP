import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamWallet extends StatefulWidget{
  String team;
  TeamWallet(this.team);

  @override
  _TeamWalletState createState() => _TeamWalletState();
}

class _TeamWalletState extends State<TeamWallet> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var orientation = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, size: 30, color: Colors.white,),
        ),
      ),
      backgroundColor: Color(0xffF4F6FE),
      body:  new Container(
        // child:  isLoading ? Center(child: CircularProgressIndicator(),) :  teamUser(),

        child: new Column(
          children: [
            Expanded(flex: orientation ? 8 : 5, child: new Container(

              width: MediaQuery.of(context).size.width,
              height: 258,
              decoration: BoxDecoration(
                  color: Color(0xff692CAB),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(49),
                    bottomRight: Radius.circular(49),
                  ),
                  boxShadow:[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0,4)
                    )
                  ]
              ),

              child: new Column(
                children: [
                  SizedBox(height: orientation ? 13 :40,),
                  new Padding(padding: const EdgeInsets.only(top: 30),
                    child: Container(
                        child: new Column(
                          children: [
                            new Text(widget.team, style: GoogleFonts.roboto(color: Color(0xffFFFFFF) , fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: new Text("240,000",style: GoogleFonts.roboto(color: Color(0xffFFFFFF) , fontSize: 24, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal) ),
                            )
                          ],
                        )
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:1.0, left: 60,right: 60),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            new RaisedButton(
                              onPressed: (){},
                              color: Colors.transparent,
                              disabledElevation: 0,
                              focusElevation: 0,
                              focusColor: Colors.transparent,
                              autofocus: false,
                              highlightColor: Colors.transparent,
                              highlightElevation: 0,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              // splashColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              elevation: 0,
                              child: new Container(
                                width: 49,
                                height: 49,
                                decoration: BoxDecoration(
                                  color: Color(0xffFFFFFF).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/plusIcon.png"),
                                    fit: BoxFit.scaleDown
                                  )
                                ),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text("Contribute", style: GoogleFonts.roboto(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            new RaisedButton(
                              onPressed: (){},
                              color: Colors.transparent,
                              disabledElevation: 0,
                              focusElevation: 0,
                              focusColor: Colors.transparent,
                              autofocus: false,
                              highlightColor: Colors.transparent,
                              highlightElevation: 0,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              // splashColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              elevation: 0,
                              child: new Container(
                                width: 49,
                                height: 49,
                                decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/giveIcon.png"),
                                        fit: BoxFit.scaleDown
                                    )
                                ),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text("Donate", style: GoogleFonts.roboto(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),),
                            )
                          ],
                        ),
                      ],
                    )
                  ),

                ],
              ),
            ),),

            Expanded(flex: 7, child: new Container(
              // color: Colors.blue,
              // child: isLoading ? Center(child: CircularProgressIndicator(),) :  teamUser(),
              child:myListItems(context)
            ),)
          ],
        ),


      ),
    );
  }

  Widget myListItems(context){

    return Wrap(

      children: [
        new Column(
          children: [
            SizedBox(height: 30,),
            new Container(

              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
              ),
              width: MediaQuery.of(context).size.width * .85,
              height: 68,
              child: Padding(
                padding: const EdgeInsets.only(top:10,bottom: 10, left:30, right:30),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: new Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 40),
                            child: Image.asset("assets/images/activelist.png",fit: BoxFit.contain,),
                          ),
                          new Container(
                            child:  new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Text("Contribution by isaac", style: GoogleFonts.roboto(color: Color(0xff000444),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 10
                                ) ),
                                SizedBox(height: 3,),
                                new Text("2nd/06/2020", style: GoogleFonts.roboto(color: Color(0xff324CFE),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 8
                                ) ),
                                SizedBox(height: 3,),
                                new Text("12:00pm", style: GoogleFonts.roboto(color: Color(0xff8A8A8C),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 8
                                ) ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    new Text("+ 370,000",style: GoogleFonts.roboto(color: Color(0xff000444),
                        fontStyle: FontStyle.normal, fontWeight: FontWeight.w700, fontSize: 10))
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            new Container(

              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
              ),
              width: MediaQuery.of(context).size.width * .85,
              height: 68,
              child: Padding(
                padding: const EdgeInsets.only(top:10,bottom: 10, left:30, right:30),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: new Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 40),
                            child: Image.asset("assets/images/DonationFailed.png",scale: 1.5,),
                          ),
                          new Container(
                            child:  new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Text("Donation made out", style: GoogleFonts.roboto(color: Color(0xff000444),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 10
                                ) ),
                                SizedBox(height: 3,),
                                new Text("2nd/06/2020", style: GoogleFonts.roboto(color: Color(0xff324CFE),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 8
                                ) ),
                                SizedBox(height: 3,),
                                new Text("12:00pm", style: GoogleFonts.roboto(color: Color(0xff8A8A8C),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 8
                                ) ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    new Text("+ 370,000",style: GoogleFonts.roboto(color: Color(0xff000444),
                        fontStyle: FontStyle.normal, fontWeight: FontWeight.w700, fontSize: 10))
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            new Container(

              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
              ),
              width: MediaQuery.of(context).size.width * .85,
              height: 68,
              child: Padding(
                padding: const EdgeInsets.only(top:10,bottom: 10, left:30, right:30),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: new Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 40),
                            child: Image.asset("assets/images/activelist.png",fit: BoxFit.contain,),
                          ),
                          new Container(
                            child:  new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Text("Contribution by Josh", style: GoogleFonts.roboto(color: Color(0xff000444),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 10
                                ) ),
                                SizedBox(height: 3,),
                                new Text("2nd/06/2020", style: GoogleFonts.roboto(color: Color(0xff324CFE),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 8
                                ) ),
                                SizedBox(height: 3,),
                                new Text("12:00pm", style: GoogleFonts.roboto(color: Color(0xff8A8A8C),
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 8
                                ) ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    new Text("+ 370,000",style: GoogleFonts.roboto(color: Color(0xff000444),
                        fontStyle: FontStyle.normal, fontWeight: FontWeight.w700, fontSize: 10))
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}