import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Necessário para acessar a localização
import 'package:url_launcher/url_launcher.dart'; // Necessário para abrir URLs

class CepResultWidget extends StatelessWidget {
  final Map<String, dynamic> cepData;

  const CepResultWidget({Key? key, required this.cepData}) : super(key: key);

  // Método para determinar a posição atual
  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  // Método para lançar o URL do Google Maps
  void _launchMapsUrl(String latitude, String longitude, String destination) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$latitude,$longitude&destination=$destination&travelmode=driving';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not launch $googleUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("CEP: ${cepData['cep'] ?? 'Não disponível'}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Logradouro: ${cepData['logradouro'] ?? 'Não disponível'}"),
          Text("Complemento: ${cepData['complemento'] ?? 'Não disponível'}"),
          Text("Bairro: ${cepData['bairro'] ?? 'Não disponível'}"),
          Text("Localidade: ${cepData['localidade'] ?? 'Não disponível'}"),
          Text("UF: ${cepData['uf'] ?? 'Não disponível'}"),
          Text("IBGE: ${cepData['ibge'] ?? 'Não disponível'}"),
          Text("GIA: ${cepData['gia'] ?? 'Não disponível'}"),
          Text("DDD: ${cepData['ddd'] ?? 'Não disponível'}"),
          Text("SIAFI: ${cepData['siafi'] ?? 'Não disponível'}"),
          SizedBox(height: 20), // Espaçamento entre os textos e o botão
          ElevatedButton(
            onPressed: () async {
              try {
                Position position = await _determinePosition();
                _launchMapsUrl(position.latitude.toString(), position.longitude.toString(), cepData['logradouro']);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'))
                );
              }
            },
            child: const Text("Traçar Rota")
          ),
        ],
      ),
    );
  }
}
