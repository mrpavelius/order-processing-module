import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final conn = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'postgres',
        username: 'postgres',
        password: 'admin',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    final response =
        await handler.use(provider<Session>((_) => conn)).call(context);

    Future.delayed(const Duration(seconds: 5), () {
      conn.close();
    });
    return response;
  };
}
