import 'package:expense_tracking/domain/entity/timestamp_entity.dart';

class Category extends BaseTimeStampEntity {
  static List<Category> get defaultCategories => [
        Category('Ăn uống', 'user', 'expense', icon: 'food'),
        Category('Di chuyển', 'user', 'expense', icon: 'transport'),
        Category('Nhà cửa', 'user', 'expense', icon: 'house'),
        Category('Xe cộ', 'user', 'expense', icon: 'car'),
        Category('Con cái', 'user', 'expense', icon: 'baby'),
        Category('Mua sắm', 'user', 'expense', icon: 'shopping'),
        Category('Giải trí', 'user', 'expense', icon: 'entertainment'),
        Category('Du lịch', 'user', 'expense', icon: 'travel'),
        Category('Sức khỏe', 'user', 'expense', icon: 'health'),
        Category('Học vấn', 'user', 'expense', icon: 'education'),
        Category('Kinh doanh', 'user', 'expense', icon: 'business'),
        Category('Quà tặng', 'user', 'expense', icon: 'gift'),
        Category('Bảo hiểm', 'user', 'expense', icon: 'insurance'),
        Category('Phí dịch vụ', 'user', 'expense', icon: 'service'),
        Category('Chi phí khác', 'user', 'expense', icon: 'other'),
        Category('Lương', 'user', 'income', icon: 'salary'),
        Category('Thưởng', 'user', 'income', icon: 'bonus'),
        Category('Tiền lãi', 'user', 'income', icon: 'interest'),
        Category('Bán đồ', 'user', 'income', icon: 'sell'),
        Category('Thu nhập khác', 'user', 'income', icon: 'other'),
      ];

  late final String? id;
  final String name;
  final String? icon;
  final String type;
  final int amount = 0;
  final int budget = 0;
  final String user;

  Category(
    this.name,
    this.user,
    this.type, {
    this.id,
    this.icon,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      map['name'] as String,
      map['user'] as String,
      map['type'] as String,
      id: map['id'] as String?,
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
}
