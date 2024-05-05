import 'package:flutter/material.dart';
import 'package:test_drive/scr/modules/Home/page/tela_principal.dart';
import 'package:test_drive/scr/shared/colors/colors.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Aplicação Flutter',
      home: const TelaPrincipal(),
      theme: ThemeData(
        primarySwatch: AppColors.mainColor
      ),
    )
  );
}