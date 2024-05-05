import 'package:flutter/material.dart';
import 'package:test_drive/scr/modules/Home/components/cep_data_table.dart';

class HistoricoLocalizacao extends StatelessWidget {
  final List<Map<String, dynamic>> cepResults;

  const HistoricoLocalizacao({Key? key, required this.cepResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de Localizações"),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Adiciona um pouco de padding em volta da tabela
        child: cepResults.isNotEmpty
            ? CepDataTable(cepDataList: cepResults)
            : Center(
                child: Text(
                  "Nenhum histórico disponível",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
      ),
    );
  }
}

