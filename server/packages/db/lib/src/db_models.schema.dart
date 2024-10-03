// ignore_for_file: annotate_overrides

part of 'db_models.dart';

extension DbModelsRepositories on Session {
  OrderRepository get orders => OrderRepository._(this);
}

abstract class OrderRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<OrderInsertRequest>,
        ModelRepositoryUpdate<OrderUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory OrderRepository._(Session db) = _OrderRepository;

  Future<OrderView?> queryOrder(int id);
  Future<List<OrderView>> queryOrders([QueryParams? params]);
}

class _OrderRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<OrderInsertRequest>,
        RepositoryUpdateMixin<OrderUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements OrderRepository {
  _OrderRepository(super.db) : super(tableName: 'orders', keyName: 'id');

  @override
  Future<OrderView?> queryOrder(int id) {
    return queryOne(id, OrderViewQueryable());
  }

  @override
  Future<List<OrderView>> queryOrders([QueryParams? params]) {
    return queryMany(OrderViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<OrderInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.execute(
      Sql.named('INSERT INTO "orders" ( "fio", "car_number", "cargo_name", "volume", "status" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.fio)}:text, ${values.add(r.car_number)}:text, ${values.add(r.cargo_name)}:text, ${values.add(r.volume)}:float8, ${values.add(r.status)}:text )').join(', ')}\n'
          'RETURNING "id"'),
      parameters: values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<OrderUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "orders"\n'
          'SET "fio" = COALESCE(UPDATED."fio", "orders"."fio"), "car_number" = COALESCE(UPDATED."car_number", "orders"."car_number"), "cargo_name" = COALESCE(UPDATED."cargo_name", "orders"."cargo_name"), "volume" = COALESCE(UPDATED."volume", "orders"."volume"), "status" = COALESCE(UPDATED."status", "orders"."status")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.fio)}:text::text, ${values.add(r.car_number)}:text::text, ${values.add(r.cargo_name)}:text::text, ${values.add(r.volume)}:float8::float8, ${values.add(r.status)}:text::text )').join(', ')} )\n'
          'AS UPDATED("id", "fio", "car_number", "cargo_name", "volume", "status")\n'
          'WHERE "orders"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class OrderInsertRequest {
  OrderInsertRequest({
    required this.fio,
    required this.car_number,
    required this.cargo_name,
    required this.volume,
    required this.status,
  });

  final String fio;
  final String car_number;
  final String cargo_name;
  final double volume;
  final String status;
}

class OrderUpdateRequest {
  OrderUpdateRequest({
    required this.id,
    this.fio,
    this.car_number,
    this.cargo_name,
    this.volume,
    this.status,
  });

  final int id;
  final String? fio;
  final String? car_number;
  final String? cargo_name;
  final double? volume;
  final String? status;
}

class OrderViewQueryable extends KeyedViewQueryable<OrderView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "orders".*'
      'FROM "orders"';

  @override
  String get tableAlias => 'orders';

  @override
  OrderView decode(TypedMap map) => OrderView(
      id: map.get('id'),
      fio: map.get('fio'),
      car_number: map.get('car_number'),
      cargo_name: map.get('cargo_name'),
      volume: map.get('volume'),
      status: map.get('status'));
}

class OrderView {
  OrderView({
    required this.id,
    required this.fio,
    required this.car_number,
    required this.cargo_name,
    required this.volume,
    required this.status,
  });

  final int id;
  final String fio;
  final String car_number;
  final String cargo_name;
  final double volume;
  final String status;
}
