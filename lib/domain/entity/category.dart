import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/entity/timestamp_entity.dart';
import 'package:uuid/uuid.dart';

class Category extends BaseTimeStampEntity implements Equatable {
  static List<Category> get defaultCategories => [
        Category('Ăn uống', 0, 0, 'expense', 'user', icon: 'food'),
        Category('Di chuyển', 0, 0, 'expense', 'user', icon: 'transport'),
        Category('Nhà cửa', 0, 0, 'expense', 'user', icon: 'house'),
        Category('Xe cộ', 0, 0, 'expense', 'user', icon: 'car'),
        Category('Con cái', 0, 0, 'expense', 'user', icon: 'baby'),
        Category('Mua sắm', 0, 0, 'expense', 'user', icon: 'shopping'),
        Category('Giải trí', 0, 0, 'expense', 'user', icon: 'entertainment'),
        Category('Du lịch', 0, 0, 'expense', 'user', icon: 'travel'),
        Category('Sức khỏe', 0, 0, 'expense', 'user', icon: 'health'),
        Category('Học vấn', 0, 0, 'expense', 'user', icon: 'education'),
        Category('Kinh doanh', 0, 0, 'expense', 'user', icon: 'business'),
        Category('Quà tặng', 0, 0, 'expense', 'user', icon: 'gift'),
        Category('Bảo hiểm', 0, 0, 'expense', 'user', icon: 'insurance'),
        Category('Phí dịch vụ', 0, 0, 'expense', 'user', icon: 'service'),
        Category('Chi phí khác', 0, 0, 'expense', 'user', icon: 'other'),
        Category('Lương', 0, 0, 'income', 'user', icon: 'salary'),
        Category('Thưởng', 0, 0, 'income', 'user', icon: 'bonus'),
        Category('Tiền lãi', 0, 0, 'income', 'user', icon: 'interest'),
        Category('Bán đồ', 0, 0, 'income', 'user', icon: 'sell'),
        Category('Thu nhập khác', 0, 0, 'income', 'user', icon: 'other'),
      ];

  late String id = const Uuid().v4();
  final String name;
  final String? icon;
  final String type;
  int amount = 0;
  int budget = 0;
  late String user;

  Category(
    this.name,
    this.amount,
    this.budget,
    this.type,
    this.user, {
    this.icon,
  });

  Category.withId(
    this.id,
    this.name,
    this.amount,
    this.budget,
    this.type,
    this.user, {
    this.icon,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category.withId(
      map['id'] as String,
      map['name'] as String,
      map['amount'],
      map['budget'],
      map['type'] as String,
      map['user'] as String,
      icon: map['icon'] as String?,
    )..timeStampFromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type,
      'amount': amount,
      'budget': budget,
      'user': user,
      ...super.toMap(),
    };
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, icon: $icon, type: $type, amount: $amount, budget: $budget, user: $user}';
  }

  @override
  List<Object?> get props => [id, name, type];
}
