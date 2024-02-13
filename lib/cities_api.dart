import 'package:cities_api/api/cities.dart';
import 'package:cities_api/api/health.dart';
import 'package:cities_api/middleware/rate_limiting.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

Future<void> runApi() async {
  final router = Router();

  router.get('/cities/<query>/', (Request request) => getCityResults(request));
  router.get('/check/dart/', (Request request) => checkHealth());

  var handler = const Pipeline().addMiddleware(logRequests()).addMiddleware(rateLimitingMiddleware()).addHandler(router);

  await shelf_io.serve(handler, '0.0.0.0', 443);
}
