import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // static Future<void> createTables(sql.Database database) async {
  //   await database.execute("""CREATE TABLE products(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  //       product_name TEXT,
  //       product_price INTEGER,
  //       unique_code TEXT,
  //       tax INTEGER,
  //       createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  //     )
  //     """);
  //   await database.execute("""CREATE TABLE cart(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  //       product_name TEXT,
  //       product_price INTEGER,
  //       unique_code TEXT,
  //       tax REAL,
  //       quantity INTEGER,
  //       createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  //     )
  //     """);
  // }
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        product_name TEXT,
        product_price REAL,  -- Change INTEGER to REAL
        unique_code TEXT,
        tax REAL,  -- Change INTEGER to REAL
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        product_name TEXT,
        product_price REAL,  -- Change INTEGER to REAL
        unique_code TEXT,
        tax REAL,  -- Change INTEGER to REAL
        quantity INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'products_db.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new product
  static Future<int> createProduct(String productName, double productPrice,
      String uniqueCode, double tax) async {
    final db = await SQLHelper.db();

    final data = {
      'product_name': productName,
      'product_price': productPrice,
      'unique_code': uniqueCode,
      'tax': tax,
    };

    final id = await db.insert('products', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all products
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await SQLHelper.db();
    return db.query('products', orderBy: "id");
  }

  // Read a single product by id
  static Future<List<Map<String, dynamic>>> getProduct(int id) async {
    final db = await SQLHelper.db();
    return db.query('products', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update a product by id
  static Future<int> updateProduct(int id, String productName, int productPrice,
      String uniqueCode, int tax) async {
    final db = await SQLHelper.db();

    final data = {
      'product_name': productName,
      'product_price': productPrice,
      'unique_code': uniqueCode,
      'tax': tax,
      'createdAt': DateTime.now().toString(),
    };

    final result =
        await db.update('products', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete a product
  static Future<void> deleteProduct(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("products", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting a product: $err");
    }
  }

  //TABLE FOR THE CART AND ITS QURIES

  // static Future<void> createCartTable(sql.Database database) async {
  //   await database.execute("""CREATE TABLE cart(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  //       product_name TEXT,
  //       product_price INTEGER,
  //       unique_code TEXT,
  //       tax INTEGER,
  //       quantity INTEGER,
  //       createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  //     )
  //     """);
  // }

  static Future<int?> addToCart(String productName, double productPrice,
      String uniqueCode, double tax, int quantity) async {
    final db = await SQLHelper.db();

    // Check if the product is already in the cart
    final existingCartItem = await db.query('cart',
        where: "product_name = ? AND unique_code = ?",
        whereArgs: [productName, uniqueCode],
        limit: 1);

    if (existingCartItem.isNotEmpty) {
      // Product is already in the cart, update the quantity
      final currentQuantity = existingCartItem[0]['quantity'] as int? ?? 0;
      final updatedQuantity = currentQuantity + quantity;

      await db.update('cart', {'quantity': updatedQuantity},
          where: "product_name = ? AND unique_code = ?",
          whereArgs: [productName, uniqueCode]);

      return existingCartItem[0]['id'] as int?;
    } else {
      // Product is not in the cart, insert a new entry
      final data = {
        'product_name': productName,
        'product_price': productPrice,
        'unique_code': uniqueCode,
        'tax': tax,
        'quantity': quantity,
      };

      final id = await db.insert('cart', data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    }
  }

  static Future<Map<String, dynamic>?> getProductByBarcode(
      String barcode) async {
    final db = await SQLHelper.db();
    final result = await db.query('products',
        where: 'unique_code = ?', whereArgs: [barcode], limit: 1);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Read all items in the cart
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await SQLHelper.db();
    return db.query('cart', orderBy: "id");
  }

  static Future<void> removeFromCart(int itemId) async {
    final db = await SQLHelper.db();
    await db.delete("cart", where: "id = ?", whereArgs: [itemId]);
  }

  static Future<void> updateCartQuantity(int itemId, int quantity) async {
    final db = await SQLHelper.db();

    await db.update('cart', {'quantity': quantity},
        where: "id = ?", whereArgs: [itemId]);
  }
}
