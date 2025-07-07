import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajoexp/model/customer_model.dart';
import 'package:trabajoexp/enviroments/env.dart';

class CustomerService {
  final String baseUrl = "${Env.baseUrl}"; // 🔁 Cambia por tu URL real

  Future<void> createCustomer(int userId, CustomerRequest customer) async {
    final url = Uri.parse('$baseUrl/customer/$userId');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear customer: ${response.body}');
    }
  }
}