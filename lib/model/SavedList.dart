
import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/constant.dart';
import 'dynamic_item_model.dart';

class SavedList {
  final String serviceName;
  final dynamic dynamicObject;
  final String icon;
  SavedList({
    required this.serviceName,
    required this.dynamicObject,
    required this.icon,
  });
  Map<String, String> convertServiceName = {
    'volunteerOp': 'فرصة تطوعية',
    'conferences': 'مؤتمر',
    'studentActivities': 'نشاط طلابي',
    'cources': 'دورة',
    'workshops': 'ورشة عمل',
    'otherEvents': 'أخرى',
    'studyGroubs': 'جلسة مذاكرة',
  };
  static bool findId(String id) {
    bool isSaved = false;
    saveList.any((item) => item.item.id == id)
        ? isSaved = true
        : isSaved = false;
    return isSaved;
  }

  bool addToSave(bool isSaved) {
    isSaved = !isSaved;
// convertServiceName[eventItem.serviceName].toString()
    if (isSaved) {
      print('savvvveeeeddd');

      saveList.add(
        DynamicItemModel(
            serviceName: convertServiceName[serviceName].toString(),
            item: dynamicObject,
            icon: icon),
      );

      addItem(dynamicObject.id.toString());
    } else {
      print('reemooooove');
      saveList.removeWhere((item) =>
          item.serviceName == convertServiceName[serviceName].toString() &&
          item.item.id == dynamicObject.id &&
          item.icon == icon);
      removeItem(dynamicObject.id.toString());
    }
    return isSaved;
  }

  Future<void> addItem(String itemId) async {
    try {
      // Retrieve the document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc(serviceName).get();

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
      await userProfileDoc.collection('saveItems').doc(serviceName).update({
        'items': FieldValue.arrayUnion([itemId])
      });

      print('Item added successfully.');
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  Future<void> removeItem(String itemId, {bool isSaveScreen = false}) async {
    try {
      String doc = isSaveScreen ? getKeyFromValue(serviceName) : serviceName;
      // Retrieve the document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc(doc).get();

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
      await userProfileDoc.collection('saveItems').doc(doc).update({
        'items': FieldValue.arrayRemove([itemId])
      });

      print('Item removed successfully.');
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  String getKeyFromValue(String value) {
    for (var entry in convertServiceName.entries) {
      if (entry.value == value) {
        print('rmrmrmrmmrm');
        print(entry.key);
        print(entry.value);
        return entry.key;
      }
    }
    return ''; // If no matching key is found
  }
}
