import 'package:expense_tracking/domain/entity/timestamp_entity.dart';

class User extends BaseTimeStampEntity {
  late String id;
  late String fullname;
  late String email;
  late String firstName;
  late String lastName;

  User(this.id, this.fullname, this.email, this.firstName, this.lastName);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory User.fromMap(Map<String, dynamic> data) {
    try {
      return User(
        data['id'],
        data['fullname'],
        data['email'],
        data['firstName'],
        data['lastName'],
      );
    } catch (e) {
      throw Exception('Invalid User data');
    }
  }
}