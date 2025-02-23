import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/entity/timestamp_entity.dart';

class User extends BaseTimeStampEntity {
  late String id;
  late String fullName;
  late String email;
  late String firstName;
  late String lastName;
  late String avatar;
  List<Category> categories = [];

  User(this.id, this.fullName, this.email, this.firstName, this.lastName,
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

  @override
  List<Object?> get props =>
      [id, email, firstName, lastName, avatar, categories];
}
