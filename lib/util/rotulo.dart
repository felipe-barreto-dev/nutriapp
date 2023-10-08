import 'package:flutter/material.dart';

class Rotulo extends StatelessWidget {
  final String texto;

  const Rotulo(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        texto,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 26),
      ),
    );
  }
}
