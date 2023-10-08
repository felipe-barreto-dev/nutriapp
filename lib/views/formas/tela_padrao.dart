import 'package:flutter/material.dart';

class TelaPadrao extends StatelessWidget {
  final String _title;
  final List<Widget> _components;

  const TelaPadrao(this._title, this._components, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text(_title),
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Altere o valor conforme necessário
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _components,
            ),
          ),
        ),
      ),
    );
  }
}
