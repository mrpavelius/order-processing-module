import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:db/db.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  await context.read<Session>().orders.query(
        SkipOrderQuery(id: 16),
        QueryParams(),
      );

  return Response.json(body: 'g');
}

class SkipOrderQuery extends Query<OrderView?, QueryParams> {
  final int id;

  SkipOrderQuery({required this.id});

  @override
  Future<OrderView?> apply(Session db, QueryParams params) async {
    final queryable = OrderViewQueryable();
    final tableName = queryable.tableAlias;
    final customQuery = """
      SELECT * FROM $tableName
      WHERE status='$id'
      ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
      ${params.limit != null ? "LIMIT ${params.limit}" : ""}
      ${params.offset != null ? "OFFSET ${params.offset}" : ""}
    """;

    var postgreSQLResult =
        await db.execute(customQuery, parameters: params.values);

    var objects = postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
    return objects.isNotEmpty ? objects.first : null;
  }
}
