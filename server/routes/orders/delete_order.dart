import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:db/db.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final params = await context.request.uri.queryParameters;

    final id = int.parse(params['id']!);

    final conn = await context.read<Session>();
    if (await conn.orders.queryOrder(id) != null)
    {
      await conn.orders.deleteOne(id);
      return Response();
    }
    else
    {
      return Response(
        statusCode: HttpStatus.notFound,
        body: 'Order with ID $id not found!'
      );
    }


  } else {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Method not allowed.',
    );
  }
}
