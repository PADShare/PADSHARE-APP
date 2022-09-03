import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:padshare/Source/models/shopping/cart_product.dart';
import 'package:padshare/Source/utils/controller.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartProductHelper {

CartProductHelper._();
static final CartProductHelper db = CartProductHelper._();

static Database _database ;

Future<Database> get database async{

  if(_database !=null) return _database;

  _database = await initDb();
  return _database;
}

  initDb()async {
  String path = join(await getDatabasesPath(), "CartProductd.db");

  return await openDatabase(path,
  version: 1, onCreate: (Database db, int version)async{
    await db.execute('''
    CREATE TABLE  $tableCartProduct(
    $columnID INTEGER PRIMARY KEY UNIQUE,
    $columnName TEXT NOT NULL,
    $columnCategory TEXT NOT NULL,
    $columnBrand TEXT NOT NULL,
    $columnPrice INTEGER NOT NULL,
    $columnQuantity INTEGER NOT NULL,
    $columnProductId TEXT NOT NULL,
    $columnSize TEXT NOT NULL,
    $columnCounter INTEGER NOT NULL,
    $columnProductImage TEXT NOT NULL)
     ''');

  });

  }

 Future<List<CartProduct>> getAllProducts() async{
    var dbClient = await database;
    List<Map> maps = await dbClient.query(tableCartProduct);
    List<CartProduct> list = maps.isNotEmpty ?
        maps.map((product) => CartProduct.fromJson(product)).toList() : [];

    return list;
  }

   Future<int> updateCounter(CartProduct model) async {
  var dbClient = await database;

  await dbClient.update(
      tableCartProduct,
      model.tojson(),
      //where: '$columnID = ${model.productId}'
      where: '$columnProductId = ?',
      whereArgs: [model.productId],

  );
print("UPDATED COUNTER");

}


Future<CartProduct> getcounter(int id)async{
  var dbClient = await database;

  List<Map> maps = await dbClient.query(
    tableCartProduct,
    where: '$columnID = ? ',
    whereArgs: [id],
  );

  if(maps.length > 0){
    return CartProduct.fromJson(maps.first);
  }else{

    return null;
  }
}
  
  

Future gettotalPrice() async{
  var dbClient = await database;
  final maps = await dbClient.rawQuery('SELECT SUM($columnPrice) as Total FROM $tableCartProduct');
  return maps.toList();
}

Future addCounter(CartProduct model)async{
  var dbClient = await database;
  // db.update(
  //   'dogs',
  //   dog.toMap(),
  //   // Ensure that the Dog has a matching id.
  //   where: "id = ?",
  //   // Pass the Dog's id as a whereArg to prevent SQL injection.
  //   whereArgs: [dog.id],
  // );

  await dbClient.rawUpdate('UPDATE $tableCartProduct SET counter = ? WHERE id = ?', [model.counter, 0]);
 // await dbClient.update(
 //    tableCartProduct,
 //    model.tojson(),
 //    // Ensure that the Dog has a matching id.
 //    where: "$columnProductId = ?",
 //    // Pass the Dog's id as a whereArg to prevent SQL injection.
 //    whereArgs: [model.productId],
 //  );
}

  insert(CartProduct model) async {
    var dbClient = await database;


    // await dbClient.insert(
    //   tableCartProduct,
    //   model.tojson(),
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    //   // ConflictAlgorithm.replace
    // );
    //
  // dbClient.rawInsert('INSERT INTO account (id, name, phone, address) VALUES (1234, 'John Doe', '+15125551212', '123 Main St.')
  // ON CONFLICT (id) DO NOTHING')
    //SELECT  MAX(id)+1
    var maxIdResult = await dbClient.rawQuery("SELECT  $columnProductId as last_inserted_id FROM $tableCartProduct");

    print("IDDD ${maxIdResult.length}");
    print("ROWID${model.productId}");

    if(maxIdResult.length == 0){
      await dbClient.insert(
        tableCartProduct,
          model.tojson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
          // ConflictAlgorithm.replace
        );

    } else {
      var id = maxIdResult.first["last_inserted_id"];
      if( id == model.productId){
        return;
      }else{
        await dbClient.insert(
          tableCartProduct,
          model.tojson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
          // ConflictAlgorithm.replace
        );
      }
    }


    // if( id == model.productId){
    //   return;
    // }else{
    //   // await dbClient.insert(
    //   //   tableCartProduct,
    //   //   model.tojson(),
    //   //   conflictAlgorithm: ConflictAlgorithm.replace,
    //   //   // ConflictAlgorithm.replace
    //   // );
    // }

    // await dbClient.rawInsert(
    //   'INSERT INTO $tableCartProduct($columnID,$columnName,$columnCategory,$columnBrand,$columnPrice,$columnQuantity,$columnProductId,$columnSize,$columnProductImage) VALUES(?,?,?,?,?,?,?,?,?)',
    //     [columnID,columnName,columnCategory,columnBrand,columnPrice,columnQuantity,columnProductId,columnSize,columnProductImage]);

}}