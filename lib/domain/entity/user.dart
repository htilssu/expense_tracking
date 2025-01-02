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

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      ...super.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> data) {
    try {
      return User(
        data['id'],
        '${data['lastName']} ${data['firstName']}',
        data['email'],
        data['firstName'],
        data['lastName'],
        avatar: data['avatar'],
      )..timeStampFromMap(data);
    } catch (e) {
      throw Exception('Invalid User data');
    }
  }
}
