import 'package:flutter/material.dart';

class CepDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> cepDataList;

  const CepDataTable({Key? key, required this.cepDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Permite rolagem horizontal da tabela
      child: DataTable(
        columnSpacing: 38, // Ajusta o espaçamento entre colunas
        columns: const [
          DataColumn(label: Text('CEP')),
          DataColumn(label: Text('Logradouro')),
          DataColumn(label: Text('Complemento')),
          DataColumn(label: Text('Bairro')),
          DataColumn(label: Text('Localidade')),
          DataColumn(label: Text('UF')),
          DataColumn(label: Text('IBGE')),
          DataColumn(label: Text('GIA')),
          DataColumn(label: Text('DDD')),
          DataColumn(label: Text('SIAFI')),
        ],
        rows: cepDataList.map<DataRow>((data) => DataRow(
          cells: [
            DataCell(Text(data['cep'] ?? '')),
            DataCell(Text(data['logradouro'] ?? '')),
            DataCell(Text(data['complemento'] ?? '')),
            DataCell(Text(data['bairro'] ?? '')),
            DataCell(Text(data['localidade'] ?? '')),
            DataCell(Text(data['uf'] ?? '')),
            DataCell(Text(data['ibge'] ?? '')),
            DataCell(Text(data['gia'] ?? '')),
            DataCell(Text(data['ddd'] ?? '')),
            DataCell(Text(data['siafi'] ?? '')),
          ]
        )).toList(),
      ),
    );
  }
}
