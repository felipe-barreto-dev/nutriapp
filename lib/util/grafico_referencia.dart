import 'package:flutter/material.dart';

class GraficoReferencia extends StatelessWidget {
  final String _asset;

  const GraficoReferencia(this._asset, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image(width: double.infinity, image: AssetImage(_asset));
  }
}
