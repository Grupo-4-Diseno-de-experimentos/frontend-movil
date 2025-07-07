class ObjectiveData {
  String? objetivoPrincipal;
  String? metodoPreferido;
  String? sexo;
  int? edad;
  double? altura;
  double? peso;
  String? nivelActividad;
  String? dietaPreferida;

  ObjectiveData(); // ✅ Constructor público normal

  ObjectiveData._privateConstructor();

  static final ObjectiveData instance = ObjectiveData._privateConstructor();

  void clear() {
    objetivoPrincipal = null;
    metodoPreferido = null;
    sexo = null;
    edad = null;
    altura = null;
    peso = null;
    nivelActividad = null;
    dietaPreferida = null;
  }
}