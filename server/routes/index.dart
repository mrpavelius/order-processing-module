import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:db/db.dart';
import 'package:shared/shared.dart' as shared;

FutureOr<Response> onRequest(RequestContext context) async {
  final conn = await context.read<Session>();
  // final fs = await context.read<Session>().orders.query(
  //       FindOrderByStatusQuery(status: 'Текущий'),
  //       QueryParams(),
  //     );
  final ordersInDb = await conn.orders.queryOrders();
  final orders = ordersInDb.map((order) => shared.Order.fromDb(order).toJson());

  return Response.json(body: orders.toList());
}

// class FindOrderByStatusQuery extends Query<OrderView?, QueryParams> {
//   final String status;

//   FindOrderByStatusQuery({required this.status});

//   @override
//   Future<OrderView?> apply(Session db, QueryParams params) async {
//     final queryable = OrderViewQueryable();
//     final tableName = queryable.tableAlias;
//     final customQuery = """
//       SELECT * FROM $tableName
//       WHERE status='$status'
//       ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
//       ${params.limit != null ? "LIMIT ${params.limit}" : ""}
//       ${params.offset != null ? "OFFSET ${params.offset}" : ""}
//     """;

//     var postgreSQLResult =
//         await db.execute(customQuery, parameters: params.values);

//     var objects = postgreSQLResult
//         .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
//         .toList();
//     return objects.isNotEmpty ? objects.first : null;
//   }
// }
