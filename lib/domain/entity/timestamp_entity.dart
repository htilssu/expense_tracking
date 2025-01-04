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
    var createdAtString = map['createdAt'] as String?;
    var updatedAtString = map['updatedAt'] as String?;

    if (createdAtString != null) {
      createdAt = DateTime.parse(createdAtString);
    }

    if (updatedAtString != null) {
      updatedAt = DateTime.parse(updatedAtString);
    }
  }
}
