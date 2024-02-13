import 'dart:io';

import 'package:cities_api/utils/customs.dart';
import 'package:shelf/shelf.dart';

final Map<String, _RequestCounter> _rateLimits = {};

Middleware rateLimitingMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final ip = request.headers['X-Forwarded-For']?.split(',').first.trim();

      if (ip == null) return Response.forbidden(kCannotDetIPAddressText);

      final now = DateTime.now();
      final counter = _rateLimits.putIfAbsent(ip, () => _RequestCounter(now, 0));

      if (now.difference(counter.timestamp).inMinutes >= 1) {
        counter.requests = 1;
        counter.timestamp = now;
      } else {
        counter.requests++;
      }

      if (counter.requests > 5) return Response(HttpStatus.tooManyRequests, body: kTooManyRequestText);
      return innerHandler(request);
    };
  };
}

class _RequestCounter {
  DateTime timestamp;
  int requests;
  _RequestCounter(this.timestamp, this.requests);
}
