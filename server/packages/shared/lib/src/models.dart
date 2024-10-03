import 'package:db/db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@Freezed()
class Order with _$Order implements OrderView {
  const factory Order({
    required int id,
    required String fio,
    required String car_number,
    required String cargo_name,
    required double volume,
    required String status,
  }) = _Order;

  factory Order.fromJson(Map<String, Object?> json)
      => _$OrderFromJson(json);

  factory Order.fromDb(OrderView dbOrder) => Order(
    id: dbOrder.id,
    fio: dbOrder.fio,
    car_number: dbOrder.car_number,
    cargo_name: dbOrder.cargo_name,
    volume: dbOrder.volume,
    status: dbOrder.status);
}
