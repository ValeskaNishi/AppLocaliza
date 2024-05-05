import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  // Salvar dados do CEP no armazenamento local
  static Future<void> saveCEPData(String cep, Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataString = jsonEncode(data);  // Convertendo os dados para uma string JSON
    await prefs.setString('cep_$cep', dataString);  // Salvando os dados com uma chave única para o CEP
  }

  // Recuperar dados do CEP do armazenamento local
  static Future<Map<String, dynamic>?> getCEPData(String cep) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataString = prefs.getString('cep_$cep');
    if (dataString != null) {
      return jsonDecode(dataString) as Map<String, dynamic>;
    }
    return null;
  }
}