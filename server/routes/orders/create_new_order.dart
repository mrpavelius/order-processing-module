import 'dart:async';
import 'dart:convert'; // Для работы с JSON
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:db/db.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final conn = await context.read<Session>();
    final body = jsonDecode('${await context.request.body()}');
    print(body);
    conn.orders.insertOne(OrderInsertRequest(
        fio: body['fio'],
        car_number: body['car_number'],
        cargo_name: body['cargo_name'],
        volume: double.parse(body['volume']),
        status: body['status']));
    return Response();
  } else {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Method not allowed.',
    );
  }
}
