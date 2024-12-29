import 'package:expense_tracking/domain/entity/timestamp_entity.dart';

class User extends BaseTimeStampEntity {
  late String id;
  late String fullname;
  late String email;
  late String firstName;
  late String lastName;
  late String avatar;

  User(this.id, this.fullname, this.email, this.firstName, this.lastName,
      {this.avatar = ''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
    };
  }

  factory User.fromMap(Map<String, dynamic> data) {
    try {
      return User(
        data['id'],
        '${data['firstName']} ${data['lastName']}',
        data['email'],
        data['firstName'],
        data['lastName'],
        avatar: data['avatar'],
      );
    } catch (e) {
      throw Exception('Invalid User data');
    }
  }
}
