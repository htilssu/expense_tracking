import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class BaseTimeStampEntity extends Equatable {
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  void updateTimeStamp() {
    updatedAt = DateTime.now();
  }

  void timeStampFromMap(Map<String, dynamic> map) {
    //create datetime from timestamp;
     createdAt = (map['createdAt'] as Timestamp).toDate();
     updatedAt = (map['updatedAt'] as Timestamp).toDate();
  }
}
