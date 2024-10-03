import 'package:stormberry/stormberry.dart';

part 'db_models.schema.dart';

@Model()
abstract class Order {
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  String get fio;

  String get car_number;

  String get cargo_name;

  double get volume;

  String get status;
}
