import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:db/db.dart';
import 'dart:io';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    await context.read<Session>().orders.query(
          SkipOrderQuery(),
          QueryParams(),
        );
    return Response();
  } else {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Method not allowed.',
    );
  }
}

class SkipOrderQuery extends Query<OrderView?, QueryParams> {
  @override
  Future<OrderView?> apply(Session db, QueryParams params) async {
    final customQuery = """
DO \$\$
DECLARE
    next_id INT;
BEGIN
    -- Получаем ID следующего заказа, который станет текущим
    WITH next_order AS (
        SELECT id
        FROM orders
        WHERE status = 'В ожидании'
        ORDER BY created_at ASC
        LIMIT 1
    )
    SELECT id INTO next_id FROM next_order;

    -- Проверим, существует ли новый заказ
    IF next_id IS NULL THEN
        RAISE EXCEPTION 'Нет новых заказов для назначения в текущие.';
    END IF;

    -- Если текущая заявка существует, меняем её статус на "В ожидании"
    IF EXISTS (SELECT 1 FROM orders WHERE status = 'Текущий') THEN
        -- Обновляем статус текущей заявки на "В ожидании"
        UPDATE orders
        SET status = 'В ожидании', updated_at = CURRENT_TIMESTAMP
        WHERE status = 'Текущий';
    END IF;

    -- Установим статус "Текущий" следующему заказу
    UPDATE orders
    SET status = 'Текущий'
    WHERE id = next_id;

    COMMIT;  -- Коммитим изменения
END \$\$;
    """;

    await db.execute(customQuery, parameters: params.values);
  }
}
