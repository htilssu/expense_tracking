import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/domain/repository/repository.dart';

abstract class UserRepository implements Repository<User, String> {
  Future<User?> findByEmail(String email);
}
