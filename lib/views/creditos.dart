import 'package:flutter/material.dart';
import 'package:nutriapp/main.dart';
import 'package:nutriapp/views/cadastros/cadastro_usuario.dart';

class Creditos extends StatefulWidget {
  const Creditos({super.key});

  @override
  CreditosState createState() => CreditosState();
}

class CreditosState extends State<Creditos> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Créditos',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Créditos'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 200, // Altura do cabeçalho personalizado
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue, // Cor de fundo do cabeçalho
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo-app.png', // Substitua pelo caminho da sua imagem de logotipo
                      ),
                      const Text(
                        "Teste",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Home(),
                  ));
                },
              ),
              ListTile(
                title: const Text('Cadastro de Usuário'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CadastroUsuario(),
                  ));
                },
              ),
              ListTile(
                title: const Text('Créditos'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Creditos(),
                  ));
                },
              ),
              ListTile(
                title: const Text('Sair'),
                onTap: () {
                  // Implemente o código de saída aqui
                },
              ),
            ],
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Breno Mazzini Costa',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Felipe Barreto Pereira',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Gabrielle de Oliveira Bussi',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Luiz Felipe Barbosa Arruda',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Millena de Souza Netto',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Rafael Claro Ramiro',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
            ],
          ),
        )
      ),
    );
  }
}
