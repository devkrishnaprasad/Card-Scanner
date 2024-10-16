// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LoclDatabase {
  Database? _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "cardDetails.db"),
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE IF NOT EXISTS cardData(
          id INTEGER PRIMARY KEY,
          name TEXT,
          phoneNumber TEXT,
          address TEXT ,
          email TEXT 
        )
      ''');
      },
      version: 1,
    );
  }

  Future<void> insertData(CardData data) async {
    try {
      // Attempt to insert the data
      int result = await _database!.insert(
        'cardData',
        data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (result != -1) {
        // The insertion was successful
        log("Data added..");
      } else {
        log("Data adding failed..");
      }
    } catch (e) {
      // Handle any exceptions that might occur during the insertion
      log("Data adding failed $e");
    }
  }

  Future<List<CardData>> fetCardData() async {
    final List<Map<String, dynamic>> maps = await _database!.query('cardData');
    return List.generate(
      maps.length,
      (i) {
        return CardData(
            id: maps[i]['id'],
            name: maps[i]['name'],
            email: maps[i]['email'],
            address: maps[i]['address'],
            phoneNumber: maps[i]['phoneNumber']);
      },
    );
  }

  Future<void> deleteData(String id) async {
    try {
      await _database!.delete(
        'favorite',
        where: 'attraction_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      log('Error while removing $e');
    }
  }

  Future<bool> checkAttractionIdExists(String attractionId) async {
    try {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'favorite',
        where: 'attraction_id = ?',
        whereArgs: [attractionId],
      );

      return maps.isNotEmpty;
    } catch (e) {
      log("Error occurred while checking attractionId existence: $e");
      return false;
    }
  }
}

class CardData {
  final int? id;
  final String name;
  final String email;
  final String address;
  final String phoneNumber;

  CardData(
      {this.id,
      required this.name,
      required this.email,
      required this.address,
      required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber
    };
  }
}
