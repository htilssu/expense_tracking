import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/entity/timestamp_entity.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Category extends BaseTimeStampEntity implements Equatable {
  static List<Category> get defaultCategories => [
        Category('Ăn uống', 0, 0, 'expense', 'user',
            icon: 'food', color: Colors.orange),
        Category('Di chuyển', 0, 0, 'expense', 'user',
            icon: 'transport', color: Colors.blue),
        Category('Nhà cửa', 0, 0, 'expense', 'user',
            icon: 'house', color: Colors.green),
        Category('Xe cộ', 0, 0, 'expense', 'user',
            icon: 'car', color: Colors.red),
        Category('Con cái', 0, 0, 'expense', 'user',
            icon: 'baby', color: Colors.pink),
        Category('Mua sắm', 0, 0, 'expense', 'user',
            icon: 'shopping', color: Colors.purple),
        Category('Giải trí', 0, 0, 'expense', 'user',
            icon: 'entertainment', color: Colors.yellow),
        Category('Du lịch', 0, 0, 'expense', 'user',
            icon: 'travel', color: Colors.teal),
        Category('Sức khỏe', 0, 0, 'expense', 'user',
            icon: 'health', color: Colors.red),
        Category('Học vấn', 0, 0, 'expense', 'user',
            icon: 'education', color: Colors.blue),
        Category('Kinh doanh', 0, 0, 'expense', 'user',
            icon: 'business', color: Colors.brown),
        Category('Quà tặng', 0, 0, 'expense', 'user',
            icon: 'gift', color: Colors.pink),
        Category('Bảo hiểm', 0, 0, 'expense', 'user',
            icon: 'insurance', color: Colors.green),
        Category('Phí dịch vụ', 0, 0, 'expense', 'user',
            icon: 'service', color: Colors.orange),
        Category('Chi phí khác', 0, 0, 'expense', 'user',
            icon: 'other', color: Colors.grey),
        Category('Lương', 0, 0, 'income', 'user',
            icon: 'salary', color: Colors.green),
        Category('Thưởng', 0, 0, 'income', 'user',
            icon: 'bonus', color: Colors.orange),
        Category('Tiền lãi', 0, 0, 'income', 'user',
            icon: 'interest', color: Colors.blue),
        Category('Bán đồ', 0, 0, 'income', 'user',
            icon: 'sell', color: Colors.purple),
        Category('Thu nhập khác', 0, 0, 'income', 'user',
            icon: 'other', color: Colors.grey),
      ];

  late String id = const Uuid().v4();
  final String name;
  final String? icon;
  final Color? color;
  final String type;
  int amount = 0;
  int budget = 0;
  late String user;

  double get percentage {
    if (amount == 0 || budget == 0) return 0;
    return (amount / budget) * 100;
  }

  int get totalAmount => amount;

  Color get defaultColor {
    switch (icon) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'house':
        return Colors.green;
      case 'car':
        return Colors.red;
      case 'baby':
        return Colors.pink;
      case 'shopping':
        return Colors.purple;
      case 'entertainment':
        return Colors.amber;
      case 'travel':
        return Colors.teal;
      case 'health':
        return Colors.redAccent;
      case 'education':
        return Colors.blueAccent;
      case 'business':
        return Colors.brown;
      case 'gift':
        return Colors.pinkAccent;
      case 'insurance':
        return Colors.green.shade700;
      case 'service':
        return Colors.deepOrange;
      case 'salary':
        return Colors.green;
      case 'bonus':
        return Colors.amber;
      case 'interest':
        return Colors.lightBlue;
      case 'sell':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  IconData get iconData {
    switch (icon) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'house':
        return Icons.home;
      case 'car':
        return Icons.directions_car;
      case 'baby':
        return Icons.child_care;
      case 'shopping':
        return Icons.shopping_cart;
      case 'entertainment':
        return Icons.movie;
      case 'travel':
        return Icons.flight;
      case 'health':
        return Icons.health_and_safety;
      case 'education':
        return Icons.school;
      case 'business':
        return Icons.business;
      case 'gift':
        return Icons.card_giftcard;
      case 'insurance':
        return Icons.security;
      case 'service':
        return Icons.miscellaneous_services;
      case 'salary':
        return Icons.attach_money;
      case 'bonus':
        return Icons.star;
      case 'interest':
        return Icons.trending_up;
      case 'sell':
        return Icons.store;
      default:
        return Icons.category;
    }
  }

  Category(
    this.name,
    this.amount,
    this.budget,
    this.type,
    this.user, {
    this.icon,
    this.color,
  });

  Category.withId(
    this.id,
    this.name,
    this.amount,
    this.budget,
    this.type,
    this.user, {
    this.icon,
    this.color,
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
      color: map['color'] != null ? Color(map['color'] as int) : null,
    )..timeStampFromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color?.value,
      'type': type,
      'amount': amount,
      'budget': budget,
      'user': user,
      ...super.toMap(),
    };
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, icon: $icon, color: $color, type: $type, amount: $amount, budget: $budget, user: $user}';
  }

  @override
  List<Object?> get props => [id, name, type];
}
