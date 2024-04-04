import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'EventItem.dart';

class SavedList {
  // final String serviceName;
  // final dynamic dynamicObject;
  // final String icon;
  // SavedList({
  //   required this.serviceName,
  //   required this.dynamicObject,
  //   required this.icon,
  // });
  static bool findId(String id){
    bool isSaved;
    saveList.any((item) => item.item.id == id)
        ? isSaved = true
        : isSaved = false;
    return isSaved;
  }
  static bool addToSave(bool _isSaved ,EventItem eventItem) {
    _isSaved = !_isSaved;

    if (_isSaved) {
      print('savvvveeeeddd');
      saveList.add(eventItem);

      addItem(eventItem.item.id,eventItem.serviceName);
    } else {
      print('reemooooove');
      saveList.removeWhere((item) =>
      item.serviceName == eventItem.serviceName &&
          item.item == eventItem.item &&
          item.icon == eventItem.icon);
      removeItem(eventItem.item.id,eventItem.serviceName);
    }
    return _isSaved;
    print(saveList);
  }

  static Future<void> addItem(String itemId,String serviceName) async {
    try {
      // Retrieve the document
      DocumentSnapshot documentSnapshot = await userProfileDoc
          .collection("saveItems")
          .doc(serviceName)
          .get();

      if (documentSnapshot.exists) {
        // Check if the item already exists in the 'items' array
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        var items = data['items'] as List<dynamic>;
        // print(items);
        if (items.contains(itemId)) {
          print('Item already exists.');
          return;
        }
      }

      // Add the item to the 'items' array
      await userProfileDoc
          .collection('saveItems')
          .doc(serviceName)
          .update({
        'items': FieldValue.arrayUnion([itemId])
      });

      print('Item added successfully.');
    } catch (e) {
      print('Error adding item: $e');
    }
  }

   static Future<void> removeItem(String itemId,String serviceName) async {
    try {
      // Retrieve the document
      DocumentSnapshot documentSnapshot = await userProfileDoc
          .collection("saveItems")
          .doc(serviceName)
          .get();

      if (documentSnapshot.exists) {
        // Check if the item already exists in the 'items' array
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        var items = data['items'] as List<dynamic>;
        // print(items);
        if (!items.contains(itemId)) {
          print('Item does not exist.');
          return;
        }
      }

      // Remove the item from the 'items' array
      await userProfileDoc
          .collection('saveItems')
          .doc(serviceName)
          .update({
        'items': FieldValue.arrayRemove([itemId])
      });

      print('Item removed successfully.');
    } catch (e) {
      print('Error removing item: $e');
    }
  }
}