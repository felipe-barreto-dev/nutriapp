class FormaGeometrica {
  double _area = 0.0;
  String _geometria = "";

  get area {
    return _area.toStringAsFixed(2);
  }

  get geometria {
    return _geometria;
  }

  FormaGeometrica.quadrado({double lado = 0.0}) {
    _area = lado * lado;
    _geometria = "Quadrado";
  }

  FormaGeometrica.retangulo({double base = 0.0, double altura = 0.0}) {
    _area = base * altura;
    _geometria = "Retângulo";
  }

  FormaGeometrica.triangulo({double base = 0.0, double altura = 0.0}) {
    _area = (base * altura) / 2.0;
    _geometria = "Triângulo";
  }

  FormaGeometrica.circulo({double raio = 0.0}) {
    _area = 3.1459 * (raio * raio);
    _geometria = "Círculo";
  }

  FormaGeometrica.trapezio(
      {double baseMenor = 0.0, double baseMaior = 0.0, double altura = 0.0}) {
    _area = ((baseMenor + baseMaior) * altura) / 2.0;
    _geometria = "Trapézio";
  }
}
