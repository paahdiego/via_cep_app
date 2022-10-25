import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:via_cep/address_model.dart';

class AddressRepository {
  final dio = Dio(BaseOptions(baseUrl: "https://viacep.com.br/ws/"));

  Future<AddressModel> getAddress({
    required String cep,
  }) async {
    try {
      final response = await dio.get("$cep/json");

      log(response.realUri.toString());

      log(response.data.toString());

      if (response.data['erro'] != null && response.data['erro'] == true) {
        throw "CEP não encontrado";
      }

      final address = AddressModel.fromMap(response.data);

      return address;
    } catch (e) {
      rethrow;
    }
  }
}
