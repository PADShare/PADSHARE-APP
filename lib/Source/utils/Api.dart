
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:padshare/Source/models/teams/teamusers_model.dart';
import 'package:padshare/Source/models/weeks_model.dart';

class API{
  
   static Future<List> getDates() async{
     int mIfCounter = 0;

     http.Response response = await http.get(
         Uri.parse('https://6074dd06066e7e0017e7a659.mockapi.io/api/weeksdata/weeksDate'), headers: {
        //  Uri.parse(' https://padshare.herokuapp.com/api/payments/padbank/'), headers: {
           "Accept":"application/json"
     });
     //List weeksdata = json.encode(response.body);

     if(response.statusCode == 200){

       List<WeeksModel> weeksModel;
       weeksModel = (json.decode(response.body) as List)
           .map((e) => WeeksModel.fromJson(e))
           .toList();

       print('${weeksModel[0].id}');

       // if(mIfCounter < weeksModel.length - 1){
       //
       //   mIfCounter++;
       //   print( '${weeksModel[mIfCounter].id}');
       // } else{
       //
       //   mIfCounter = 0;
       // }

      return weeksModel;

     }else{

       throw Exception('Failed to load Data');
     }


   }


   Future gettotalStaticts()async{
     final response = await http.get(
         Uri.https('padshareapp.com','/api/payments/padbank/'), headers: {
       "Accept":"application/json",
       "Content-Type": "application/json",
     }
     );

     if( response.statusCode == 200 ){

       var jsonObject = json.decode(response.body);

       return jsonObject;

     }

   }

   static Future<List> getTeamUsers() async{

     final response = await http.get(Uri.parse("https://6074dd06066e7e0017e7a659.mockapi.io/api/weeksdata/users"), headers: {"Accept":"application/json"});
      var responseJson = json.encode(response.body);
     if(response.statusCode == 200){
     List<TeamUsersModel> teamusers = (json.decode(response.body) as List).map((e) => TeamUsersModel.fromJson(e)).toList();
     print("USERTEAM" + teamusers[0].avatar);
     return teamusers;
     }
   }

}