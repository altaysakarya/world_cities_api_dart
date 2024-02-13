import 'dart:convert';

import 'package:shelf/shelf.dart';

Response checkHealth(){
  return Response.ok(json.encode({'message': 'Health Status OK'}));
}