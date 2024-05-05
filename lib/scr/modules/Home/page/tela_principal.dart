import 'package:flutter/material.dart';
import 'package:test_drive/scr/modules/Home/repositories/api_viacep.dart';
import 'package:test_drive/scr/modules/Home/repositories/local_storage_manager.dart';
import 'package:test_drive/scr/modules/Home/components/historico_localizacao.dart';
import 'package:test_drive/scr/modules/Home/components/cep_result_widget.dart';
import 'package:geolocator/geolocator.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final TextEditingController cepController = TextEditingController();
  List<Map<String, dynamic>> cepResults = [];
  bool isLoading = false;

  Future<Map<String, dynamic>?> buscarCEP(String cep) async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic>? data;
    try {
      data = await LocalStorageManager.getCEPData(cep);

      if (data == null) { // Se não encontrou no armazenamento local, busca na API
        data = await apiViaCEP(cep);
        if (data != null) {
          await LocalStorageManager.saveCEPData(cep, data); // Salva os dados localmente se foram encontrados
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP não encontrado.')));
        }
      }

      // Verificação segura se 'data' não é nulo e não contém duplicatas
      if (data != null) {
        String? cepValue = data['cep']; // Acesso seguro ao valor 'cep'
        if (cepValue != null && !cepResults.any((element) => element['cep'] == cepValue)) {
          setState(() {
            cepResults.add(data!); // Adiciona ao resultado de buscas apenas se não for duplicado
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar CEP: $e'))
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return data;
}


void showCepDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Digite o CEP"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: cepController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "00000000"),
                    ),
                    if (isLoading)
                      const CircularProgressIndicator(),
                    if (!isLoading && cepResults.isNotEmpty)
                      CepResultWidget(cepData: cepResults.last), // Exibe o último resultado de CEP buscado
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    cepController.clear(); // Limpa o campo de texto quando clicar em Cancelar
                    Navigator.of(dialogContext).pop(); // Fecha o diálogo
                  },
                ),
                TextButton(
                  child: const Text("Buscar"),
                  onPressed: () async {
                    setStateDialog(() => isLoading = true);
                    final data = await buscarCEP(cepController.text);
                    setStateDialog(() => isLoading = false);
                    if (data != null) {
                      setStateDialog(() {
                        if (!cepResults.any((element) => element['cep'] == data['cep'])) {
                          cepResults.add(data);
                        }
                      });
                    }
                    // Não limpar o campo de texto aqui, para permitir que o usuário veja o CEP buscado
                    // Navigator.of(dialogContext).pop(); // Comente esta linha se quiser manter o diálogo aberto
                  },
                ),
              ],
            );
          },
        );
      },
    );
}


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LOCALIZE-SE"),
        backgroundColor: Color.fromARGB(255, 42, 144, 151),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ElevatedButton(
              onPressed: showCepDialog,
              child: const Text("Localizar endereço"),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 219, 216, 216)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HistoricoLocalizacao(cepResults: cepResults)),
                );
              },
              child: const Text("Histórico de Busca"),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 219, 216, 216)),
            ),
            if (isLoading)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

