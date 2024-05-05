import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> apiViaCEP(String cep) async {
  // Validar se o CEP possui 8 dígitos e contém apenas números
  if (cep.length != 8 || !RegExp(r'^[0-9]+$').hasMatch(cep)) {
    throw FormatException("O CEP deve conter exatamente 8 dígitos numéricos.");
  }

  // Construir a URL de requisição
  String url = 'https://viacep.com.br/ws/$cep/json/';

  try {
    // Realizar a requisição HTTP
    http.Response response = await http.get(Uri.parse(url));

    // Verificar se a requisição foi bem-sucedida
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      // Verificar se o CEP foi encontrado
      if (data.containsKey('erro') && data['erro']) {
        return null;  // CEP não encontrado
      }

      print(data);
      return data;  // Retorno dos dados do CEP
    } else {
      // Tratamento de outros status de erro
      throw Exception("Erro ao buscar CEP: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Falha na conexão: $e");
  }
}