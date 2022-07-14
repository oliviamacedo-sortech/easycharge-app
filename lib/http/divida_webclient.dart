import 'dart:convert';

import 'package:easycharge/models/dividaJson.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../models/divida.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // debugPrint('Request');
    // debugPrint('url: ${data.url}');
    // debugPrint('headers: ${data.headers}');
    // debugPrint('body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    // debugPrint('Response');
    // debugPrint('status code: ${data.statusCode}');
    // debugPrint('headers: ${data.headers}');
    // debugPrint('body: ${data.body}');
    return data;
  }
}

final Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()]
);

Future<List<DividaJson>> findAllDividas() async {
  final Response response =
  await client.get(Uri.http('localhost:8080', '/api/dividas')).timeout(Duration(seconds: 5));
  // await client.get(Uri.parse('http://10.0.2.2:8080/api/clientes'));
  // ignore: prefer_interpolation_to_compose_strings
  final List<dynamic> decodedJson = jsonDecode('[' + response.body + ']')[0]['content'];
  final List<DividaJson> dividas = [];

  for (Map<String, dynamic> dividaJson in decodedJson) {
    final DividaJson json = DividaJson(
      dividaJson['valor'],
      dividaJson['dataAbertura'],
      dividaJson['dataQuitacao'],
      dividaJson['statusDivida'],
      dividaJson['descricaoQuitacao'],
      dividaJson['idCliente'],
    );
    dividas.add(json);
  }

  return dividas;
}

Future<DividaJson> cadastroDivida(Divida divida) async {

  final String dividaJson = jsonEncode(divida.mapperJson());

  final Response response = await client.post(
      Uri.http('localhost:8080', '/api/dividas'),
      headers: {'Content-type': 'application/json'},
      body: dividaJson);

  Map<String, dynamic> json = jsonDecode(response.body);

  debugPrint(response.body);
  return DividaJson(json['valor'], json['dataAbertura'], json['dataQuitacao'], json['statusDivida'], json['descricaoQuitacao'],
      json['idCliente']);
}
