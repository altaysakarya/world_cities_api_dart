import 'dart:convert';

import 'package:cities_api/utils/cities.dart';
import 'package:cities_api/utils/customs.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

List<Map<String, String>> _searchCityWithName(String query) {
  List<Map<String, String>> result = [];

  var data = cities
      .where((element) =>
          (element['name']?.toLowerCase().contains(query) ?? false) ||
          (element['name']?.toLowerCase().replaceAll('_', '').contains(query) ?? false))
      .take(10);

  result = data.toList();
  return result;
}

Response getCityResults(Request request) {
  final query = request.params['query'];
  if ((query ?? '').isEmpty) return Response.badRequest();
  if ((query ?? '').length < kMinimumQueryChar) {
    return Response.badRequest(body: json.encode({'message': kMinimumCharLimitText, 'detail': []}));
  }
  return Response.ok(json.encode({'message': kCitySuccessfullyText, 'detail': _searchCityWithName(query!)}));
}
