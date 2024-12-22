import 'package:expense_tracking/domain/entity/timestamp_entity.dart';

class User extends BaseTimeStampEntity {
  late String id;
  late String fullname;
  late String email;
  late String firstName;
  late String lastName;

  User(this.id, this.fullname, this.email, this.firstName, this.lastName);
}