abstract class BaseTimeStampEntity {
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  void updateTimeStamp() {
    updatedAt = DateTime.now();
  }

  void timeStampFromMap(Map<String, dynamic> map) {
    createdAt = DateTime.parse(map['createdAt'] as String);
    updatedAt = DateTime.parse(map['updatedAt'] as String);
  }
}
