import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  final String _texto;
  final void Function() _onClique;

  const Botao(this._texto, this._onClique, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: _onClique,
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, 45),
                backgroundColor: const Color.fromARGB(255, 99, 230, 127)),
            child: Text(_texto, style: const TextStyle(fontSize: 26))));
  }
}

class BotaoCalcular extends StatelessWidget {
  final String _texto;
  final void Function() _onClique;

  const BotaoCalcular(this._texto, this._onClique, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: _onClique,
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, 45),
                shape: const StadiumBorder(),
                backgroundColor: Colors.deepOrange),
            child: Text(_texto, style: const TextStyle(fontSize: 26))));
  }
}
